//
//  Created by Developer on 07.12.2022.
//
import SkeletonView
import Combine
import UIKit
import WebKit
import AlertService
import Architecture

final public class AdScreenViewController: UIViewController, ViewProtocol {
    
    //MARK: - Main ViewProperties
    public struct ViewProperties {
        let advertisingNavigationDelegate: AdvertisingNavigationDelegate
        let advertisingUIDelegate: AdvertisingUIDelegate
        var advertisingModel: AdvertisingModel
        let tapForward: ClosureEmpty
        let tapBack: ClosureEmpty
        var isFinish: Bool
		var isHiddenLoadView: Bool
        let updatePage: ClosureEmpty
        let closeAction: CurrentValueSubject<Bool, Never>
        var isNavBarHidden: Bool
        let addAndCreateBannerView: Closure<UIView>
        let addAndCreateErrorView: Closure<UIView>
        var isLoadWebView: Bool
        let reloadContent: ClosureEmpty
    }
    public var viewProperties: ViewProperties?
    private var anyCancel: Set<AnyCancellable> = []
    private var configurationWKWebView: WKWebView!
    private var urlAdvertising: String = ""
    private let alertService = AlertService()
	
    //MARK: - Outlets
    @IBOutlet weak private var webView: WKWebView!
    @IBOutlet weak private var urlLabel: UILabel!
	@IBOutlet weak private var loadingView: UIView!
    @IBOutlet weak private var advertisingNavigationBar: UINavigationBar!
    @IBOutlet weak private var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak private var topActivityIndicatorView: UIActivityIndicatorView!
    
    public func update(with viewProperties: ViewProperties?) {
        self.viewProperties = viewProperties
        setupWebViewURL()
        skeletonLoading()
        setUrlLabel()
        setAdvertisingTitleLabel()
        setNavBar()
		setupLoadingView(with: viewProperties)
    }
    
    public func create(with viewProperties: ViewProperties?) {
        self.viewProperties = viewProperties
        setupWebViewURL()
        setUrlLabel()
        setAdvertisingTitleLabel()
        skeletonLoading()
        setNavBar()
        viewProperties?.addAndCreateBannerView(self.view)
        viewProperties?.addAndCreateErrorView(self.view)
        self.urlAdvertising = viewProperties?.advertisingModel.urlAdvertising?.absoluteString ?? ""
        scrollSetup()
		setupLoadingView(with: viewProperties)
    }
    
    private func setupDelegate() {
        self.configurationWKWebView?.navigationDelegate = viewProperties?.advertisingNavigationDelegate
        self.configurationWKWebView?.uiDelegate = viewProperties?.advertisingUIDelegate
    }
    
    private func setupWebViewURL() {
        guard let urlAdvertising = viewProperties?.advertisingModel.urlAdvertising else { return }
        guard viewProperties?.isLoadWebView == true else { return }
        let urlRequest = URLRequest(url: urlAdvertising)
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        self.configurationWKWebView = WKWebView(
            frame: .zero,
            configuration: configuration
        )
        self.webView.addSubview(configurationWKWebView)
        self.setupDelegate()
        self.configurationWKWebView?.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
		AmplitudeEventConstants.ON_WEBVIEW_PAGE_START_LOADING(urlAdvertising).pushEvent()
        configurationWKWebView.load(urlRequest)
        scrollSetup()
    }
	
	private func setupLoadingView(with viewProperties: ViewProperties?){
	   guard let isHiddenLoadView = viewProperties?.isHiddenLoadView else { return }
		self.loadingView.isHidden = isHiddenLoadView
	}
    
    private func skeletonLoading(){
        guard let isFinish = self.viewProperties?.isFinish else { return }
        if !isFinish {
            activityIndicatorView.isHidden = false
            activityIndicatorView.startAnimating()
        } else {
            activityIndicatorView.stopAnimating()
            activityIndicatorView.isHidden = true
        }
    }

