//
//  AmplitudeService.swift
//  
//
//  Created by Senior Developer on 26.07.2023.
//
import Amplitude
import Foundation

public struct AmplitudeService {
	
	public func setup(with amplitudeAPIKEY: String){
		Amplitude.instance().initializeApiKey("357e9c2f4b5f53ce1b2a679c8171f566")
		AmplitudeEventConstants.START_APP.pushEvent()
	}
	
	public init(){}
}

public enum AmplitudeEventConstants {
	
	case ON_FIREBASE_URL(URL?)
	case START_APP
	case ON_CONVERSION_SUCCESS_EVENT
	case ON_CONVERSION_FAILED_EVENT
	case ON_CONVERSION_FAILED_REASON_KEY
	case ON_DEEP_LINK_FOUND_EVENT([String: String]?)
	case ON_DEEP_LINK_NOT_FOUND_EVENT
	case ON_SHOW_ERROR_SCREEN
	case ON_WEBVIEW_PAGE_START_LOADING(URL?)
	case ON_WEBVIEW_PAGE_FINISH_LOADING(URL?)
	case ON_WEBVIEW_PAGE_ERROR(URL?, String)
	case ON_MINDBOX_PUSH_CLICK
	case ON_RETRY_CLICK
	
	
	case GET_FIREBASE_MODEL(RequestDataModel?)
	case PRESENT_FIREBASE_MODEL(AdvertisingModel?)
	case GET_FIREBASE_MODEL_ERROR(String)

	case GET_DEEP_LINK_MODEL([String: String])
	case PRESENT_DEEP_LINK_MODEL([String: String])
	
	
	
	public func pushEvent() {
		Amplitude.instance().logEvent(
			self.event(),
			withEventProperties: self.createEventProperties()
		)
	}
	
	private func createEventProperties() -> [AnyHashable : Any] {
		switch self {
			case .ON_FIREBASE_URL(let url):
				return ["url": url?.absoluteString ?? ""]
			case .START_APP:
				return [:]
			case .ON_CONVERSION_SUCCESS_EVENT:
				return [:]
			case .ON_CONVERSION_FAILED_EVENT:
				return [:]
			case .ON_CONVERSION_FAILED_REASON_KEY:
				return [:]
			case .ON_DEEP_LINK_FOUND_EVENT(let parameters):
				return parameters ?? [:]
			case .ON_DEEP_LINK_NOT_FOUND_EVENT:
				return [:]
			case .ON_SHOW_ERROR_SCREEN:
				return [:]
			case let .ON_WEBVIEW_PAGE_START_LOADING(url):
				return ["url": url?.absoluteString ?? ""]
			case let .ON_WEBVIEW_PAGE_FINISH_LOADING(url):
				return ["url": url?.absoluteString ?? ""]
			case let .ON_WEBVIEW_PAGE_ERROR(url, code):
				return ["url": url?.absoluteString ?? "", "code": code]
			case .ON_MINDBOX_PUSH_CLICK:
				return [:]
			case .ON_RETRY_CLICK://нажатие на кнопку обновить
				return [:]
			
			case .GET_FIREBASE_MODEL(let model)://модель полученная с фаирбеис
				return ["model": model as Any]
			case .GET_FIREBASE_MODEL_ERROR(let error)://модель полученная с фаирбеис
				return ["error": error]
			case .PRESENT_FIREBASE_MODEL(let model)://модель фаирбеис отправленная в SDK
				return ["model": model as Any]
			case .GET_DEEP_LINK_MODEL(let model)://модель полученная с deep link
				return ["model": model]
			case .PRESENT_DEEP_LINK_MODEL(let model)://модель deep link отправленная в SDK
				return ["model": model]
		}
	}
	
	private func event() -> String {
		switch self {
			case .ON_FIREBASE_URL:
				return "onFirebaseUrl"
			case .START_APP:
				return "appStart"
			case .ON_CONVERSION_SUCCESS_EVENT:
				return "onConversionSuccess"
			case .ON_CONVERSION_FAILED_EVENT:
				return "onConversionFailed"
			case .ON_CONVERSION_FAILED_REASON_KEY:
				return "reason"
			case .ON_DEEP_LINK_FOUND_EVENT:
				return "onDeepLinkFound"
			case .ON_DEEP_LINK_NOT_FOUND_EVENT:
				return "onDeepLinkNotFound"
			case .ON_SHOW_ERROR_SCREEN:
				return "showErrorScreen"
			case .ON_WEBVIEW_PAGE_START_LOADING:
				return "onWebViewPageStartLoading"
			case .ON_WEBVIEW_PAGE_FINISH_LOADING:
				return "onWebViewPageFinishLoading"
			case .ON_WEBVIEW_PAGE_ERROR:
				return "webViewPageError"
			case .ON_MINDBOX_PUSH_CLICK:
				return "onMindboxPushClick"
			case .ON_RETRY_CLICK:
				return "retryClick"
				
			case .GET_FIREBASE_MODEL:
				return "GET_FIREBASE_MODEL"
			case .PRESENT_FIREBASE_MODEL:
				return "PRESENT_FIREBASE_MODEL"
			case .GET_FIREBASE_MODEL_ERROR:
				return "GET_FIREBASE_MODEL_ERROR"
			case .GET_DEEP_LINK_MODEL:
				return "GET_DEEP_LINK_MODEL"
			case .PRESENT_DEEP_LINK_MODEL:
				return "PRESENT_DEEP_LINK_MODEL"
		}
	}
}
