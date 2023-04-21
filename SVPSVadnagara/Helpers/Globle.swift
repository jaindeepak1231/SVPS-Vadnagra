//
//  Globle.swift
//  RedButton
//
//  Created by Zignuts Technolab on 26/03/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import AVFoundation
import Photos

struct Device {
    // iDevice detection code
    static let IS_IPAD             = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE           = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA           = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH        = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT       = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH   = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH   = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_4_OR_LESS = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5         = IS_IPHONE && SCREEN_MAX_LENGTH == 568
    static let IS_IPHONE_6         = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P        = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X         = IS_IPHONE && SCREEN_MAX_LENGTH == 812
}


//MARK:- VARIABLES DECLARATION

let ListingLimit = 20

let Story_Main = UIStoryboard.init(name:"Main", bundle: nil)

let appDelegate = UIApplication.shared.delegate as! AppDelegate

let screenWidth = UIScreen.main.bounds.size.width

let screenHeight = UIScreen.main.bounds.size.height

let screenScale = screenWidth/320

let screenHeightScale = screenHeight/568

let screenWidthScale = screenWidth/320

let glbDeviceType = "ios"

var glbDeviceToken:String?

var glbLatitude = 0.0

var glbLongitude = 0.0

var glbUserID = ""
var glbMyJID = ""

var glbCurrentAddress = (city:"",state:"", Address:"", Country:"")

var isInternet = false
var isActiveRegister = false
let _userDefault : UserDefaults = UserDefaults.standard
let AlertActionButtonBGColor = [#colorLiteral(red: 0.1568627451, green: 0.4078431373, blue: 0.6862745098, alpha: 1), #colorLiteral(red: 0.4941176471, green: 0.8, blue: 0.9019607843, alpha: 1)]






//MARK:- METHODS
public func makeCall(number:String)
{
    let url = URL.init(string:"tel://\(number)" )
    if url == nil {
        return
    }
    if UIApplication.shared.canOpenURL(url!) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url!)
        }
    }else{
        let alert = UIAlertController(title: "SVPS Vadnagara".localized(""), message: "This device unable to make call".localized(""), preferredStyle: .alert)
        alert.addAction(title: "Ok".localized(""), style: .default, handler: nil)
        app_Delegate.window?.rootViewController?.present(alert, animated: true, completion: nil)

        //        ShowNotification(Title: "This device unable to make call", Message: "")
    }
}

public func isValidString(_ strvalue:String?) -> Bool {
    return strvalue != nil && strvalue != ""
}

func GetFirebaseDeviceToken() -> String {
    
    var firebase_token = "IOS1234567890IOS"
    
    if _userDefault.value(forKey: "firebasetoken") != nil {
        if let dicTokenString = _userDefault.value(forKey:"firebasetoken") as? String {
            firebase_token = dicTokenString
        }
    }
    
    return firebase_token
}





func strGetUserID() -> String {

    var strUserID = ""
    
    if _userDefault.value(forKey: "AllUserData") != nil {
        let data = _userDefault.value(forKey: "AllUserData") as! Data
        if let dicData = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSDictionary {
            strUserID = dicData[SKDataKeys.user_id.rawValue] as? String ?? ""
        }
    }

    return strUserID
}




func strGetUserName_Email(_ strKey: String) -> String {
    var strValue = ""
    
    if _userDefault.value(forKey: "AllUserData") != nil {
        let data = _userDefault.value(forKey: "AllUserData") as! Data
        if let dicData = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSDictionary {
            if strKey == SKDataKeys.name.rawValue {

                let fNameKey = SKDataKeys.first_name.rawValue//: SKDataKeys.first_name_gj.rawValue
                let mNameKey = SKDataKeys.middle_name.rawValue// : SKDataKeys.middle_name_gj.rawValue
                let lNameKey = SKDataKeys.last_name.rawValue// : SKDataKeys.last_name_gj.rawValue
                
                
                let f_name = dicData[fNameKey] as? String ?? ""
                let m_name = dicData[mNameKey] as? String ?? ""
                let l_name = dicData[lNameKey] as? String ?? ""
                strValue = "\(f_name) \(m_name) \(l_name)"
            }
            else if strKey == SKDataKeys.token_id.rawValue {
                strValue = "\(dicData[strKey] as? Int ?? 0)"
            }
            else {
                strValue = dicData[strKey] as? String ?? ""
            }
        }
    }
    return strValue
}