    private func scrollSetup(){
        self.configurationWKWebView?.scrollView.delegate = self
    }
    
    //MARK: - Buttons
    @IBAction func tapForwardButton(button: UIButton){
        self.viewProperties?.tapForward()
    }
    
    @IBAction func tapBackButton(button: UIButton){
        self.viewProperties?.tapBack()
    }
    
    @IBAction func updatePageButton(button: UIButton){
        configurationWKWebView?.reload()
    }
    
    @IBAction func closeButton(button: UIButton){
        self.viewProperties?.closeAction.send(true)
    }
    
    private func setAdvertisingTitleLabel(){
        guard let titleAdvertising = viewProperties?.advertisingModel.titleAdvertising else {
            return
        }
        advertisingNavigationBar.items?.first?.title = titleAdvertising
        advertisingNavigationBar.isHidden = titleAdvertising.isEmpty
        advertisingNavigationBar.items?.first?.title = ""
    }
    
    private func setNavBar(){
        guard let isNavBarHidden = viewProperties?.isNavBarHidden else {
            return
        }
        advertisingNavigationBar.isHidden = isNavBarHidden
		if (self.configurationWKWebView?.canGoBack == false) && (viewProperties?.advertisingModel.homeUrl == nil) {
            advertisingNavigationBar.isHidden = true
		} else if (self.configurationWKWebView?.canGoBack == false) {
			advertisingNavigationBar.isHidden = isNavBarHidden
		} else {
			advertisingNavigationBar.isHidden = isCurrentSite()
		}
		guard self.viewProperties?.advertisingModel.homeUrl != nil else { return }
		advertisingNavigationBar.isHidden = false
    }
    
    private func setUrlLabel(){
        #if DEBUG
        guard let urlAdvertising = viewProperties?.advertisingModel.urlAdvertising else {
            urlLabel.isHidden = true
            return
        }
        urlLabel.text = urlAdvertising.absoluteString
        urlLabel.isHidden = false
        #else
        urlLabel.isHidden = true
        #endif
    }
	
	private func isCurrentSite() -> Bool {
		guard let hostAdvertising = self.viewProperties?.advertisingModel.hostAdvertising else {
			return false
		}
		guard let isCurrent = configurationWKWebView?.url?.host?.contains(hostAdvertising) else {
			return false
		}
		return isCurrent
	}
    
    // MARK: - Override
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil, completion: {_ in
           // self.configurationWKWebView?.evaluateJavaScript("location.reload();", completionHandler: nil)
        })
    }
    
    // Enable detection of shake motion
    public override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard let isCopyUrl = viewProperties?.advertisingModel.isCopyUrl else {
            return
        }
        guard let urlAdvertising = viewProperties?.advertisingModel.urlAdvertising else {
            return
        }
        if motion == .motionShake, isCopyUrl {
            UIPasteboard.general.string = urlAdvertising.absoluteString
        }
    }
    
    private func reloadContent(_ scrollView: UIScrollView){
		guard InternetСheckService.check() else {
			self.viewProperties?.reloadContent()
			return
		}
        if scrollView.isTop(to: 70) {
            topActivityIndicatorView.show(true)
            if scrollView.isTop(to: 140) {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0) {
                    scrollView.isScrollEnabled = false
                    FeedbackGenerator.impactFeedback(.medium)
                    self.configurationWKWebView?.scrollView.contentInset = UIEdgeInsets(top: -10, left: 0, bottom: 0, right: 0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.configurationWKWebView?.evaluateJavaScript("location.reload();") {_,_ in
                            scrollView.isScrollEnabled = true
                            self.configurationWKWebView?.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        }
                    }
                    self.configurationWKWebView?.layoutIfNeeded()
                    self.view.layoutIfNeeded()
                }
            }
        } else {
            scrollView.isScrollEnabled = true
            topActivityIndicatorView.show(false)
        }
    }

    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension AdScreenViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        reloadContent(scrollView)
    }
}
