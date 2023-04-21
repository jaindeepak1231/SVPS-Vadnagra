//
//  AppDelegate.swift
//  SVPSVadnagara
//
//  Created by Varun on 02/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

let APPLE_LANGUAGE_KEY = "AppleLanguages"
let app_Delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var arr_PoleData = [PoleListData]()
    var arr_ShakhData = [ShakhListData]()
    var arr_City = [CityListData]()
    var arr_Profession = [ProfessionListData]()
    
    static let sharedDelegate = UIApplication.shared.delegate as! AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        IQKeyboardManager.shared.enable = true
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        
        
        if let isLogin = UserDefaults.standard.value(forKey: "is_login") as? Bool {
            if isLogin {
                let mainVC = MainScreenVC.instantiate(fromAppStoryboard: .Main)
                let navigationController = UINavigationController(rootViewController: mainVC)
                mainVC.title = "Home".localized("")
                mainVC.urlToLoad = WebPagesURL.Home.rawValue
                navigationController.navigationBar.barTintColor = Constants.Color.blueColor
                AppDelegate.sharedDelegate.window?.rootViewController = navigationController
            }
        }
        
        
        
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

