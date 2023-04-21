//
//  SideMenuVC.swift
//  SVPSVadnagara
//
//  Created by Varun on 02/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import SideMenu
import SafariServices

protocol SideMenuClickProtocol: class {
    
    func sideMenuDidChanged(navigationTitle: String, urlToLoad: WebPagesURL)
}

struct SideMenuItemModel {
    
    var imageName: String
    var headerTitle: String
    var subItems: [SubMenuItem]
    var isExpandable: Bool
    var webPageURL: WebPagesURL
    init(imageName: String, headerTitle: String, subItems: [SubMenuItem], isExpandable: Bool, webPageURL: WebPagesURL) {
        
        self.imageName = imageName
        self.headerTitle = headerTitle
        self.subItems = subItems
        self.isExpandable = isExpandable
        self.webPageURL = webPageURL
    }
}

struct SubMenuItem {
    
    var title: String
    var webPageURL: WebPagesURL
    
    init(title: String, webPageURL: WebPagesURL) {
        
        self.title = title
        self.webPageURL = webPageURL
        
    }
}

class SideMenuVC: UIViewController {
    
    @IBOutlet weak var lbl_infoID: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var btnLoginSignUp: UIButton!
    @IBOutlet weak var constraint_lblBottom: NSLayoutConstraint!
    
    weak var delegate: SideMenuClickProtocol?

    var arrSideMenuItems = [SideMenuItemModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        self.btnLoginSignUp.isHidden = true
        self.lbl_name.text = ""
        self.constraint_lblBottom.constant = 12

        arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_home", headerTitle: "Home".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .Home))

        arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_about_us", headerTitle: "About us".localized(""), subItems: [SubMenuItem(title: "About Samaj".localized(""), webPageURL: .AboutSamaj), SubMenuItem(title: "Objectives of SVPS".localized(""), webPageURL: .ObjectivesofSVPS), SubMenuItem(title: "History".localized(""), webPageURL: .History), SubMenuItem(title: "Trustee".localized(""), webPageURL: .Trustee)], isExpandable: false, webPageURL: .notWebPage))

        if let isLogin = UserDefaults.standard.value(forKey: "is_login") as? Bool {
            if isLogin {

                arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_profile", headerTitle: "Profile".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .notWebPage))

                arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_member", headerTitle: "My Family".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .notWebPage))
            }
        }

        arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_matrimonial", headerTitle: "Matrimonial".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .notWebPage))

        if let isLogin = UserDefaults.standard.value(forKey: "is_login") as? Bool {
            if isLogin {
                arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_search", headerTitle: "Search".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .notWebPage))
            }
        }

        arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_announcement", headerTitle: "Announcement".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .Announcement))

        arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_activity", headerTitle: "Activity".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .Activity))

        arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_gellary", headerTitle: "Gallery".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .Gallery))
        
        arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_link", headerTitle: "Useful Links".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .UsefulLinks))

        arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_contact_us", headerTitle: "Contact Us".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .ContactUs))

        arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_translate", headerTitle: "Change Language".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .notWebPage))
        
        if let isLogin = UserDefaults.standard.value(forKey: "is_login") as? Bool {
            if isLogin {
                
                arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_translate", headerTitle: "Change Password".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .notWebPage))
                
                arrSideMenuItems.append(SideMenuItemModel(imageName: "ic_logout", headerTitle: "Sign out".localized(""), subItems: [SubMenuItem](), isExpandable: false, webPageURL: .notWebPage))
            }
        }
        
        
        
        //Set Name and Information ID
        self.UpdateProfileRefreshSideMenuTableView()
        //*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*//

        
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateProfileRefreshSideMenuTableView), name: NSNotification.Name(rawValue: "UPDATEPSIDEMENU"), object: nil)
    }
    
    @objc func UpdateProfileRefreshSideMenuTableView() {
        //Set Name and Information ID
        let getLang = AppGetAppLanguage()

        if let isLogin = UserDefaults.standard.value(forKey: "is_login") as? Bool {
            if isLogin {
                self.lbl_name.text = strGetUserFullName(SKDataKeys.name.rawValue, langCode: getLang)
                let strIDText = "Information ID".localized("")
                self.lbl_infoID.text = "\(strIDText) : " + strGetUserName_Email(SKDataKeys.membership_no.rawValue)
                self.btnLoginSignUp.isHidden = true
                self.constraint_lblBottom.constant = 22
                
                let strProfile = strGetUserName_Email(SKDataKeys.profile_picture.rawValue)
                if strProfile != "" {
                    self.img_Profile.af_setImage(withURL: URL(string: strProfile)!)
                }
                else {
                    self.img_Profile.image = #imageLiteral(resourceName: "user")
                }
            }
            else {
                self.lbl_name.text = ""
                self.lbl_infoID.text = "Login / Signup".localized("")
                self.btnLoginSignUp.isHidden = false
                self.constraint_lblBottom.constant = 12
            }
        }
        else {
            self.lbl_name.text = ""
            self.lbl_infoID.text = "Login / Signup".localized("")
            self.btnLoginSignUp.isHidden = false
            self.constraint_lblBottom.constant = 12
        }
    }
    
    // MARK:- Custom Methods
    
    final func setupView() {
        self.navigationController?.navigationBar.isHidden = true

        tableView.register(UINib(nibName: String(describing: SideMenuCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SideMenuCell.self))
        
        tableView.register(UINib(nibName: String(describing: SideMenuHeaderView.self), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: SideMenuHeaderView.self))
    }
    
    //MARK: UIButton Method Action
    @IBAction func btnLogin_signUpAction(_ sender: UIButton) {
        SideMenuManager.default.menuPushStyle = .replace
        let loginScreenVC = LoginVC.instantiate(fromAppStoryboard: .Main)
        SideMenuManager.default.menuLeftNavigationController?.pushViewController(loginScreenVC, animated: true)
        
    }
    
    
    
}

