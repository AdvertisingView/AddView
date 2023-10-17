//
//  Created by Developer on 07.12.2022.
//
import UIKit
import Architecture

final class WebBannerViewBuilder: BuilderProtocol {
    
    typealias V  = WebBannerView
    typealias VM = WebBannerViewManager
    
    public var view       : WebBannerView
    public var viewManager: WebBannerViewManager
    
    public static func build() -> WebBannerViewBuilder {
        let view        = WebBannerView.loadNib()
        let viewManager = WebBannerViewManager(
            advertisingNavigationDelegate: AdvertisingNavigationDelegate(),
            advertisingUIDelegate: AdvertisingUIDelegate()
        )
        viewManager.bind(with: view)
        let selfBuilder = WebBannerViewBuilder(
            with: view,
            with: viewManager
        )
        return selfBuilder
    }
    
    private init(
        with view: WebBannerView,
        with viewManager: WebBannerViewManager
    ) {
        self.view        = view
        self.viewManager = viewManager
    }
}

