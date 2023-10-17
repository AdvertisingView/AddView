//
//  Created by Developer on 07.12.2022.
//
import UIKit
import WebKit
import Architecture

final class WebBannerView: UIView, ViewProtocol {
    
    struct ViewProperties {
        let advertisingNavigationDelegate: AdvertisingNavigationDelegate
        let advertisingUIDelegate: AdvertisingUIDelegate
        var bannerURL: URL?
        var isPresentBanner: Bool
    }
    var viewProperties: ViewProperties?
    
    @IBOutlet weak private var webView: WKWebView!
    
    func create(with viewProperties: ViewProperties?) {
        self.viewProperties = viewProperties
        setup()
        setupWebViewURL()
        presentBanner()
    }
    
    func update(with viewProperties: ViewProperties?) {
        self.viewProperties = viewProperties
        setupWebViewURL()
        presentBanner()
    }
    
    private func setup() {
        self.webView.navigationDelegate = viewProperties?.advertisingNavigationDelegate
        self.webView.uiDelegate = viewProperties?.advertisingUIDelegate
    }
    
    private func setupWebViewURL() {
        guard let bannerURL = viewProperties?.bannerURL else { return }
        webView.configuration.preferences.javaScriptEnabled = true
        webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        let request = URLRequest(url: bannerURL)
        webView.load(request)
    }
    
    private func presentBanner(){
        guard let isPresentBanner = viewProperties?.isPresentBanner else {
            self.isHidden = true
            return
        }
        self.isHidden = !isPresentBanner
    }
    
    @IBAction func closeButton(button: UIButton){
        self.isHidden = true
    }
}
