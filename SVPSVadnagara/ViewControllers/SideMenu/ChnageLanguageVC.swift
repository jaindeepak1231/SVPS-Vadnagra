//
//  ChnageLanguageVC.swift
//  SVPSVadnagara
//
//  Created by Zignuts Technolab on 21/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import SideMenu

class ChnageLanguageVC: UIViewController {

    var strSelection = ""
    @IBOutlet weak var lbl_English: UILabel!
    @IBOutlet weak var lbl_Gujarati: UILabel!
    @IBOutlet weak var view_MainBG: UIView!
    @IBOutlet weak var view_EnglishBG: UIView!
    @IBOutlet weak var view_GujaratiBG: UIView!
    
    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var btn_English: UIButton!
    @IBOutlet weak var btn_Gujarati: UIButton!
    @IBOutlet weak var img_English: UIImageView!
    @IBOutlet weak var img_Gujarati: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.lbl_English.text = "English"
        self.lbl_Gujarati.text = "ગુજરાતી"
        self.btnChange.setTitle("Save".localized(""), for: UIControl.State.normal)
        
        
        
        
        let langCode = AppGetAppLanguage()
        self.strSelection = langCode
        if langCode == "en" {
            self.img_English.image =  #imageLiteral(resourceName: "radio-on-button")
            self.img_Gujarati.image = #imageLiteral(resourceName: "check-mark-2")
        }
        else {
            self.img_English.image =  #imageLiteral(resourceName: "check-mark-2")
            self.img_Gujarati.image = #imageLiteral(resourceName: "radio-on-button")
        }
    }
    
    // MARK:- Custom Methods
    final func setupUI() {
        self.title = "Change Language".localized("")
        let leftMenuButton = UIBarButtonItem(image: UIImage(named: "ic_action_menu"), style: .plain, target: self, action: #selector(sideMenuButtonTapped))
        self.navigationItem.leftBarButtonItem = leftMenuButton
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = .white
        
        setupMenu()
    }
    
    final func setupMenu() {
        let sideMenuVC = SideMenuVC.instantiate(fromAppStoryboard: .Main)
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: sideMenuVC)
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.width - 50
        SideMenuManager.default.menuFadeStatusBar = false
    }
    
    // MARK:- IBActions
    @objc func sideMenuButtonTapped() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: UIButton Action
    @IBAction func btnEnglist_Tapped(_ sender: UIButton) {
        self.img_English.image =  #imageLiteral(resourceName: "radio-on-button")
        self.img_Gujarati.image = #imageLiteral(resourceName: "check-mark-2")
        self.strSelection = eAppLanguage.langEnglish.rawValue
    }
    
    @IBAction func btnGujarati_Tapped(_ sender: UIButton) {
        self.img_English.image =  #imageLiteral(resourceName: "check-mark-2")
        self.img_Gujarati.image = #imageLiteral(resourceName: "radio-on-button")
        self.strSelection = eAppLanguage.langGujarati.rawValue
        
        
    }
    
    @IBAction func btnChangeLanguageTapped(_ sender: UIButton) {
        if self.strSelection == eAppLanguage.langEnglish.rawValue {
            self.selectionLanguage(eAppLanguage.langEnglish)
        }
        else {
            self.selectionLanguage(eAppLanguage.langGujarati)
        }
        
    }

    
    
    func selectionLanguage(_ language: eAppLanguage) {

        // This is done so that network calls now have the Accept-Language as "hi" (Using Alamofire) Check if you can remove these
        UserDefaults.appSetObject([language.rawValue] as AnyObject, forKey: eAppLanguage.appLanguage.rawValue)
        UserDefaults.standard.synchronize()

        // Update the language by swaping bundle
        Bundle.setLanguage(language.rawValue)

        // Done to reintantiate the storyboards instantly
        if let isLogin = UserDefaults.standard.value(forKey: "is_login") as? Bool {
            if isLogin {
                let mainVC = MainScreenVC.instantiate(fromAppStoryboard: .Main)
                let navigationController = UINavigationController(rootViewController: mainVC)
                mainVC.title = "Home".localized("")
                mainVC.urlToLoad = WebPagesURL.Home.rawValue
                navigationController.navigationBar.barTintColor = Constants.Color.blueColor
                AppDelegate.sharedDelegate.window?.rootViewController = navigationController
            }
            else {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
            }
        }
        else {
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            UIApplication.shared.keyWindow?.rootViewController = storyboard.instantiateInitialViewController()
        }
        
        
        
        
        
        /*
        let strMessage = "language change requires app to be closed and reopened again. Do you want to close the app now ?".localized("")
        let strYes = "YES".localized("")
        let strNo = "NO".localized("")

        let Alert:UIAlertController = UIAlertController.init(title: "", message: strMessage, preferredStyle: UIAlertController.Style.alert)
        let actNO:UIAlertAction = UIAlertAction.init(title: strNo, style: UIAlertAction.Style.default, handler: { (handler) in
        })

        let actYes:UIAlertAction = UIAlertAction.init(title: strYes, style: UIAlertAction.Style.default, handler: { (handler) in
            UserDefaults.appSetObject([language.rawValue] as AnyObject, forKey: eAppLanguage.appLanguage.rawValue)
            exit(0)
        })
        Alert.addAction(actNO)
        Alert.addAction(actYes)
        self.present(Alert, animated: true, completion: nil)*/
    }
}
