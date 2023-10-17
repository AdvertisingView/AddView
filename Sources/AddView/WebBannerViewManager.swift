//
//  Created by Developer on 07.12.2022.
//
import Foundation
import Architecture

final class WebBannerViewManager: ViewManager<WebBannerView> {
    
    var viewProperties: WebBannerView.ViewProperties?
    
    // MARK: - private properties -
    private let advertisingNavigationDelegate: AdvertisingNavigationDelegate
    private let advertisingUIDelegate: AdvertisingUIDelegate
    
    init(
        advertisingNavigationDelegate: AdvertisingNavigationDelegate,
        advertisingUIDelegate: AdvertisingUIDelegate
    ) {
        self.advertisingNavigationDelegate = advertisingNavigationDelegate
        self.advertisingUIDelegate = advertisingUIDelegate
    }
    
    //MARK: - Main state view Manager
    enum State {
        case createViewProperties(String)
        case updateUrl(URL)
        case presentBanner(Bool)
    }
    
    public var state: State? {
        didSet { self.stateManager() }
    }
    
    private func stateManager(){
        guard let state = self.state else { return }
        switch state {
            case .createViewProperties(let absoluteString):
                guard BannerURL.isOpen(with: absoluteString) else { return }
                let url = URL(string: absoluteString)
                viewProperties =  WebBannerView.ViewProperties(
                    advertisingNavigationDelegate: advertisingNavigationDelegate,
                    advertisingUIDelegate: advertisingUIDelegate,
                    bannerURL: url,
                    isPresentBanner: true
                )
                create?(viewProperties)
                
            case .updateUrl(let bannerURL):
                viewProperties?.bannerURL = bannerURL
                update?(viewProperties)
                
            case .presentBanner(let isPresent):
                viewProperties?.isPresentBanner = isPresent
                update?(viewProperties)
        }
    }
}
