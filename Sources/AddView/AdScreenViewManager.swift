//
//  Created by Developer on 07.12.2022.
//
import Combine
import UIKit
import SnapKit
import OpenURL
import Architecture
import AlertService
import Sentry
import UserDefaultsStandard
import WebKit
import Reachability

final public class AdScreenViewManager: ViewManager<AdScreenViewController> {
    
    var viewProperties: AdScreenViewController.ViewProperties?
    
    // MARK: - public properties -
    public let closeAction: CurrentValueSubject<Bool, Never> = .init(false)
    
    private var webBannerViewManager: WebBannerViewManager?
    private var errorViewManager: ErrorViewManager?
	private var errorWebView: WKWebView? = WKWebView()
    private var isErrorPresent = true
    
    // MARK: - private properties -
    private let advertisingNavigationDelegate = AdvertisingNavigationDelegate()
    private let advertisingUIDelegate = AdvertisingUIDelegate()
    private let openURL = OpenURL()
    private let alertService = AlertService()
    
    //MARK: - Main state view model
    public enum State {
        case createViewProperties(AdvertisingModel)
        case close(Bool)
        case tapBack
        case updateViewProperties
    }
    
    public var state: State? {
        didSet { self.stateModel() }
    }

    private func stateModel() {
        guard let state = self.state else { return }
        switch state {
        case .createViewProperties(let advertisingModel):
            let tapForward: ClosureEmpty = {
                self.advertisingNavigationDelegate.webView?.goForward()
            }
            let tapBack: ClosureEmpty = {
				if let homeUrl = self.viewProperties?.advertisingModel.homeUrl {
					self.viewProperties?.isNavBarHidden = true
					self.viewProperties?.isLoadWebView = true
					self.viewProperties?.advertisingModel.hostAdvertising = homeUrl.host ?? ""
					self.viewProperties?.advertisingModel.urlAdvertising = homeUrl
					self.state = .updateViewProperties
					self.viewProperties?.advertisingModel.homeUrl = nil
					self.viewProperties?.isLoadWebView = false
				} else {
					self.advertisingNavigationDelegate.webView?.goBack()
					self.viewProperties?.isNavBarHidden = !(self.advertisingNavigationDelegate.webView?.canGoBack == true)
					if self.isCurrentSite() {
						self.viewProperties?.isNavBarHidden = true
					}
					self.state = .updateViewProperties
				}
            }
            let updatePage: ClosureEmpty = {
                self.advertisingNavigationDelegate.webView?.reload()
            }
            self.advertisingNavigationDelegate.openBanner = { absoluteString in
                guard let absoluteString = absoluteString else { return }
                self.openURL(with: absoluteString)
            }
            self.advertisingNavigationDelegate.didFinish = { isFinish in
                self.viewProperties?.isFinish = isFinish
                self.update?(self.viewProperties)
            }
            viewProperties = AdScreenViewController.ViewProperties(
                advertisingNavigationDelegate: advertisingNavigationDelegate,
                advertisingUIDelegate: advertisingUIDelegate,
                advertisingModel: advertisingModel,
                tapForward: tapForward,
                tapBack: tapBack,
				isFinish: false,
				isHiddenLoadView: true,
                updatePage: updatePage,
                closeAction: closeAction,
                isNavBarHidden: false,
                addAndCreateBannerView: addAndCreateBannerView,
                addAndCreateErrorView: addAndCreateErrorView,
                isLoadWebView: false,
                reloadContent: internetСheck
            )
            self.setupErrorWebView { [weak self] isLoad in
                guard let self = self else { return }
                guard isLoad else { return }
                self.subscribeDelegate()
            }
            self.setupNavigationError()
			self.internetСheck()
            create?(viewProperties)
        case .close(let isClose):
            closeAction.send(isClose)
            
        case .tapBack:
            self.advertisingNavigationDelegate.webView?.goBack()
            
        case .updateViewProperties:
            update?(viewProperties)
        }
    }
    
    private func subscribeDelegate(){
        self.advertisingNavigationDelegate.didFinish = { [weak self] isFinish in
            guard let self = self else { return }
            self.viewProperties?.isFinish = isFinish
            self.state = .updateViewProperties
        }
        
        self.advertisingNavigationDelegate.navBar = { [weak self] absoluteString in
            guard BannerURL.isOpen(with: absoluteString) else {
                self?.viewProperties?.isNavBarHidden = true
                self?.state = .updateViewProperties
                return
            }
            self?.viewProperties?.isNavBarHidden = false
            self?.state = .updateViewProperties
        }
        
        self.advertisingNavigationDelegate.redirect = { [weak self] navigationAction in
            guard let self = self else { return }
            self.state = .updateViewProperties
        }
        
        self.advertisingNavigationDelegate.navigationResponseAction = { [weak self] url in
            guard let self = self else { return }
            self.viewProperties?.isNavBarHidden = self.isCurrentSite(host: url?.host)
            self.state = .updateViewProperties
        }
        
        self.advertisingNavigationDelegate.webViewAction = { [weak self] webView in
            self?.internetСheck()
            guard let self = self else { return }
            guard let host = self.viewProperties?.advertisingModel.hostAdvertising else {
                self.viewProperties?.isNavBarHidden = true
                self.state = .updateViewProperties
                return
            }
            guard let isCurrent = webView?.url?.host?.contains(host) else {
                self.viewProperties?.isNavBarHidden = true
                self.state = .updateViewProperties
                return
            }
            self.viewProperties?.isNavBarHidden = isCurrent
            self.state = .updateViewProperties
        }
    }
    
