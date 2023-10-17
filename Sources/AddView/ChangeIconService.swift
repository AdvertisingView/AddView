//
//  ChangeIconService.swift
//  
//
//  Created by Senior Developer on 10.07.2023.
//
import Sentry
import UIKit

public struct ChangeIconService {
	
	public func setIcon(tconName: IconName){
		guard UIApplication.shared.supportsAlternateIcons else { return }

		UIApplication.shared.setAlternateIconName(tconName.rawValue) { error in
			guard let error = error else { return }
			let current = Date().toStaring(format: .orderDateTime)
			SentrySDK.capture(message: "Set alternate icon name: \(tconName), error: \(error), time: \(current)")
		}
	}
	
	public enum IconName: String {
		case main
		case second
	}
	
	public init(){}
}
