//
//  Enum.swift
//  AbayaBazar
//
//  Created by iMac-4 on 7/15/17.
//  Copyright © 2017 iMac-4. All rights reserved.
//

import Foundation

//MARK:- Enum UserDefaults
enum eUserDefaultsKey : String
{
    case LanguageSelected = "language_selected_first_time"
}


enum eCommanMessage : String
{
    case kMSGConnection = "Connection"
    case kMSGInternetCon = "Sorry, no internet connectivity detected. Please reconnect and try again"
}

//MARK:- USER TYPE
enum eDateFormate : String
{
    case DF_GenaralServer = "YYYY-MM-dd HH:mm:ss"
    case DF_GenaralApp = "dd-MM-YYYY"
}

//MARK:- Enum NotificationKeys
enum eNotificationsKey : String
{
    case NotiLocationupdate = "user_location_updated_notification"
}
// MARK: - APP Language
enum eAppLanguage : String
{
    case appLanguage = "AppleLanguages"
    case langGujarati = "gu-IN"
    case langEnglish = "en"
}

enum eKeyAppSettings : String
{
    case KeySettingZoomButtonenable = "key_settings_zoom_button_enable"
    case KeySettingLocationButtonenable = "key_settings_location_button_enable"
}


//MARK:- Enum UserDefaults
enum eUpdateProfileAPI : String
{
    case signUP = "signUP"
    case editProfile = "editProfile"
    case addFamily = "addFamily"
    case editFamily = "editFamily"
    
}