    private func isCurrentSite(host: String?) -> Bool {
        guard let host = host else {
            return false
        }
        guard let isCurrent = self.viewProperties?.advertisingModel.hostAdvertising.contains(host) else {
            return false
        }
        return isCurrent
    }
    
    private func addAndCreateBannerView(with containerView: UIView) {
        let webBannerViewBuilder = WebBannerViewBuilder.build()
        let webBannerView = webBannerViewBuilder.view
        containerView.addSubview(webBannerView)
        webBannerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.webBannerViewManager = webBannerViewBuilder.viewManager
        self.webBannerViewManager?.state = .presentBanner(false)
    }
    
    private func addAndCreateErrorView(with containerView: UIView) {
        let errorViewBuilder = ErrorViewBuilder.build()
        let errorView = errorViewBuilder.view
        containerView.addSubview(errorView)
        errorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        self.errorViewManager = errorViewBuilder.viewManager
        self.errorViewManager?.state = .createViewProperties(didTapMain, didTapSupport)
        internetСheck()
    }
    
    private func internetСheck(){
        self.errorViewManager?.state = .hidden(InternetСheckService.check())
    }
    
    private func setupNavigationError(){
        self.advertisingNavigationDelegate.navigationError = { [weak self] statusCode, urlError in
            guard let self = self else { return }
			if !isRequestSuccess(statusCode: statusCode) {
				let urlAdvertising = self.viewProperties!.advertisingModel.urlAdvertising!
                let urlError = urlError ?? urlAdvertising
                self.errorViewManager?.state = .hidden(false)
				self.sendSentry(statusCode: statusCode, urlError: urlError)
				AmplitudeEventConstants.ON_WEBVIEW_PAGE_ERROR(urlError, statusCode.toString()).pushEvent()
            }
        }
    }
    
    private func setupErrorWebView(completion: @escaping Closure<Bool>){
		self.errorWebView = WKWebView()
        self.isErrorPresent = true
        self.errorWebView?.navigationDelegate = self.advertisingNavigationDelegate
        guard let urlAdvertising = viewProperties?.advertisingModel.urlAdvertising else { return }
        self.advertisingNavigationDelegate.navigationStartError = { [weak self] statusCode, urlError in
            guard let self = self else { return }
            guard self.isErrorPresent else { return }
            if !isRequestSuccess(statusCode: statusCode) {
				let urlAdvertising = self.viewProperties!.advertisingModel.urlAdvertising!
                let urlError = urlError ?? urlAdvertising
                self.errorViewManager?.state = .hidden(false)
				self.sendSentry(statusCode: statusCode, urlError: urlError)
				AmplitudeEventConstants.ON_WEBVIEW_PAGE_ERROR(urlError, statusCode.toString()).pushEvent()
                completion(false)
            } else {
                self.viewProperties?.isLoadWebView = true
                self.errorViewManager?.state = .hidden(true)
				self.errorWebView = nil
                self.update?(self.viewProperties)
                completion(true)
                self.viewProperties?.isLoadWebView = false
            }
            self.isErrorPresent = false
        }
        let urlRequest = URLRequest(url: urlAdvertising)
        self.errorWebView?.load(urlRequest)
    }
	
	private func sendSentry(statusCode: Int, urlError: URL){
		let current = Date().toStaring(format: .orderDateTime)
		SentrySDK.capture(message: "NavigationDelegate url error \(urlError), time: \(current), error code: \(statusCode)")
	}

    private func didTapMain() {
        self.setupErrorWebView { [weak self] isLoad in
            guard let self = self else { return }
            guard isLoad else { return }
            self.viewProperties?.isLoadWebView = true
            self.errorViewManager?.state = .hidden(true)
            self.state = .updateViewProperties
            self.viewProperties?.isLoadWebView = false
        }
    }
    
    private func didTapSupport() {
        let liveChatService = LiveChatService()
        liveChatService.presentChat()
    }
    
    private func openURL(with absoluteString: String?){
        guard BannerURL.isOpen(with: absoluteString) else { return }
        let bannerURL = BannerURL.isOpenApp(with: absoluteString)
        switch bannerURL {
        case .tg:
            let isOpen: Bool? = UserDefaultsStandard.shared.get(key: .isTelegramOpen)
            guard let absoluteString = absoluteString else { return }
            
            guard let isOpen = isOpen, !isOpen else {
                if let url = URL(string: absoluteString) {
                    self.openURL.open(with: .telegram(url))
                }
                return
            }
            alertService.options(title: "Telegramm", message: "Вы пользуетесь Telegramm?", options: TelegramAlert()){ index in
                if index == 0 {
                    if let url = URL(string: absoluteString) {
                        self.openURL.open(with: .telegram(url))
                    }
                } else {
                    self.openURL.open(with: .urlList(.telegramApp))
                }
                UserDefaultsStandard.shared.save(key: .isTelegramOpen, value: true)
            }
            
        default:
            break
        }
    }
    
    private func isCurrentSite() -> Bool {
        guard let hostAdvertising = self.viewProperties?.advertisingModel.hostAdvertising else {
            return false
        }
        guard let isCurrent = advertisingNavigationDelegate.webView?.url?.host?.contains(hostAdvertising) else {
            return false
        }
        return isCurrent
    }
	
	private func isRequestSuccess(statusCode: Int) -> Bool {
		if statusCode < 500 && statusCode > 399,
		   let _ =  self.viewProperties?.advertisingModel.urlAdvertising,
		   statusCode != 429 {
			return false
		} else {
			return true
		}
	}
}
