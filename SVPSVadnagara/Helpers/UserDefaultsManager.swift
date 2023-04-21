//
//  UserDefaultsManager.swift
//  SVPSVadnagara
//
//  Created by Varun on 05/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import Foundation

struct UserDefaultsManager {
    
    static func setUserLoggedIn() {
        
        UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
    }
    
    static func isUserLoggedIn() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "isUserLoggedIn")
    }
}
