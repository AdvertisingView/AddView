//
//  ErrorViewBuilder.swift
//  OlimpicFind
//
//  Created by Senior Developer on 21.06.2023.
//
import UIKit
import Architecture

final class ErrorViewBuilder: BuilderProtocol {
    
    typealias V  = ErrorView
    typealias VM = ErrorViewManager
    
    public var view       : ErrorView
    public var viewManager: ErrorViewManager
    
    public static func build() -> ErrorViewBuilder {
        let view        = ErrorView.loadNib()
        let viewManager = ErrorViewManager()
        viewManager.bind(with: view)
        let selfBuilder = ErrorViewBuilder(
            with: view,
            with: viewManager
        )
        return selfBuilder
    }
    
    private init(
        with view: ErrorView,
        with viewManager: ErrorViewManager
    ) {
        self.view        = view
        self.viewManager = viewManager
    }
}

