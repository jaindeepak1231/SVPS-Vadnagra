//
//  APIConstants.swift
//  FrontPage
//
//  Created by Varun on 7/7/18.
//  Copyright © 2018 Varun. All rights reserved.
//
import Foundation
import UIKit

struct APIConstants {
    
    static let tokenKey = "token"
    static let tokenValue = "sxcvcbb4lAg:APA91bEvrU1ZCghpgEuIkhYvKzELKNAUwsdn_g8_zUr6jbP-xcs454cdfvxdsdsdsdferweetZ3VQ0CMglIDKR_ikb9oOgWDg_RRtI4LlEtgOr"
    static let deviceKey = "device_type"
    static let deviceValue = "iOS"
    
    static let baseURL = "https://svpsvadnagara.org/portal/wsdl/"
    
    static var Login: String {
        
        return  baseURL + "ws_login_user"
    }
    
    
    static var Logout: String {
        
        return  baseURL + "ws_logout_user"
    }
    
    
    
}
