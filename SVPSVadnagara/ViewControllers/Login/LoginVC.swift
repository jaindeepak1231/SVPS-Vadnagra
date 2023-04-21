//
//  LoginVC.swift
//  SVPSVadnagara
//
//  Created by Varun on 02/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField
import Alamofire
class LoginVC: UIViewController {
    
    @IBOutlet weak var informationIDTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.informationIDTextField.placeholder = "Information ID".localized("")
        self.informationIDTextField.selectedTitle = "Information ID".localized("")
        self.passwordTextField.placeholder = "Password".localized("")
        self.passwordTextField.selectedTitle = "Password".localized("")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    final func validateData() -> Bool {
        
        if informationIDTextField.text?.trim.count == 0 {
            
            showAlert(message: AlertMessages.informationIdEmpty.localized(""))
            return false
        }
        else if passwordTextField.text?.trim.count == 0 {
            
            showAlert(message: AlertMessages.enterPassword.localized(""))
            return false
        }
        return true
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        
        let mainScreenVC = MainScreenVC.instantiate(fromAppStoryboard: .Main)
        let navigationController = UINavigationController(rootViewController: mainScreenVC)
        navigationController.navigationBar.barTintColor = Constants.Color.blueColor
        mainScreenVC.title = "Home".localized("")
        AppDelegate.sharedDelegate.window?.rootViewController = navigationController
        
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if validateData() == false {
            return
        }
        
        let param = ["membership_no": informationIDTextField.text ?? "",
                     "password": passwordTextField.text ?? "",
                     APIConstants.tokenKey: APIConstants.tokenValue,
                     APIConstants.deviceKey: APIConstants.deviceValue]
        
        ShowProgressHud(message: "please wait...".localized(""))

        print(URL_LoginUser, param)

        ServiceCustom.shared.requestURLwithData(URL_LoginUser, Method: "POST", parameters: param, completion: { (request, response, jsonObj, dataa)  in

            debugPrint(jsonObj ?? [:])
            DismissProgressHud()

            DispatchQueue.main.async {

                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let dicUserData = dictResult["data"] as? NSDictionary {
                            _userDefault.set(true, forKey: "is_login")
                            _userDefault.set(NSKeyedArchiver.archivedData(withRootObject: dicUserData), forKey: "AllUserData")
                            UserDefaults.standard.synchronize()
                            
                            //Go To Home Screen
                            let objMain = self.storyboard?.instantiateViewController(withIdentifier: "MainScreenVC") as! MainScreenVC
                            objMain.title = "Home".localized("")
                            self.navigationController?.navigationBar.barTintColor = Constants.Color.blueColor
                            self.navigationController?.pushViewController(objMain, animated: true)
                            
                            /*//Go To Profile Screen
                            let viewProfileVC = ViewProfileVC.instantiate(fromAppStoryboard: .Main)
                            let navigationController = UINavigationController(rootViewController: viewProfileVC)
                            navigationController.navigationBar.barTintColor = Constants.Color.blueColor
                            AppDelegate.sharedDelegate.window?.rootViewController = navigationController
                            //****************************//
                             */
                        }
                    }
                    else {
                        self.showAlert(message: str_Msg)
                        return
                    }
                }
            }

        }) { (errorr) in
            DismissProgressHud()
            debugPrint("[persistent] \(errorr)")
            self.showAlert(message: errorr.localizedDescription)
        }

        
        /*
         //Existing
         let param = ["membership_no": informationIDTextField.text ?? "",
                     "password": passwordTextField.text ?? "",
                     APIConstants.tokenKey: APIConstants.tokenValue,
                     APIConstants.deviceKey: APIConstants.deviceValue]
        
        self.showProgressHUD()
        
        NetworkManager.shared.request(APIConstants.Login, method: .post, params: param as Parameters, type: LoginData.self) { [weak self] (responseData, error) in
        
            self?.hideProgressHUD()
            
            if error == nil {
                
                if let response = responseData {
                    let viewProfileVC = ViewProfileVC.instantiate(fromAppStoryboard: .Main)
                    viewProfileVC.profileDetails = response
                    let navigationController = UINavigationController(rootViewController: viewProfileVC)
                    navigationController.navigationBar.barTintColor = Constants.Color.blueColor
                    AppDelegate.sharedDelegate.window?.rootViewController = navigationController
                    
                    UserDefaults.standard.set(true, forKey: "is_login")
                    
                    //let loginData = NSKeyedArchiver.archivedData(withRootObject: response)
                    //UserDefaults.standard.set(loginData, forKey: "UserData")
                    UserDefaults.standard.synchronize()
                }
                
                
                
            } else {
            
                self?.showAlert(message: error ?? "")
            }
        }*/
    }
    
    func saveLoginDatainPreference(profileData: LoginData) {
        
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: UIButton) {
        let forgotVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(forgotVC, animated: true)
        
        //let forgotVC = ForgotPasswordVC.instantiate(fromAppStoryboard: .Main)
        //let navigationController = UINavigationController(rootViewController: forgotVC)
        //navigationController.navigationBar.barTintColor = Constants.Color.blueColor
        //AppDelegate.sharedDelegate.window?.rootViewController = navigationController
    }
    
    @IBAction func signupButtonTapped(_ sender: UIButton) {
        let forgotVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(forgotVC, animated: true)
    }
    
}