func strGetUserFullName(_ strKey: String, langCode: String) -> String {
    var strValue = ""
    
    if _userDefault.value(forKey: "AllUserData") != nil {
        let data = _userDefault.value(forKey: "AllUserData") as! Data
        if let dicData = NSKeyedUnarchiver.unarchiveObject(with: data) as? NSDictionary {
            if strKey == SKDataKeys.name.rawValue {
                
                let fNameKey = langCode == "en" ? SKDataKeys.first_name.rawValue : SKDataKeys.first_name_gj.rawValue
                let mNameKey = langCode == "en" ? SKDataKeys.middle_name.rawValue : SKDataKeys.middle_name_gj.rawValue
                let lNameKey = langCode == "en" ? SKDataKeys.last_name.rawValue : SKDataKeys.last_name_gj.rawValue
                
                
                let f_name = dicData[fNameKey] as? String ?? ""
                let m_name = dicData[mNameKey] as? String ?? ""
                let l_name = dicData[lNameKey] as? String ?? ""
                strValue = "\(f_name) \(m_name) \(l_name)"
            }
            else if strKey == SKDataKeys.token_id.rawValue {
                strValue = "\(dicData[strKey] as? Int ?? 0)"
            }
            else {
                strValue = dicData[strKey] as? String ?? ""
            }
        }
    }
    return strValue
}



func verifyUrl (urlString: String?) -> Bool {
    //Check for nil
    if let urlString = urlString {
        // create NSURL instance
        if let url = URL(string: urlString) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url)
        }
    }
    return false
}


//MARK:- UIALERT VIEW
func showSingleAlert(Title:String, Message:String, buttonTitle:String, delegate:UIViewController? = appDelegate.window?.rootViewController, completion:@escaping ()->Void) {
    if let parentVC = delegate {
        let alertConfirm = UIAlertController(title: Title, message: Message, preferredStyle: .alert)
        let actOk = UIAlertAction(title: buttonTitle, style: .default) { (finish) in
            completion()
        }
        alertConfirm.addAction(actOk)
        parentVC.present(alertConfirm, animated: true, completion: nil)
    }
}

//MARK:- GET DAY FROM DATE FORMATE
func getDayOfWeek(_ today:String) -> String? {
    var strDay = ""
    let formatter  = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    guard let todayDate = formatter.date(from: today) else { return nil }
    let myCalendar = Calendar(identifier: .gregorian)
    let weekDay = myCalendar.component(.weekday, from: todayDate)
    
    if weekDay == 1 {
        strDay = "Sunday"
    }
    else if weekDay == 2 {
        strDay = "Monday"
    }
    else if weekDay == 3 {
        strDay = "Tuesday"
    }
    else if weekDay == 4 {
        strDay = "Wednesday"
    }
    else if weekDay == 5 {
        strDay = "Thursday"
    }
    else if weekDay == 6 {
        strDay = "Friday"
    }
    else if weekDay == 7 {
        strDay = "Saturday"
    }

    return strDay
}


//MARK:- DATE FORMATE
func convertGetFormatedDate(fromDate:String, ToFormate:String) -> String{
    let formater = DateFormatter()
    formater.timeZone = TimeZone(identifier: "UTC")
//    formater.dateFormat = eUserDefaultsKey.keyServerdateformate.rawValue
    
    if let serverDate = formater.date(from: fromDate){
        formater.dateFormat = ToFormate
        formater.timeZone = TimeZone.current
        return formater.string(from: serverDate)
    }
    return fromDate
}


func getExpireSubscriptionUTCDate_Time(_ date: Date) -> String {
    let formater = DateFormatter()
    formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let strDate = formater.string(from: date)
    
    return strDate
}


func getCurrentUTCDate_Time() -> String{
    let formater = DateFormatter()
    formater.timeZone = TimeZone(identifier: "UTC")
    formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let strDate = formater.string(from: Date())
    
    return strDate
}

func getCurrentDate() -> String{
    let formater = DateFormatter()
    formater.dateFormat = "yyyy-MM-dd"
    let strDate = formater.string(from: Date())
    return strDate
}

func getYesterdayDate() -> String{
    let formater = DateFormatter()
    formater.dateFormat = "yyyy-MM-dd"
    let strDate = formater.string(from: Date.yesterday)
    return strDate
}


func getCurrentDate_TimeForChat() -> Date {
    let formater = DateFormatter()
    formater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let strDate = formater.string(from: Date())
    let str_Date = formater.date(from: strDate)
    
    return str_Date ?? Date()
}



func showFootAndInchesFromCm(_ cms: Double) -> String {
    
    let feet = cms * 0.0328084
    let feetShow = Int(floor(feet))
    let feetRest: Double = ((feet * 100).truncatingRemainder(dividingBy: 100) / 100)
    let inches = Int(floor(feetRest * 12))
    
    if inches == 0 {
        return ""
    }
    
    return "( \(feetShow)' \(inches)\" )"
}


//MARK:- PROGRESS HUD
public func ShowProgressHud(message:String) {
    SVProgressHUD.show(withStatus: message)
    app_Delegate.window?.isUserInteractionEnabled = false
}

public func DismissProgressHud() {
    SVProgressHUD.dismiss()
    app_Delegate.window?.isUserInteractionEnabled = true
}

//MARK:- FORMATED JSON

func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
    
    let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
    
    
    if JSONSerialization.isValidJSONObject(value) {
        
        do{
            let data = try JSONSerialization.data(withJSONObject: value, options: options)
            if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                return string as String
            }
        }catch {
            
            print("error")
            //Access error here
        }
        
    }
    return ""
}

