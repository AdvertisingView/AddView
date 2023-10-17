//
//  InternetСheckService.swift
//  
//
//  Created by Senior Developer on 01.07.2023.
//

import Reachability

public struct InternetСheckService {
    
    static func check() -> Bool {
        let reachability = try? Reachability()
        switch reachability?.connection {
            case .cellular:
                print("cellular")
                return true
            case .wifi:
                print("wifi")
                return true
            case .unavailable:
                return false
            default:
                return false
        }
    }
    
    public init() { }
}
