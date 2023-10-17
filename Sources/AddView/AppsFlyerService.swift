//
//  Created by Developer on 07.12.2022.
//
import AppsFlyerLib
import AppFlyerFramework
import Foundation
import Combine
import UIKit

final class AppsFlyerService {
    
    private let appsFlyerManager = AppsFlyerManager()
    private var anyCancel: Set<AnyCancellable> = []
    
    public var appsFlayerInstall: Install?
    public var installCompletion = PassthroughSubject<Install, Never>()
    public var completionDeepLinkResult: ((DeepLinkResult) -> Void)?
    
    private let devKey: String
    private let appID : String
    
    init(
        devKey: String,
        appID: String
    ) {
        self.devKey = devKey
        self.appID = appID
    }
    
    public func start(isIDFA: Bool){
        appsFlyerManager.startWithDeeplink()
    }
    
    public func setup(){
        setupParseAppsFlyerData()
        setupAppsFlyerDeepLinkDelegate()
        appsFlyerManager.setup(
            appID : appID,
            devKey: devKey
        )
    }
    
    public func setupParseAppsFlyerData(){
        appsFlyerManager.installCompletion.sink { [weak self] install in
            guard let self = self else { return }
            self.appsFlayerInstall = install
            self.installCompletion.send(install)
        }.store(in: &anyCancel)
    }
    
    public func setupAppsFlyerDeepLinkDelegate(){
        appsFlyerManager.completionDeepLinkResult = { deepLinkResult in
            self.completionDeepLinkResult?(deepLinkResult)
        }
    }
}