extension SideMenuVC: UITableViewDataSource ,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrSideMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let headerView = UINib(nibName: String(describing: SideMenuHeaderView.self), bundle: nil).instantiate(withOwner: nil, options: nil).first as? SideMenuHeaderView {
            
            headerView.menuTitleLabel.text = arrSideMenuItems[section].headerTitle
            
            headerView.arrowImageView.isHidden = arrSideMenuItems[section].subItems.count > 0 ? false : true
            headerView.menuItemImageView.image = UIImage(named: arrSideMenuItems[section].imageName)
            
            headerView.headerTapAction = { [unowned self] in
                
                if self.arrSideMenuItems[section].subItems.count > 0 {
                    self.arrSideMenuItems[section].isExpandable = !self.arrSideMenuItems[section].isExpandable
                    self.tableView.reloadSections(IndexSet(integer: section), with: .automatic)
                    
                } else {
                    SideMenuManager.default.menuPushStyle = .replace
                    let strTitle = self.arrSideMenuItems[section].headerTitle
                    
                    if strTitle == "Profile".localized("") {
                        let obj_viewProfile = ViewProfileVC.instantiate(fromAppStoryboard: .Main)
                        obj_viewProfile.title = strTitle
                        SideMenuManager.default.menuLeftNavigationController?.pushViewController(obj_viewProfile, animated: true)
                    }
                    else if strTitle == "My Family".localized("") {
                        let obj_family = MyFamilyVC.instantiate(fromAppStoryboard: .Main)
                        obj_family.title = strTitle
                        SideMenuManager.default.menuLeftNavigationController?.pushViewController(obj_family, animated: true)
                    }
                    else if strTitle == "Search".localized("") {
                        let obj_search = SearchVC.instantiate(fromAppStoryboard: .Main)
                        obj_search.title = strTitle
                        SideMenuManager.default.menuLeftNavigationController?.pushViewController(obj_search, animated: true)
                    }
                    else if strTitle == "Matrimonial".localized("") {
                        
                        let mainScreenVC = MainScreenVC.instantiate(fromAppStoryboard: .Main)
                        mainScreenVC.navigationTitle = strTitle
                        
                        if let isLogin = UserDefaults.standard.value(forKey: "is_login") as? Bool {
                            if isLogin {
                                let str_URL = WebPagesURL.MetromonialWithUserID.rawValue + strGetUserID()
                                mainScreenVC.urlToLoad = str_URL

                                /*DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2, execute: {
                                    if let url = URL (string: str_URL) {
                                        let svc = SFSafariViewController(url: url)
                                        self.present(svc, animated: true, completion: nil)
                                    }
                                })*/
                                
                            }
                            else {
                                mainScreenVC.urlToLoad = WebPagesURL.Metromonial.rawValue
                            }
                        }
                        else {
                            mainScreenVC.urlToLoad = WebPagesURL.Metromonial.rawValue
                        }
                        SideMenuManager.default.menuLeftNavigationController?.pushViewController(mainScreenVC, animated: true)
                    }
                    else if strTitle == "Change Language".localized("") {
                        let obj_changeLanguage = ChnageLanguageVC.instantiate(fromAppStoryboard: .Main)
                        obj_changeLanguage.title = strTitle
                        SideMenuManager.default.menuLeftNavigationController?.pushViewController(obj_changeLanguage, animated: true)
                    }
                    else if strTitle == "Change Password".localized("") {
                        let obj_changePassword = ChangePasswordVC.instantiate(fromAppStoryboard: .Main)
                        obj_changePassword.title = strTitle
                        SideMenuManager.default.menuLeftNavigationController?.pushViewController(obj_changePassword, animated: true)
                    }
                    else if strTitle == "Sign out".localized("") {
                        
                        // Create the alert controller
                        let alertController = UIAlertController(title: "Sign out".localized(""), message: AlertMessages.logout.localized(""), preferredStyle: .alert)
                        
                        // Create the actions
                        let okAction = UIAlertAction(title: "Yes".localized(""), style: UIAlertAction.Style.default) {
                            UIAlertAction in
                            NSLog("OK Pressed")
                            self.CallAPIforLogOut()

                        }
                        let cancelAction = UIAlertAction(title: "No".localized(""), style: UIAlertAction.Style.cancel) {
                            UIAlertAction in
                            NSLog("Cancel Pressed")
                        }
                        
                        // Add the actions
                        alertController.addAction(okAction)
                        alertController.addAction(cancelAction)
                        
                        // Present the controller
                        self.present(alertController, animated: true, completion: nil)
                        
                    }
                    else {
                        let mainScreenVC = MainScreenVC.instantiate(fromAppStoryboard: .Main)
                        mainScreenVC.navigationTitle = strTitle
                        mainScreenVC.urlToLoad = self.arrSideMenuItems[section].webPageURL.rawValue
                        SideMenuManager.default.menuLeftNavigationController?.pushViewController(mainScreenVC, animated: true)
                    }

                }
            }
            return headerView
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrSideMenuItems[section].isExpandable == true {
            
            return arrSideMenuItems[section].subItems.count
            
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SideMenuCell.self), for: indexPath) as? SideMenuCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        cell.titleLabel.text = arrSideMenuItems[indexPath.section].subItems[indexPath.row].title
        
        //For Cell Tapped
        cell.cellTapAction = { [unowned self] in
            
            
            
            
            SideMenuManager.default.menuPushStyle = .replace
            let mainScreenVC = MainScreenVC.instantiate(fromAppStoryboard: .Main)
            mainScreenVC.navigationTitle = self.arrSideMenuItems[indexPath.section].subItems[indexPath.row].title
            
            if indexPath.row == 0 {
                mainScreenVC.urlToLoad = WebPagesURL.AboutSamaj.rawValue
            }
            else if indexPath.row == 1 {
                 mainScreenVC.urlToLoad = WebPagesURL.ObjectivesofSVPS.rawValue
            }
            else if indexPath.row == 2 {
                 mainScreenVC.urlToLoad = WebPagesURL.History.rawValue
            }
            else if indexPath.row == 3 {
                 mainScreenVC.urlToLoad = WebPagesURL.Trustee.rawValue
            }
            SideMenuManager.default.menuLeftNavigationController?.pushViewController(mainScreenVC, animated: true)
        }
        
        
        return cell
    }
    
    
    
    func CallAPIforLogOut() {
        
        let param = ["token_id": strGetUserName_Email(SKDataKeys.token_id.rawValue)]
        
        ShowProgressHud(message: "please wait...".localized(""))
        
        print(URL_LogoutUser, param)
        
        ServiceCustom.shared.requestURLwithData(URL_LogoutUser, Method: "POST", parameters: param, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        UserDefaults.standard.removeObject(forKey: "is_login")
                        UserDefaults.standard.removeObject(forKey: "AllUserData")
                        let forgotVC = LoginVC.instantiate(fromAppStoryboard: .Main)
                        let navigationController = UINavigationController(rootViewController: forgotVC)
                        AppDelegate.sharedDelegate.window?.rootViewController = navigationController
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
}


