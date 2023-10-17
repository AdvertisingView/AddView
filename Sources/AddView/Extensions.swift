//
//  Created by Developer on 07.12.2022.
//
import UIKit

extension Bundle {
	
	public static let blah = Bundle.module
	public static let bundle = Bundle.main.bundleIdentifier
}
public extension URL {
	
	static func create(
		with requestDataModel: RequestDataModel,
		parameters: [String: String] = [:]
	) -> URL? {
		var components = URLComponents()
		components.scheme = requestDataModel.schemeAdvertising
		components.host = requestDataModel.hostAdvertising
		components.path = requestDataModel.pathAdvertising
		components.queryItems = parameters.createQueryItems()
		return components.url
	}
	
	static func create(
		with requestDataModel: RequestDataModel,
		with advertisingModel: AdvertisingModel,
		parameters: [String: String] = [:]
	) -> URL? {
		var components = URLComponents()
		components.scheme = requestDataModel.schemeAdvertising
		components.host = requestDataModel.hostAdvertising
		components.queryItems = parameters.createQueryItems()
		return components.url
	}
	
	static func create(
		with url: URL?,
		parameters: [String: String] = [:]
	) -> URL? {
		var components = URLComponents()
		components.scheme = url?.scheme
		components.host = url?.host
		components.path = url?.path ?? ""
		components.queryItems = parameters.createQueryItems()
		return components.url
	}
	
	static func createMain(
		with fullURL: URL
	) -> URL? {
		var components = URLComponents()
		components.scheme = fullURL.scheme
		components.host = fullURL.host
		components.path = fullURL.path
		return components.url
	}
	
	func isTelegram() -> Bool {
	   return ((self.host?.contains("telegram.me") == true) || (self.host?.contains("t.me") == true))
	}
}

public extension Dictionary where Iterator.Element == (key: String, value: String) {
	
	func createQueryItems() -> [URLQueryItem] {
		let result = self.map { URLQueryItem(name: $0, value: $1) }
		return result
	}
}
public extension UIView {
	
	static func loadNib() -> Self {
		let nib = Bundle.module.loadNibNamed(String(describing: Self.self), owner: nil, options: nil)?.first
		return nib as! Self
	}
}

public extension UIScrollView {
	
	func isBouncesBottom(to: CGFloat) -> Bool {
		let contentHeight  = self.contentSize.height
		let contentVisible = self.visibleSize.height
		let result = (contentHeight - contentVisible) - to
		if self.contentOffset.y >= result {
			return false
		} else {
			return true
		}
	}
	func isBouncesTop(to: CGFloat) -> Bool {
		if self.contentOffset.y <= to {
			return false
		} else {
			return true
		}
	}
	func isBottom(to: CGFloat) -> Bool {
		let contentHeight  = self.contentSize.height
		let contentVisible = self.visibleSize.height
		let result = (contentHeight - contentVisible) + to
		if self.contentOffset.y > result {
			return true
		} else {
			return false
		}
	}
	func isTop(to: CGFloat) -> Bool {
		if self.contentOffset.y < -to {
			return true
		} else {
			return false
		}
	}
}

extension UIActivityIndicatorView {
	
	func show(_ activity: Bool){
		if activity {
			self.startAnimating()
			self.isHidden = false
		} else {
			self.stopAnimating()
			self.isHidden = true
		}
	}
}

extension Int {
	
	public func toString() -> String {
		String(self)
	}
}

extension Date {
	
	func toStaring(format: String.FormatDate) -> String {
		let dateFormate = DateFormatter()
		dateFormate.dateFormat = format.rawValue
		let formatString = dateFormate.string(from: self)
		return formatString
	}
}

extension String {
	
	func getDate(formatDate: FormatDate) -> Date? {
		let formatter = DateFormatter()
		formatter.dateFormat = formatDate.rawValue
		let date = formatter.date(from: self)
		return date
	}
	
	enum FormatDate: String {
		case time             = "HH:mm"
		case monthDay         = "MM.dd"
		case monthDayYear     = "MM.dd.yy"
		case dayMonthYear     = "dd.MM.yy"
		case dayMonthText     = "dd MMMM"
		case dayMonthTextYear = "dd MMMM yyyy"
		case long             = "MMMM d, yyyy"
		case fcCalendar       = "yyyy-MM-dd"
		case orderDateTime    = "dd_MMMM_yyyy HH :mm :ss"
		case orderDatePath    = "dd_MMMM_yyyy/"
		case orderDate        = "dd_MMMM_yyyy"
		case longDateString   = "EEEE, MMM d, yyyy"
	}
	
	func localizable() -> String {
		NSLocalizedString(
			self,
			tableName: "Localizable",
			bundle: .module,
			value: self,
			comment: self
		)
	}
}

extension UIApplication {
	public static var appVersion: String {
		let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
		return version ?? "version not"
	}
}
