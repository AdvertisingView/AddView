//
//  Created by Developer on 07.12.2022.
//
import UIKit
import Architecture
import OpenURL
import AlertService

final public class AdScreenViewControllerBuilder: BuilderProtocol {
    
    public typealias V  = AdScreenViewController
    public typealias VM = AdScreenViewManager
    
    public var view: AdScreenViewController
    public var viewManager: AdScreenViewManager
    
    public static func create() -> AdScreenViewControllerBuilder {
        let viewController = AdScreenViewController()
        let viewManager    = AdScreenViewManager()
        viewController.loadViewIfNeeded()
        viewManager.bind(with: viewController)
        let selfBuilder = AdScreenViewControllerBuilder(
            with: viewController,
            with: viewManager
        )
        return selfBuilder
    }
    
    private init(
        with viewController: AdScreenViewController,
        with viewManager: AdScreenViewManager
    ) {
        self.view = viewController
        self.viewManager = viewManager
    }
}

