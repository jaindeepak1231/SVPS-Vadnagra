//
//  SearchVC.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 28/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import SideMenu

class SearchVC: UIViewController, filterDataselection {
    
    var strPoleNAme = ""
    var strSaakhNAme = ""
    var strCityNAme = ""
    var strMobile = ""
    var strProfession = ""

    var strPoleID = ""
    var strSaakhID = ""
    var strCityID = ""
    var strProfessionID = ""
    var arrSearch = NSMutableArray()
    var arr_SearchData = [SearchListData]()
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnView: UIControl!
    @IBOutlet weak var imgSearch: UIImageView!
    
    private var currentListPage : Int = 0
    private var isLoadingList : Bool = false
    private var activityIndicator: LoadMoreActivityIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupUI()
        
        
        //Register Table Cell
        self.tblView.register(UINib.init(nibName: "SearchTableCell"
            , bundle: nil), forCellReuseIdentifier: "SearchTableCell")
        //*******************************************************//
        
        activityIndicator = LoadMoreActivityIndicator(tableView: self.tblView, spacingFromLastCell: -30, spacingFromLastCellWhenLoadMoreActionStart: 30)
        
        self.initSetUpOfView()
    }
    
    
    
    // MARK:- Custom Methods
    
    final func setupUI() {
        
        self.title = "Search".localized("")
        
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
        self.btnView.addTarget(self, action: #selector(searchBtnTap), for: .touchUpInside)
    }
    
    @objc func searchBtnTap(){
        let objFilter = self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        objFilter.delegate = self
        objFilter.strMobile = self.strMobile
        objFilter.strPoleID = self.strPoleID
        objFilter.strCityID = self.strCityID
        objFilter.strSaakhID = self.strSaakhID
        objFilter.strPoleNAme = self.strPoleNAme
        objFilter.strCityNAme = self.strCityNAme
        objFilter.strSaakhNAme = self.strSaakhNAme
        objFilter.strProfessionID = self.strProfessionID
        objFilter.strProfessionName = self.strProfession
        self.navigationController?.pushViewController(objFilter, animated: true)
    }
    
    // MARK:- IBActions
    @objc func sideMenuButtonTapped() {
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    
    //MARK: Protocol Deletegate
    func filterValueselectionBack(is_success: Bool, mobile: String, poleName: String, poleID: String, SaakhName: String, saakhID: String, CityName: String, CityID: String, ProfessionID: String, Profession_name: String) {
        self.strMobile = mobile
        self.strPoleID = poleID
        self.strCityID = CityID
        self.strSaakhID = saakhID
        self.strPoleNAme = poleName
        self.strCityNAme = CityName
        self.strSaakhNAme = SaakhName
        self.strProfessionID = ProfessionID
        self.strProfession = Profession_name
        self.arr_SearchData.removeAll()
        self.arrSearch.removeAllObjects()
        self.tblView.reloadData()
        self.currentListPage = 0
        self.CallApiForGetSearchData(mobile: mobile, poleID: poleID, saakhID: saakhID, CityID: CityID, professionID: ProfessionID)
    }
    
    
    func CallApiForGetSearchData(mobile: String, poleID: String, saakhID: String, CityID: String, professionID: String) {
        
        let param = ["page_no" : self.currentListPage,
                     "mobile": mobile,
                     "pole_id": poleID,
                     "saakh_id": saakhID,
                     "city_id": CityID,
                     "profession_id": professionID] as [String : Any]
        
        ShowProgressHud(message: "please wait...".localized(""))
        
        print(URL_searchMember, param)
        
        ServiceCustom.shared.requestURLwithData(URL_searchMember, Method: "POST", parameters: param, completion: { (request, response, jsonObj, dataa)  in
            
            NotificationCenter.default.post(name: NSNotification.Name.init("HIDELOADMORE"), object: nil)
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let arrData = dictResult["data"] as? NSArray {
                            if self.currentListPage == 0 {
                                self.arrSearch = arrData.mutableCopy() as? NSMutableArray ?? []
                            }
                            else {
                                let arr_Tem = arrData.mutableCopy() as? NSMutableArray ?? []
                                for dicTemp in arr_Tem {
                                    self.arrSearch.add(dicTemp)
                                }
                            }
                        }
                        
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(SearchData.self, from: data)
                                
                                if let arrCat = arrData.data {
                                    if self.currentListPage == 0 {
                                        self.arr_SearchData = arrCat
                                    }
                                    else {
                                        for DIctem in arrCat {
                                            self.arr_SearchData.append(DIctem)
                                        }
                                    }
                                }
                                self.isLoadingList = arrData.data?.count == 0 ? true : false
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
    
}



// MARK: UICOllection Veiew Delegate and Datasource Method
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func loadMoreItemsForList() {
        self.currentListPage += 1
        self.CallApiForGetSearchData(mobile: self.strMobile, poleID: self.strPoleID, saakhID: self.strSaakhID, CityID: self.strCityID, professionID: self.strProfessionID)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        self.activityIndicator.scrollViewDidScroll(scrollView: scrollView, loadMoreAction: {

            DispatchQueue.global(qos: .utility).async {

                if !self.isLoadingList {
                    self.isLoadingList = true
                    self.loadMoreItemsForList()

                    NotificationCenter.default.addObserver(forName: NSNotification.Name.init("HIDELOADMORE"), object: nil, queue: nil, using: { (noti) in

                        sleep(1)
                        DispatchQueue.main.async { [weak self] in
                            self?.activityIndicator.loadMoreActionFinshed(scrollView: scrollView)
                        }
                        
                    })
                }else{
                    
                    sleep(2)
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.loadMoreActionFinshed(scrollView: scrollView)
                    }
                }
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_SearchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: SearchTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as! SearchTableCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        let strImg = self.arr_SearchData[indexPath.row].profile_picture ?? ""
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
        
        let strFName = langCode == "en" ? self.arr_SearchData[indexPath.row].first_name ?? "" : self.arr_SearchData[indexPath.row].first_name_gj ?? ""
        let strMName = langCode == "en" ? self.arr_SearchData[indexPath.row].middle_name ?? "" : self.arr_SearchData[indexPath.row].middle_name_gj ?? ""
        let strLName = langCode == "en" ? self.arr_SearchData[indexPath.row].last_name ?? "" : self.arr_SearchData[indexPath.row].last_name_gj ?? ""
        let strName = "\(strFName) \(strMName) \(strLName)"
        cell.lbl_Name.text = strName
        
        cell.lbl_Mobile.text = "Mo :- \(self.arr_SearchData[indexPath.row].mobile ?? "")"
        

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
        if let dicData = self.arrSearch[indexPath.row] as? NSDictionary {
            if let strFamily = dicData["familyMember"] as? String {
                if strFamily == "" {
                    let objDetil = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailVC
                    objDetil.arr_SearchDetailData.append(self.arr_SearchData[indexPath.row])
                    self.navigationController?.pushViewController(objDetil, animated: true)
                }
            }
            else {
                var arr_TempData = [SearchListData]()
                
                if let arrFamilyMAmeber = dicData["familyMember"] as? NSArray {
                    for family in arrFamilyMAmeber {
                        if let dicFamily = family as? NSDictionary {
                            let strmobile = dicFamily["mobile"] as? String ?? ""
                            let strFname = dicFamily["first_name"] as? String ?? ""
                            let strFnameGJ = dicFamily["first_name_gj"] as? String ?? ""
                            let strMname = dicFamily["middle_name"] as? String ?? ""
                            let strMnameGJ = dicFamily["middle_name_gj"] as? String ?? ""
                            let strLname = dicFamily["last_name"] as? String ?? ""
                            let strLnameGJ = dicFamily["last_name_gj"] as? String ?? ""
                            let strProfile = dicFamily["profile_picture"] as? String ?? ""
                            let strRelation = dicFamily["relation"] as? String ?? ""
                            let strRelationGJ = dicFamily["relation_gj"] as? String ?? ""
                            
                            //let dic1 = SearchListData.init(first_name: strFname, first_name_gj: strFnameGJ, last_name: strLname, last_name_gj: strLnameGJ, middle_name: strMname, middle_name_gj: strMnameGJ, mobile: strmobile, profile_picture: strProfile, relation: strRelation, relation_gj: strRelationGJ)
                            
                            //arr_TempData.append(dic1)
                        }
                    }
                }
                arr_TempData.insert(self.arr_SearchData[indexPath.row], at: 0)

                let objDetil = self.storyboard?.instantiateViewController(withIdentifier: "SearchDetailVC") as! SearchDetailVC
                objDetil.arr_SearchDetailData = arr_TempData
                self.navigationController?.pushViewController(objDetil, animated: true)
            }
            //debugPrint(strFamily)
        }
    }
}
