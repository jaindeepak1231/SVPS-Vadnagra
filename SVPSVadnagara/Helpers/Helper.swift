//
//  Helper.swift
//  FrontPage
//
//  Created by Varun on 7/7/18.
//  Copyright © 2018 Varun. All rights reserved.
//

import Foundation

struct Helper {
    
}

struct Common {
        
    static func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "MM-dd-yyy h:mm a"
        
        return dateFormatter.string(from: dt!)
    }
}

struct AlertMessages {
    
    static let msg_PleaseWait = "please wait...".localized("")
    static let appName = "SVPS Vadnagara".localized("")
    static let internetNotAvailable = "internet connection not available.".localized("")
    static let somethingWrong = "something went wrong. please try again.".localized("")
    static let informationIdEmpty = "information ID should not be blank.".localized("")
    static let invalidPassword = "Password must be minimum 8 characters long with mix of numeric, capital and alphabet letters.".localized("")
    static let validEmail = "Please enter valid Email.".localized("")
    static let validConfirmEmail = "Please enter valid Confirm Email.".localized("")
    static let enterAllDetails = "Please enter all details.".localized("")
    static let enterPhoneNumber = "Please enter Phone number.".localized("")
    static let enterEmail = "Please enter Email.".localized("")
    static let enterRelation = "Please enter relation.".localized("")
    static let enterBirthDate = "Please enter birthdate.".localized("")
    
    static let enterGender = "Please enter male/female.".localized("")
    static let enterPassword = "Please enter password.".localized("")
    static let enterc_Password = "Please enter confirm password.".localized("")
    static let emailAndConfirmNotMatch = "The Confirm Email must match with Email.".localized("")
    
    static let passwordAndConfirmNotMatch = "The Confirm Password must match with Password.".localized("")
    
    static let logout = "are you sure you want to sign out?".localized("")
    
    static let old_pass = "Please enter your current password.".localized("")
    static let new_pass = "Please enter new password.".localized("")
    static let confirm_pass = "Please enter confirm password.".localized("")
    static let confirm_passMatch = "Please enter corrent confirm password.".localized("")
    
    static let enterArea = "Please enter area name.".localized("")
    static let enterCity = "Please enter city name.".localized("")
    static let enterCountry = "Please enter country name.".localized("")
    
    static let enterF_Name = "Please enter first name.".localized("")
    static let enterM_Name = "Please enter middle name.".localized("")
    static let enterL_Name = "Please enter last name.".localized("")
    
    
    static let enterPole = "Please enter pole.".localized("")
    static let enterShakh = "Please enter shakh.".localized("")
    static let enterMother_Name = "Please enter mother name.".localized("")
    
    
}

struct AlertAction {
    
    static let ok = "Ok".localized("")
    static let cancel = "Cancel".localized("")
    static let logout = "Logout"
}
