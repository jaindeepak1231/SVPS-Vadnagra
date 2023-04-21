//
//  FilterVC.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 28/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField


protocol filterDataselection {
    
func filterValueselectionBack(is_success: Bool, mobile: String, poleName: String, poleID: String, SaakhName: String, saakhID: String, CityName: String, CityID: String, ProfessionID: String, Profession_name: String)
    
}


class FilterVC: UIViewController {
    
    var strSelection = ""
    var strPoleID = ""
    var strSaakhID = ""
    var strCityID = ""
    var strProfessionID = ""
    var strPoleNAme = ""
    var strSaakhNAme = ""
    var strCityNAme = ""
    var strProfessionName = ""
    var strMobile = ""
    var dictDetail = [String:Any]()
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewforFilter: UITableView!
    @IBOutlet weak var constraint_tblView_Y: NSLayoutConstraint!
    @IBOutlet weak var constraint_tblView_Height: NSLayoutConstraint!
    var completionPoleSelectedCell: ((String, String, String, Bool)->Void)?
    var completionShakhSelectedCell: ((String, String, String, Bool)->Void)?
    var completionCitySelectedCell: ((String, String, String, Bool)->Void)?
    var completionProfessionSelectedCell: ((String, String, String, Bool)->Void)?
    
    var arrSectionsRow: [RegisterRowsData]! = [RegisterRowsData]()
    
    var arr_Search_PoleData = [PoleListData]()
    var arr_Search_ShakhData = [ShakhListData]()
    var arr_Search_City = [CityListData]()
    var arr_Search_Profession = [ProfessionListData]()
    var delegate: filterDataselection?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.tblViewforFilter.isHidden = true
        
        self.title = "Filter".localized("")
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        self.navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        
        //Register Table Cell
        self.tblView.register(UINib.init(nibName: "RegisterTableCell", bundle: nil), forCellReuseIdentifier: "RegisterTableCell")
        self.tblView.register(UINib.init(nibName: "ButtonTableCell", bundle: nil), forCellReuseIdentifier: "ButtonTableCell")
        self.tblViewforFilter.register(UINib.init(nibName: "ProfileTableCell" , bundle: nil), forCellReuseIdentifier: "ProfileTableCell")
        //*******************************************************//
        
