//
//  Created by Developer on 07.12.2022.
//
import UIKit
import FirestoreSDK
import AlertService

public struct RequestDataModel: Codable {
    
    public let schemeAdvertising: String
    public let hostAdvertising: String
    public let pathAdvertising: String
    public let titleAdvertising: String
    public let homeUrl: URL?
    public let isAdvertising: Bool
    public let isClose: Bool
    public let isCopyUrl: Bool
	public let isTestPresent: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case schemeAdvertising
        case hostAdvertising
        case pathAdvertising
        case titleAdvertising
        case homeUrl
        case isAdvertising
        case isClose
        case isCopyUrl
		case isTestPresent
    }
    
    public init(
        schemeAdvertising: String,
        hostAdvertising: String,
        pathAdvertising: String,
        titleAdvertising: String,
        homeUrl: URL?,
        isAdvertising: Bool,
        isClose: Bool,
        isCopyUrl: Bool,
	    isTestPresent: Bool
    ) {
        self.schemeAdvertising = schemeAdvertising
        self.hostAdvertising = hostAdvertising
        self.pathAdvertising = pathAdvertising
        self.titleAdvertising = titleAdvertising
        self.isAdvertising = isAdvertising
        self.isClose = isClose
        self.isCopyUrl = isCopyUrl
        self.homeUrl = homeUrl
		self.isTestPresent = isTestPresent
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
		self.hostAdvertising = try values.decode(String.self, forKey: .hostAdvertising)
		self.isTestPresent = try values.decode(Bool.self, forKey: .isTestPresent)
        self.schemeAdvertising = try values.decode(String.self, forKey: .schemeAdvertising)
        self.pathAdvertising = try values.decode(String.self, forKey: .pathAdvertising)
        self.titleAdvertising = try values.decode(String.self, forKey: .titleAdvertising)
        self.isAdvertising = try values.decode(Bool.self, forKey: .isAdvertising)
        self.isClose = try values.decode(Bool.self, forKey: .isClose)
        self.isCopyUrl = try values.decode(Bool.self, forKey: .isCopyUrl)
        self.homeUrl = try? values.decode(URL?.self, forKey: .homeUrl)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(hostAdvertising, forKey: .hostAdvertising)
		try container.encode(isTestPresent, forKey: .isTestPresent)
        try container.encode(schemeAdvertising, forKey: .schemeAdvertising)
        try container.encode(pathAdvertising, forKey: .pathAdvertising)
        try container.encode(titleAdvertising, forKey: .titleAdvertising)
        try container.encode(isAdvertising, forKey: .isAdvertising)
        try container.encode(isClose, forKey: .isClose)
        try container.encode(isCopyUrl, forKey: .isCopyUrl)
        try container.encode(homeUrl, forKey: .homeUrl)
    }
}

public struct AdvertisingModel {
    
    public var hostAdvertising: String
    public var urlAdvertising: URL?
	public let pathAdvertising: String
    public var homeUrl: URL?
    public let isAdvertising: Bool
    public let isClose: Bool
    public let titleAdvertising: String
    public let isCopyUrl: Bool
	public let isTestPresent: Bool
    
    public init(requestDataModel: RequestDataModel) {
        self.hostAdvertising = requestDataModel.hostAdvertising
		self.pathAdvertising = requestDataModel.pathAdvertising
        self.urlAdvertising = nil
        self.homeUrl = requestDataModel.homeUrl
        self.isAdvertising = requestDataModel.isAdvertising
        self.titleAdvertising = requestDataModel.titleAdvertising
        self.isClose = requestDataModel.isClose
        self.isCopyUrl = requestDataModel.isCopyUrl
		self.isTestPresent = requestDataModel.isTestPresent
    }
}

public enum PresentScreen {
    case advertising(UIViewController)
    case game
}

public enum AdvertisingURL {
    case advertising(RequestDataModel)
    case error(String)
}

public enum BannerURL: String, CaseIterable {
    case rules
    case tg = "tg://"
    case payment = "securepayments.inwizo.com/payment/inwizo"
    case kvitum = "pay.kvitum.com/ru/pay"
    case dapmaptuns = "asdaerq.dapmaptuns.com"
    case dapmaptun = "asdaerq.dapmaptun"
    case gamesPresentNavBar = "gamesPresentNavBar"
    
    static func isOpen(with absoluteString: String?) -> Bool {
        guard let absoluteString = absoluteString else { return false }
        let result = BannerURL.allCases.first(where: { absoluteString.contains($0.rawValue)})
        switch result {
            case .rules:
                return true
            case .tg:
                return true
            case .payment:
                return true
            case .kvitum:
                return true
            case .dapmaptuns:
                return true
            case .dapmaptun:
                return true
            case .gamesPresentNavBar:
                return true
            default:
                return false
        }
    }
    
    static func isOpenApp(with absoluteString: String?) -> BannerURL? {
        guard let absoluteString = absoluteString else { return nil }
        let result = BannerURL.allCases.first(where: { absoluteString.contains($0.rawValue)})
        switch result {
            case .rules:
                return .rules
            case .tg:
                return .tg
            case .payment:
                return .payment
            default:
                return nil
        }
    }
}

struct TelegramAlert: AlertButtonOptionsoble {
    var buttonsCount: Int = 2
    var buttonsText: Array<String> = ["Да", "Нет"]
}
