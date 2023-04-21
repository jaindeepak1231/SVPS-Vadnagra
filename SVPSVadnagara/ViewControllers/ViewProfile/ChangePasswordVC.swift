//
//  ChangePasswordVC.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 24/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import SideMenu
import AlamofireImage

class ChangePasswordVC: UIViewController {
    
    var dictDetail = [String:Any]()
    var arrSectionsRow: [ProfileRowsData]! = [ProfileRowsData]()
    @IBOutlet weak var tblView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register Table Cell
        self.tblView.register(UINib.init(nibName: "RegisterTableCell", bundle: nil), forCellReuseIdentifier: "RegisterTableCell")
        self.tblView.register(UINib.init(nibName: "ButtonTableCell", bundle: nil), forCellReuseIdentifier: "ButtonTableCell")
        //*******************************************************//
        
        setupUI()
        setUpforSectionsData()
    }
    
    
    // MARK:- Custom Methods
    
    final func setupUI() {
        
        self.title = "Change Password".localized("")
        
        
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
    
    //Setup Sections
    func setUpforSectionsData() {
        self.arrSectionsRow.removeAll()
        self.arrSectionsRow.append(ProfileRowsData.init(1, "currentPassword", "Current Password".localized(""), ""))
        self.arrSectionsRow.append(ProfileRowsData.init(1, "password", "New Password".localized(""), ""))
        self.arrSectionsRow.append(ProfileRowsData.init(1, "confirm_password", "Confirm New Password".localized(""), ""))
        self.arrSectionsRow.append(ProfileRowsData.init(1, "button", "CHANGE PASSWORD".localized(""), ""))
        
        self.setUpValue()
        self.tblView.reloadData()
    }
    
    func setUpValue() {
        self.dictDetail[SKDataKeys.user_id.rawValue] = strGetUserID()
        self.dictDetail["currentPassword"] = ""
        self.dictDetail["password"] = ""
        self.dictDetail["confirm_password"] = ""
    }
    
    
    
    // MARK:- IBActions
    
    @objc func sideMenuButtonTapped() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
}

// MARK: UICOllection Veiew Delegate and Datasource Method
extension ChangePasswordVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrSectionsRow.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSectionsRow[section].numOfrows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strKey = self.arrSectionsRow[indexPath.section].key
        let strID = self.arrSectionsRow[indexPath.section].title

        if strKey == "button" {
            let cell: ButtonTableCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableCell", for: indexPath) as! ButtonTableCell
            cell.selectionStyle = .none
            cell.btnRegister.setTitle(strID.uppercased(), for: UIControl.State.normal)
            
            cell.btnRegister.addTarget(self, action: #selector(btnSubmitTapped(_:)), for: UIControl.Event.touchUpInside)
            
            return cell
        }
        else {
            let cell: RegisterTableCell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableCell", for: indexPath) as! RegisterTableCell
            cell.selectionStyle = .none
            //cell.backgroundColor = UIColor.clear
            
            cell.txt_field.delegate = self
            cell.txt_field.placeholder = strID
            cell.txt_field.selectedTitle = strID
            cell.txt_field.isSecureTextEntry = true
            cell.txt_field.text = self.dictDetail[strKey] as? String ?? ""
            cell.txt_field.accessibilityHint = strKey
            cell.txt_field.accessibilityIdentifier = strKey
            
            return cell
        }
        
    }
    
    // MARK:- IBActions Upload Image
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if validateData() == false {
            return
        }
        
        ShowProgressHud(message: "please wait...".localized(""))

        print(URL_ChangePassword, self.dictDetail)

        ServiceCustom.shared.requestURLwithData(URL_ChangePassword, Method: "POST", parameters: self.dictDetail, completion: { (request, response, jsonObj, dataa)  in

            debugPrint(jsonObj ?? [:])
            DismissProgressHud()

            DispatchQueue.main.async {

                if let dictResult = jsonObj {

                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {

                        // Create the alert controller
                            let alertController = UIAlertController(title: "SVPS Vadnagara".localized(""), message: str_Msg, preferredStyle: .alert)
                            
                            // Create the actions
                            let okAction = UIAlertAction(title: "Ok".localized(""), style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                                let mainVC = MainScreenVC.instantiate(fromAppStoryboard: .Main)
                                let navigationController = UINavigationController(rootViewController: mainVC)
                                mainVC.title = "Home".localized("")
                                mainVC.urlToLoad = WebPagesURL.Home.rawValue
                                navigationController.navigationBar.barTintColor = Constants.Color.blueColor
                                AppDelegate.sharedDelegate.window?.rootViewController = navigationController
                                
                            }
                            // Add the actions
                            alertController.addAction(okAction)
                            // Present the controller
                            self.present(alertController, animated: true, completion: nil)
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
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func validateData() -> Bool {

        let strOldPass = self.dictDetail["currentPassword"] as? String ?? ""
        let strNewPass = self.dictDetail["password"] as? String ?? ""
        let strConPass = self.dictDetail["confirm_password"] as? String ?? ""

        if strOldPass.trim.count == 0 {
            showAlert(message: AlertMessages.old_pass.localized(""))
            return false
        }
        else if strNewPass.trim.count == 0 {
            showAlert(message: AlertMessages.new_pass.localized(""))
            return false
        }
        else if strConPass.trim.count == 0 {
            showAlert(message: AlertMessages.confirm_pass.localized(""))
            return false
        }
        else if strNewPass != strConPass {
            showAlert(message: AlertMessages.confirm_passMatch.localized(""))
            return false
        }

        return true
    }
}



//MARK:- textfield Delegate & Actions

extension ChangePasswordVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  let strID = textField.accessibilityHint {
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let strID = textField.accessibilityIdentifier {
            dictDetail[strID] = textField.text
        }
    }
}
