//
//  ErrorViewManager.swift
//  OlimpicFind
//
//  Created by Senior Developer on 21.06.2023.
//
import Foundation
import Architecture

final class ErrorViewManager: ViewManager<ErrorView> {
    
    private var viewProperties: ErrorView.ViewProperties?
    
    
    //MARK: - Main state view Manager
    enum State {
        case createViewProperties(ClosureEmpty, ClosureEmpty)
        case hidden(Bool)
    }
    
    public var state: State? {
        didSet { self.stateManager() }
    }
    
    private func stateManager(){
        guard let state = self.state else { return }
        switch state {
        case .createViewProperties(let didTapMain, let didTapSupport):
            self.viewProperties = ErrorView.ViewProperties(
                isHidden: true,
                didTapMain: didTapMain,
                didTapSupport: didTapSupport
            )
            self.create?(self.viewProperties)
            
        case .hidden(let isHidden):
            self.viewProperties?.isHidden = isHidden
            self.update?(self.viewProperties)
			guard !isHidden else { return }
			AmplitudeEventConstants.ON_SHOW_ERROR_SCREEN.pushEvent()
        }
    }
}
