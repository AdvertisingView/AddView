//
//  LiveChatService.swift
//  
//
//  Created by Senior Developer on 29.06.2023.
//
import LiveChat
import UIKit

public class LiveChatService: NSObject, LiveChatDelegate {
    
    public func setupLicenseId(with licenseId: String){
        LiveChat.licenseId = licenseId
    }
    
    public func setupGroupId(with groupId: String){
        LiveChat.groupId = groupId
    }
    
    public func presentChat(){
        LiveChat.presentChat()
    }
    
    public func setUserData(){
		LiveChat.setVariable(
			withKey:"app_version",
			value: UIApplication.appVersion
		)
    }
    
    public func received(message: LiveChatMessage) {
        
    }
    
    public struct Model {
        let licenseId: String
        let groupId: String
        
        public init(
            licenseId: String,
            groupId: String
        ) {
            self.licenseId = licenseId
            self.groupId = groupId
        }
    }
    
    public override init() { }
}
