//
//  MyFamilyVC.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 02/06/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import SideMenu

class MyFamilyVC: UIViewController {

    var arr_FamilyData = [FamilyListData]()
    var arrSearch = NSMutableArray()
    var arr_SearchData = [SearchListData]()
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnView: UIControl!
    @IBOutlet weak var imgSearch: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupUI()
        
        
        //Register Table Cell
        self.tblView.register(UINib.init(nibName: "SearchTableCell"
            , bundle: nil), forCellReuseIdentifier: "SearchTableCell")
        //*******************************************************//
        
        
        self.initSetUpOfView()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            self.CallApiForGetFamilyData()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateProfileRefreshFamilyList), name: NSNotification.Name(rawValue: "UPDATEPFAMILYLIST"), object: nil)
    }
    
    @objc func UpdateProfileRefreshFamilyList() {
        self.CallApiForGetFamilyData()
    }
    
    //MARK:- CallAPI for get lising
    
    func CallApiForGetFamilyData() {
        
        ShowProgressHud(message: "please wait...".localized(""))

        let param = ["user_id" : strGetUserID()]
        
        print(URL_getFamilyProfile, param)
        
        ServiceCustom.shared.requestURLwithData(URL_getFamilyProfile, Method: "POST", parameters: param, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(FamilyData.self, from: data)
                                
                                if let arrCat = arrData.data {
                                    self.arr_FamilyData = arrCat
                                }
                                self.tblView.reloadData()
                            }
                            catch {
                                print(error.localizedDescription)
                                DismissProgressHud()
                            }
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
    }
    
    // MARK:- Custom Methods
    
    final func setupUI() {
        
        self.title = "Family".localized("")
        
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
    
    
    func initSetUpOfView(){
        self.btnView.layer.cornerRadius = self.btnView.layer.frame.height / 2
        self.btnView.addTarget(self, action: #selector(addBtnTap), for: .touchUpInside)
    }
    
    @objc func addBtnTap() {
        let objAdd = self.storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        objAdd.isScreenFrom = "AddFamily_Member"
        //objProfile.dicFamilyListData = self.arr_FamilyData[indexPath.row]
        self.navigationController?.pushViewController(objAdd, animated: true)
    }
    
    // MARK:- IBActions
    @objc func sideMenuButtonTapped() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }

}



// MARK: UICOllection Veiew Delegate and Datasource Method
extension MyFamilyVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_FamilyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as! SearchTableCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        let strImg = self.arr_FamilyData[indexPath.row].profile_picture ?? ""
        if strImg != "" {
            cell.img_Search.af_setImage(withURL: URL(string: strImg)!)
        }
        else {
            cell.img_Search.image = #imageLiteral(resourceName: "user")
        }
        
        //Add Shadow
        cell.view_BG.layer.shadowColor = UIColor.lightGray.cgColor
        cell.view_BG.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        cell.view_BG.layer.shadowRadius = 5
        cell.view_BG.shadowOpacity = 3
        cell.view_BG.clipsToBounds = false
        cell.view_BG.layer.masksToBounds = false
        //((((((((((((((((((((()()()()))))))))))))))))))))))//
        
        let langCode = AppGetAppLanguage()
        
        let strFName = langCode == "en" ? self.arr_FamilyData[indexPath.row].first_name ?? "" : self.arr_FamilyData[indexPath.row].first_name_gj ?? ""
        let strMName = langCode == "en" ? self.arr_FamilyData[indexPath.row].middle_name ?? "" : self.arr_FamilyData[indexPath.row].middle_name_gj ?? ""
        let strLName = langCode == "en" ? self.arr_FamilyData[indexPath.row].last_name ?? "" : self.arr_FamilyData[indexPath.row].last_name_gj ?? ""
        let strName = "\(strFName) \(strMName) \(strLName)"
        cell.lbl_Name.text = strName
        
        cell.lbl_Mobile.text = "Mo :- \(self.arr_FamilyData[indexPath.row].mobile ?? "")"
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (tableView.numberOfSections - 1){
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objProfile = self.storyboard?.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        objProfile.isScreenFrom = "Family_Profile"
        objProfile.dicFamilyListData = self.arr_FamilyData[indexPath.row]
        self.navigationController?.pushViewController(objProfile, animated: true)
    }
//        if let dicData = self.arr_FamilyData[indexPath.row] as? NSDictionary {
//            if let strFamily = dicData["familyMember"] as? String {
//                if strFamily == "" {
//                    let objDetil = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailVC
//                    objDetil.arr_SearchDetailData.append(self.arr_SearchData[indexPath.row])
//                    self.navigationController?.pushViewController(objDetil, animated: true)
//                }
//            }
//            else {
//                var arr_TempData = [SearchListData]()
//                
//                if let arrFamilyMAmeber = dicData["familyMember"] as? NSArray {
//                    for family in arrFamilyMAmeber {
//                        if let dicFamily = family as? NSDictionary {
//                            let strmobile = dicFamily["mobile"] as? String ?? ""
//                            let strFname = dicFamily["first_name"] as? String ?? ""
//                            let strFnameGJ = dicFamily["first_name_gj"] as? String ?? ""
//                            let strMname = dicFamily["middle_name"] as? String ?? ""
//                            let strMnameGJ = dicFamily["middle_name_gj"] as? String ?? ""
//                            let strLname = dicFamily["last_name"] as? String ?? ""
//                            let strLnameGJ = dicFamily["last_name_gj"] as? String ?? ""
//                            let strProfile = dicFamily["profile_picture"] as? String ?? ""
//                            let strRelation = dicFamily["relation"] as? String ?? ""
//                            let strRelationGJ = dicFamily["relation_gj"] as? String ?? ""
//                            
//                            //let dic1 = SearchListData.init(first_name: strFname, first_name_gj: strFnameGJ, last_name: strLname, last_name_gj: strLnameGJ, middle_name: strMname, middle_name_gj: strMnameGJ, mobile: strmobile, profile_picture: strProfile, relation: strRelation, relation_gj: strRelationGJ)
//                            
//                            //arr_TempData.append(dic1)
//                        }
//                    }
//                }
//                arr_TempData.insert(self.arr_SearchData[indexPath.row], at: 0)
//                
//                let objDetil = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailVC
//                objDetil.arr_SearchDetailData = arr_TempData
//                self.navigationController?.pushViewController(objDetil, animated: true)
//            }
//            //debugPrint(strFamily)
//        }
//    }
}