//MARK:- ANIMATIONS

func animate_buttonBounce(sender:UIView, completions:((Bool) -> Swift.Void)? = nil) {
    sender.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
    
    UIView.animate(withDuration: 0.5,
                   delay: 0,
                   usingSpringWithDamping: CGFloat(0.30),
                   initialSpringVelocity: CGFloat(5.0),
                   options: UIView.AnimationOptions.allowUserInteraction,
                   animations: {
                    sender.transform = CGAffineTransform.identity
    },
                   completion: { Void in()
                    if let callBack = completions{
                        callBack(true)
                    }
                    
    })
}

//MARK:- CHECK AUTHORIZATION CAMERA AND PHOTO

func checkCameraAutorization(completion: @escaping ((Bool) -> Void)) ->  Void{
    if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
        //already authorized
        completion(true)
    } else {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                //access allowed
                completion(true)
            } else {
                //access denied
                completion(false)
                openSettingsPopup(title: "Permission", Message: "In order to capture image we need permission to access your camera. Please go to settings and give camera permission.")
            }
        })
    }
}

func checkPhotoLibraryPermission(completion: @escaping ((Bool) -> Void)) {
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
         completion(true)
        break
    case .denied, .restricted :
         completion(false)
         openSettingsPopup(title: "Permission", Message: "In order to pick image from photos we need permission to access your photos. Please go to settings and give photos permission.")
        break
    case .notDetermined:
        // ask for permissions
        PHPhotoLibrary.requestAuthorization() { status in
            switch status {
            case .authorized:
                completion(true)
                break
            case .denied, .restricted:
                completion(false)
                openSettingsPopup(title: "Permission", Message: "In order to pick image from photos we need permission to access your photos. Please go to settings and give photos permission.")
                break
            case .notDetermined:
                break
            }
        }
        break
    }
}

func openSettingsPopup(title:String,Message:String) {
    
    let alertPermission = UIAlertController(title: title, message: Message, preferredStyle: .alert)
    let actDismis = UIAlertAction(title: "Cancel", style: .default, handler: nil)
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)") // Prints true
            })
        }
    }
    
    alertPermission.addAction(actDismis)
    alertPermission.addAction(settingsAction)
    
    appDelegate.window?.rootViewController?.present(alertPermission, animated: true, completion: nil)
}


func AppGetAppLanguage() -> String {
    let langStr = UserDefaults.standard.object(forKey: eAppLanguage.appLanguage.rawValue) as! NSArray
    let strLanguage = (langStr.firstObject  ?? "en") as! String
    print("App Language :[\(langStr.firstObject  ?? "No App Language Found!!")]")
    return strLanguage
}



//MARK:- SIMPLE PRINT METHODS

func printFonts() {
    let fontFamilyNames = UIFont.familyNames
    for familyName in fontFamilyNames {
        debugPrint("------------------------------")
        debugPrint("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNames(forFamilyName: familyName)
        debugPrint("Font Names = [\(names)]")
    }
}

//MARK:- DATE FUNCTIONS

func currentTimeInMiliseconds(currentDate:Date = Date()) -> Int {
//    let currentDate = Date()
    let since1970 = currentDate.timeIntervalSince1970
    return Int(since1970 * 1000)
}

func dateFromMilliseconds(milisecond:Int) -> Date {
    return Date(timeIntervalSince1970: TimeInterval(milisecond)/1000)
}

extension Date {
    static var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: Date().noon)!
    }
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date().noon)!
    }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}



extension String {
    func localized(_ withComment:String) -> String {
        let LocalizeString = NSLocalizedString(self.lowercased(), tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
        
        if LocalizeString == self.lowercased() || Validator.isValidString(LocalizeString) == true {
            return self
        }
        
        if LocalizeString.contains("SVPS") {
            return "SVPS Vadnagara"
        }
        else if LocalizeString.contains("ID") {
            var strLocal = LocalizeString
            strLocal = strLocal.replacingOccurrences(of: "Id", with: "ID")
            return strLocal
        }
        
        
        return LocalizeString.capitalized
    }
}



//MARK:- UserDefaults
extension UserDefaults {
    
    //MARK:- UserDefault Save / Retrive Data
    static func appSetObject(_ object:AnyObject, forKey:String){
        UserDefaults.standard.set(object, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    static func appObjectForKey(_ strKey:String) -> AnyObject?{
        let strValue:AnyObject? = UserDefaults.standard.value(forKey: strKey) as AnyObject?
        return strValue
    }
    
    static func appRemoveObjectForKey(_ strKey:String){
        UserDefaults.standard.removeObject(forKey: strKey)
        UserDefaults.standard.synchronize()
    }
    
}



class UnderlinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSMakeRange(0, text.count)
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            // Add other attributes if needed
            self.attributedText = attributedText
        }
    }
}