        //Add Shadow
        self.tblViewforFilter.layer.shadowColor = Constants.Color.blueColor.withAlphaComponent(0.4).cgColor
        self.tblViewforFilter.layer.shadowOffset = CGSize.init(width: 3, height: 3)
        self.tblViewforFilter.layer.shadowRadius = 5
        self.tblViewforFilter.shadowOpacity = 3
        self.tblViewforFilter.clipsToBounds = false
        self.tblViewforFilter.layer.masksToBounds = false
        //((((((((((((((((((((()()()()))))))))))))))))))))))//
        
        
        self.setUpforSectionsData()
        self.setUpValue()
    }
    
    //Setup Sections
    func setUpforSectionsData() {
        self.arrSectionsRow.removeAll()
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.pole_name.rawValue, "Pole".localized(""), ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.saakh.rawValue, "Shakh".localized(""), ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.city.rawValue, "City".localized(""), ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.profession_name.rawValue, "Profession".localized(""), ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.mobile.rawValue, "Mobile".localized(""), ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, "button", "SEARCH".localized(""), ""))
        
        self.tblView.reloadData()
    }
    
    func setUpValue() {
        self.dictDetail[SKDataKeys.pole_id.rawValue] = self.strPoleID
        self.dictDetail[SKDataKeys.saakh_id.rawValue] = self.strSaakhID
        self.dictDetail[SKDataKeys.city_id.rawValue] = self.strCityID
        self.dictDetail[SKDataKeys.profession_id.rawValue] = self.strProfessionID
        self.dictDetail[SKDataKeys.mobile.rawValue] = self.strMobile
        self.dictDetail[SKDataKeys.pole_name.rawValue] = self.strPoleNAme
        self.dictDetail[SKDataKeys.pole_name_gj.rawValue] = self.strPoleNAme
        self.dictDetail[SKDataKeys.saakh.rawValue] = self.strSaakhNAme
        self.dictDetail[SKDataKeys.saakh_name_gj.rawValue] = self.strSaakhNAme
        self.dictDetail[SKDataKeys.city.rawValue] = self.strCityNAme
        self.dictDetail[SKDataKeys.city_gj.rawValue] = self.strCityNAme
        self.dictDetail[SKDataKeys.profession_name.rawValue] = self.strProfessionName
        self.dictDetail[SKDataKeys.profession_name_gj.rawValue] = self.strProfessionName
    }
    
    
    func CallAPIForGetPole(_ txtField: UITextField) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        
        ServiceCustom.shared.requestURLwithData(URL_GetPole, Method: "POST", parameters: nil, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(PoleData.self, from: data)
                                
                                if let arrCat = arrData.data {
                                    app_Delegate.arr_PoleData = arrCat
                                }
                                txtField.becomeFirstResponder()
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
    
    func CallAPIForGetShakh(_ txtField: UITextField) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        
        ServiceCustom.shared.requestURLwithData(URL_GetShakh, Method: "GET", parameters: nil, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(ShakhData.self, from: data)
                                
                                if let arrCat = arrData.data {
                                    app_Delegate.arr_ShakhData = arrCat
                                }
                                txtField.becomeFirstResponder()
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
    
    func CallAPIForGetCity(_ txtField: UITextField) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        
        ServiceCustom.shared.requestURLwithData(URL_GetCity, Method: "POST", parameters: nil, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(CityData.self, from: data)
                                
                                if let arrCat = arrData.data {
                                    app_Delegate.arr_City = arrCat
                                }
                                txtField.becomeFirstResponder()
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
    
    func CallAPIForGetProfession(_ txtField: UITextField) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        
        ServiceCustom.shared.requestURLwithData(URL_GetProfession, Method: "POST", parameters: nil, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(ProfessionData.self, from: data)
                                
                                if let arrProf = arrData.data {
                                    app_Delegate.arr_Profession = arrProf
                                }
                                txtField.becomeFirstResponder()
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
    
    
    
    // MARK:- IBActions
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSearchFilterTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        debugPrint("API Call", self.dictDetail)
        
        let strMobile = self.dictDetail[SKDataKeys.mobile.rawValue] as? String ?? ""
        var strPoleID = self.dictDetail[SKDataKeys.pole_id.rawValue] as? String ?? ""
        var strSaakhID = self.dictDetail[SKDataKeys.saakh_id.rawValue] as? String ?? ""
        var strCityID = self.dictDetail[SKDataKeys.city_id.rawValue] as? String ?? ""
        var strProfID = self.dictDetail[SKDataKeys.profession_id.rawValue] as? String ?? ""
        let strPoleName = self.dictDetail[SKDataKeys.pole_name.rawValue] as? String ?? ""
        let strSaakhName = self.dictDetail[SKDataKeys.saakh.rawValue] as? String ?? ""
        let strCityName = self.dictDetail[SKDataKeys.city.rawValue] as? String ?? ""
        let strProgName = self.dictDetail[SKDataKeys.profession_name.rawValue] as? String ?? ""
        
        
        if strPoleName == "" {
            strPoleID = ""
        }
        if strSaakhName == "" {
            strSaakhID = ""
        }
        if strCityName == "" {
            strCityID = ""
        }
        if strProgName == "" {
            strProfID = ""
        }
        
        
        if strPoleID.trim == "" &&  strSaakhID.trim == "" && strCityID.trim == "" && strMobile.trim == "" && strProfID.trim == "" {
            self.delegate?.filterValueselectionBack(is_success: false, mobile: "", poleName: "", poleID: "", SaakhName: "", saakhID: "", CityName: "", CityID: "", ProfessionID: "", Profession_name: "")
            self.navigationController?.popViewController(animated: true)
        }
        else {
            self.delegate?.filterValueselectionBack(is_success: true, mobile: strMobile, poleName: strPoleName, poleID: strPoleID, SaakhName: strSaakhName, saakhID: strSaakhID, CityName: strCityName, CityID: strCityID, ProfessionID: strProfID, Profession_name: strProgName)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    
}


// MARK: UICOllection Veiew Delegate and Datasource Method
extension FilterVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tblView {
            return self.arrSectionsRow.count
        }
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblView {
            return self.arrSectionsRow[section].numOfrows
        }
        else {
            if self.strSelection == SKDataKeys.pole_name.rawValue {
                return self.arr_Search_PoleData.count
            }
            else if self.strSelection == SKDataKeys.saakh.rawValue {
                return self.arr_Search_ShakhData.count
            }
            else if self.strSelection == SKDataKeys.city.rawValue {
                return self.arr_Search_City.count
            }
            else if self.strSelection == SKDataKeys.profession_name.rawValue {
                return self.arr_Search_Profession.count
            }
            else {
                return 0
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblView {
            
            let strKey = self.arrSectionsRow[indexPath.section].key
            let strID = self.arrSectionsRow[indexPath.section].title
            
            if strKey == "button" {
                let cell: ButtonTableCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableCell", for: indexPath) as! ButtonTableCell
                cell.selectionStyle = .none
                //cell.backgroundColor = UIColor.clear
                
                cell.btnRegister.setTitle(strID.uppercased(), for: UIControl.State.normal)
                cell.btnRegister.addTarget(self, action: #selector(btnSearchFilterTapped(_:)), for: UIControl.Event.touchUpInside)
                
                
                return cell
            }
            else {
                
                
                let cell: RegisterTableCell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableCell", for: indexPath) as! RegisterTableCell
                cell.selectionStyle = .none
                //cell.backgroundColor = UIColor.clear
                
                cell.txt_field.delegate = self
                cell.txt_field.placeholder = strID
                cell.txt_field.selectedTitle = strID
                cell.txt_field.text = self.dictDetail[strKey] as? String ?? ""
                cell.txt_field.accessibilityHint = strKey
                cell.txt_field.accessibilityIdentifier = strKey
                
                let langcode = AppGetAppLanguage()
                
                if strKey == SKDataKeys.pole_name.rawValue {
                    self.completionPoleSelectedCell = {(value, valueGJ, poleID, success) in
                        self.dictDetail[strKey] = value
                        self.dictDetail[SKDataKeys.pole_id.rawValue ] = poleID
                        self.dictDetail[SKDataKeys.pole_name_gj.rawValue ] = valueGJ
                        cell.txt_field.text = langcode == "en" ? value : valueGJ
                    }
                }
                else if strKey == SKDataKeys.saakh.rawValue {
                    self.completionShakhSelectedCell = {(value, valueGJ, saakhID, success) in
                        self.dictDetail[strKey] = value
                        self.dictDetail[SKDataKeys.saakh_id.rawValue ] = saakhID
                        self.dictDetail[SKDataKeys.saakh_name_gj.rawValue ] = valueGJ
                        cell.txt_field.text = langcode == "en" ? value : valueGJ
                    }
                }
                else if strKey == SKDataKeys.city.rawValue {
                    self.completionCitySelectedCell = {(value, valueGJ, cityID, success) in
                        self.dictDetail[strKey] = value
                        self.dictDetail[SKDataKeys.city_id.rawValue ] = cityID
                        self.dictDetail[SKDataKeys.city_gj.rawValue ] = valueGJ
                        cell.txt_field.text = langcode == "en" ? value : valueGJ
                    }
                }
                else if strKey == SKDataKeys.profession_name.rawValue {
                    self.completionProfessionSelectedCell = {(value, valueGJ, profID, success) in
                        self.dictDetail[strKey] = value
                        self.dictDetail[SKDataKeys.profession_id.rawValue ] = profID
                        self.dictDetail[SKDataKeys.profession_name_gj.rawValue ] = valueGJ
                        cell.txt_field.text = langcode == "en" ? value : valueGJ
                    }
                }
                else if strKey == SKDataKeys.mobile.rawValue {
                    cell.txt_field.addDoneToolbar()
                    cell.txt_field.autocapitalizationType = .none
                    cell.txt_field.keyboardType = .phonePad
                }
                else {
                    cell.txt_field.autocapitalizationType = .words
                    cell.txt_field.keyboardType = .default
                }
                
                
                cell.txt_field.tag = indexPath.row
                cell.txt_field.addTarget(self, action: #selector(textFildTapped(_:)), for: UIControl.Event.editingChanged)
                
                return cell
            }
        }
        else {
            
            let cell: ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell", for: indexPath) as! ProfileTableCell
            cell.selectionStyle = .none
            cell.lbl_Value.text = ""
            cell.lbl_Indicator.isHidden = false
            cell.constrint_lblLeading.constant = 4
            cell.lbl_Title.textColor = Constants.Color.blueColor
            
            var strValu = ""
            let langCode = AppGetAppLanguage()
            
            if self.strSelection == SKDataKeys.pole_name.rawValue {
                strValu = langCode == "en" ?  self.arr_Search_PoleData[indexPath.row].pole_name ?? "" : self.arr_Search_PoleData[indexPath.row].pole_name_gj ?? ""
            }
            else if self.strSelection == SKDataKeys.saakh.rawValue {
                strValu = langCode == "en" ? self.arr_Search_ShakhData[indexPath.row].saakh_name ?? "" : self.arr_Search_ShakhData[indexPath.row].saakh_name_gj ?? ""
            }
            else if self.strSelection == SKDataKeys.city.rawValue {
                strValu = langCode == "en" ? self.arr_Search_City[indexPath.row].city_name ?? "" :  self.arr_Search_City[indexPath.row].city_name_gj ?? ""
            }
            else if self.strSelection == SKDataKeys.profession_name.rawValue {
                strValu = langCode == "en" ? self.arr_Search_Profession[indexPath.row].profession_name ?? "" :  self.arr_Search_Profession[indexPath.row].profession_name_gj ?? ""
            }
            
            cell.lbl_Title.text = strValu
            
            
            return cell
            
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblViewforFilter {
            
            if self.strSelection == SKDataKeys.pole_name.rawValue {
                self.view.endEditing(true)
                self.tblViewforFilter.isHidden = true
                let poleID = arr_Search_PoleData[indexPath.row].pole_id ?? ""
                let strEng = arr_Search_PoleData[indexPath.row].pole_name ?? ""
                let strGJ = arr_Search_PoleData[indexPath.row].pole_name_gj ?? ""
                
                if let callBack = self.completionPoleSelectedCell {
                    callBack(strEng, strGJ, poleID, true)
                }
            }
            else if self.strSelection == SKDataKeys.saakh.rawValue {
                self.view.endEditing(true)
                self.tblViewforFilter.isHidden = true
                let sakhID = arr_Search_ShakhData[indexPath.row].saakh_id ?? ""
                let strEng = arr_Search_ShakhData[indexPath.row].saakh_name ?? ""
                let strGJ = arr_Search_ShakhData[indexPath.row].saakh_name_gj ?? ""
                
                if let callBack = self.completionShakhSelectedCell {
                    callBack(strEng, strGJ, sakhID, true)
                }
            }
            else if self.strSelection == SKDataKeys.city.rawValue {
                self.view.endEditing(true)
                self.tblViewforFilter.isHidden = true
                let cityID = arr_Search_City[indexPath.row].city_id ?? ""
                let strEng = arr_Search_City[indexPath.row].city_name ?? ""
                let strGJ = arr_Search_City[indexPath.row].city_name_gj ?? ""
                
                if let callBack = self.completionCitySelectedCell {
                    callBack(strEng, strGJ, cityID, true)
                }
            }
            else if self.strSelection == SKDataKeys.profession_name.rawValue {
                self.view.endEditing(true)
                self.tblViewforFilter.isHidden = true
                let ProfessionID = arr_Search_Profession[indexPath.row].profession_id ?? ""
                let strEng = arr_Search_Profession[indexPath.row].profession_name ?? ""
                let strGJ = arr_Search_Profession[indexPath.row].profession_name_gj ?? ""
                
                if let callBack = self.completionProfessionSelectedCell {
                    callBack(strEng, strGJ, ProfessionID, true)
                }
            }
        }
    }
}

//MARK:- textfield Delegate & Actions

extension FilterVC: UITextFieldDelegate {
    
    
    // MARK:- IBActions
    @objc func textFildTapped(_ txtFild: UITextField) {
        if let strID = txtFild.accessibilityHint {
            let strTxt = txtFild.text ?? ""
            let btn = (txtFild as AnyObject).convert(CGPoint.zero, to: self.tblView)
            let get_Y = btn.y
            

            if strID == SKDataKeys.pole_name.rawValue {
                self.constraint_tblView_Y.constant = get_Y + 50
                self.searchPoleData(strTxt)
            }
            else if strID == SKDataKeys.saakh.rawValue {
                self.constraint_tblView_Y.constant = get_Y + 50
                self.searchSaakhData(strTxt)
            }
            else if strID == SKDataKeys.city.rawValue {
                self.searchCityData(strTxt, y_position: get_Y)
            }
            else if strID == SKDataKeys.profession_name.rawValue {
                self.searchProfesssionData(strTxt, y_position: get_Y)
            }
            else {
                self.tblViewforFilter.isHidden = true
            }
            
        }
    }
    
    //MARK: Search Data
    func searchPoleData(_ searchText: String) {
        
        let langCode = AppGetAppLanguage()
        
        self.arr_Search_PoleData = app_Delegate.arr_PoleData.filter({ (poleData) -> Bool in
            let strSearchTEXT = langCode == "en" ? poleData.pole_name ?? "" : poleData.pole_name_gj ?? ""
            return strSearchTEXT.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        let getHeight: CGFloat = CGFloat(self.arr_Search_PoleData.count * 40)
        if getHeight > 150 {
            self.constraint_tblView_Height.constant = 150
        }
        else {
            self.constraint_tblView_Height.constant = getHeight
        }
        self.view.layoutIfNeeded()
        self.tblViewforFilter.isHidden = self.arr_Search_PoleData.count == 0 ? true : false
        self.tblViewforFilter.reloadData()
    }
    
    func searchSaakhData(_ searchText: String) {
        let langCode = AppGetAppLanguage()
        
        self.arr_Search_ShakhData = app_Delegate.arr_ShakhData.filter({ (saakhData) -> Bool in
            let strSearchTEXT = langCode == "en" ? saakhData.saakh_name ?? "" : saakhData.saakh_name_gj ?? ""
            return strSearchTEXT.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        let getHeight: CGFloat = CGFloat(self.arr_Search_ShakhData.count * 40)
        if getHeight > 150 {
            self.constraint_tblView_Height.constant = 150
        }
        else {
            self.constraint_tblView_Height.constant = getHeight
        }
        self.view.layoutIfNeeded()
        self.tblViewforFilter.isHidden = self.arr_Search_ShakhData.count == 0 ? true : false
        self.tblViewforFilter.reloadData()
    }
    
    func searchCityData(_ searchText: String, y_position: CGFloat) {
        let langCode = AppGetAppLanguage()
        
        self.arr_Search_City = app_Delegate.arr_City.filter({ (cityData) -> Bool in
            
            let strSearchTEXT = langCode == "en" ? cityData.city_name ?? "" : cityData.city_name_gj ?? ""
            
            return strSearchTEXT.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        let getHeight: CGFloat = CGFloat(self.arr_Search_City.count * 40)
        if getHeight > 150 {
            self.constraint_tblView_Height.constant = 150
            self.constraint_tblView_Y.constant = y_position - 150
        }
        else {
            self.constraint_tblView_Height.constant = getHeight
            self.constraint_tblView_Y.constant = y_position - getHeight
        }
        self.view.layoutIfNeeded()
        self.tblViewforFilter.isHidden = self.arr_Search_City.count == 0 ? true : false
        self.tblViewforFilter.reloadData()
    }
    
    func searchProfesssionData(_ searchText: String, y_position: CGFloat) {
        let langCode = AppGetAppLanguage()
        
        self.arr_Search_Profession = app_Delegate.arr_Profession.filter({ (professionData) -> Bool in
            
            let strSearchTEXT = langCode == "en" ? professionData.profession_name ?? "" : professionData.profession_name_gj ?? ""
            
            return strSearchTEXT.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        })
        
        let getHeight: CGFloat = CGFloat(self.arr_Search_Profession.count * 40)
        if getHeight > 150 {
            self.constraint_tblView_Height.constant = 150
            self.constraint_tblView_Y.constant = y_position - 150
        }
        else {
            self.constraint_tblView_Height.constant = getHeight
            self.constraint_tblView_Y.constant = y_position - getHeight
        }
        self.view.layoutIfNeeded()
        self.tblViewforFilter.isHidden = self.arr_Search_Profession.count == 0 ? true : false
        self.tblViewforFilter.reloadData()
    }
    //******//
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let strID = textField.accessibilityHint {
            self.tblViewforFilter.isHidden = true
            
            if strID == SKDataKeys.pole_name.rawValue || strID == SKDataKeys.pole_name_gj.rawValue {
                if app_Delegate.arr_PoleData.count != 0 {
                    self.strSelection = strID
                }
                else {
                    self.strSelection = strID
                    self.CallAPIForGetPole(textField)
                }
                
            }
            else if strID == SKDataKeys.saakh.rawValue || strID == SKDataKeys.saakh_name_gj.rawValue {
                if app_Delegate.arr_ShakhData.count != 0 {
                    self.strSelection = strID
                }
                else {
                    self.strSelection = strID
                    self.CallAPIForGetShakh(textField)
                }
            }
            else if strID == SKDataKeys.city.rawValue || strID == SKDataKeys.city_gj.rawValue {
                if app_Delegate.arr_City.count != 0 {
                    self.strSelection = strID
                }
                else {
                    self.strSelection = strID
                    self.CallAPIForGetCity(textField)
                }
            }
            else if strID == SKDataKeys.profession_name.rawValue || strID == SKDataKeys.profession_name_gj.rawValue {
                if app_Delegate.arr_Profession.count != 0 {
                    self.strSelection = strID
                }
                else {
                    self.strSelection = strID
                    self.CallAPIForGetProfession(textField)
                }
            }
            else {
                self.tblViewforFilter.isHidden = true
            }
        }
    }
    
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if  let strID = textField.accessibilityHint {
            
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            if strID == SKDataKeys.birthdate.rawValue {
                let ACCEPTABLE_NUMBERS = "1234567890-/"
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_NUMBERS).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if string != filtered{
                    return false
                }
                return newString.length <= 25
            }
            else if strID == "name" {
                let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                if string != filtered{
                    return false
                }
                return newString.length <= 100
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let strID = textField.accessibilityIdentifier {
            dictDetail[strID] = textField.text
        }
    }
    
}



