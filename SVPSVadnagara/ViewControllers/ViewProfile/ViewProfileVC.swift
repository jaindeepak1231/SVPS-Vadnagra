//
//  ViewProfileVC.swift
//  SVPSVadnagara
//
//  Created by Varun on 07/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import SideMenu
import AlamofireImage
import MessageUI

class ProfileRowsData: NSObject {
    
    var key = ""
    var numOfrows = 0
    var title = ""
    var value = ""
    
    convenience init(_ rows: Int, _ key: String, _ title:String, _ value: String) {
        self.init()
        self.key = key
        self.numOfrows = rows
        self.title = title
        self.value = value
    }
}


class ViewProfileVC: UIViewController {

    var dicListData = SearchListData()
    var dicFamilyListData = FamilyListData()
    var arrSectionsRow: [ProfileRowsData]! = [ProfileRowsData]()
    
    var isScreenFrom = ""
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var middleNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var mobileNumberButton: UIButton!
    @IBOutlet weak var telephoneNumberButton: UIButton!
    @IBOutlet weak var relationLabel: UILabel!
    @IBOutlet weak var materialStatusLabel: UILabel!
    @IBOutlet weak var poleLabel: UILabel!
    @IBOutlet weak var shakhLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var pincodeLabel: UILabel!
    @IBOutlet weak var birthdateLabel: UILabel!
    @IBOutlet weak var bloodGroupLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
    @IBOutlet weak var occupationLabel: UILabel!
    @IBOutlet weak var industryLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyAddressLabel: UILabel!
    @IBOutlet weak var companyPhoneNumberButton: UIButton!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var tblView: UITableView!
    
    var profileDetails: LoginData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register Table Cell
        self.tblView.register(UINib.init(nibName: "ProfileTableCell", bundle: nil), forCellReuseIdentifier: "ProfileTableCell")
        
        self.tblView.register(UINib.init(nibName: "ProfileImageTableCell", bundle: nil), forCellReuseIdentifier: "ProfileImageTableCell")
        
        self.tblView.register(UINib.init(nibName: "FamilyDetailImaeTableCell", bundle: nil), forCellReuseIdentifier: "FamilyDetailImaeTableCell")
        //*******************************************************//

        setupUI()
        
        if self.isScreenFrom == "Another_Profile" {
            self.title = "View Profile".localized("")
            self.setUpforProfileSectionsData()
        }
        else if self.isScreenFrom == "Family_Profile" {
            self.title = "View Family".localized("")
            self.setUpforProfileSectionsData()
        }
        else {
            self.title = "View Profile".localized("")
            setUpforSectionsData()
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.UpdateProfileRefreshTableView), name: NSNotification.Name(rawValue: "UPDATEPROFLIE"), object: nil)
    }
    
    @objc func UpdateProfileRefreshTableView() {
        self.setUpforSectionsData()
    }

    // MARK:- Custom Methods
    
    final func setupUI() {

        if self.isScreenFrom == "Another_Profile" || self.isScreenFrom == "Family_Profile" {
            self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
            self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
            self.navigationController?.navigationBar.tintColor = .white
            
            navigationItem.leftItemsSupplementBackButton = true
            navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        }
        else {
            let leftMenuButton = UIBarButtonItem(image: UIImage(named: "ic_action_menu"), style: .plain, target: self, action: #selector(sideMenuButtonTapped))
            self.navigationItem.leftBarButtonItem = leftMenuButton
            self.navigationController?.navigationBar.tintColor = UIColor.white
            self.navigationController?.navigationBar.topItem?.leftBarButtonItem?.tintColor = .white
            
            setupMenu()
        }
        
        
    }
    
    //MARK: API Call
    func CallAPIForRequestMetromonial() {
        
        let param = ["user_id" : self.dicFamilyListData.user_id ?? ""]
        
        ShowProgressHud(message: "please wait...".localized(""))
        
        print(URL_sendMetromonialRequest, param)
        
        ServiceCustom.shared.requestURLwithData(URL_sendMetromonialRequest, Method: "POST", parameters: param, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        
                        self.dicFamilyListData.action = 2
                        self.tblView.reloadData()
                        NotificationCenter.default.post(name: Notification.Name("UPDATEPFAMILYLIST"), object: nil)
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
    //*********************************************************************//
    //*********************************************************************//
    
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
        
        let langCode = AppGetAppLanguage()
        let strmaleFme = strGetUserName_Email(SKDataKeys.gender.rawValue)
        let strmaleFemale = langCode == "en" ? strmaleFme.lowercased() == "male" ? "Male" : "Female" : strmaleFme.lowercased() == "male" ? "પુરુષ" : "સ્ત્રી"
        
        self.arrSectionsRow.append(ProfileRowsData.init(1, "ProfileImage", "ProfileImage", strGetUserName_Email(SKDataKeys.profile_picture.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1, SKDataKeys.first_name.rawValue, "First Name".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.first_name.rawValue : SKDataKeys.first_name_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.middle_name.rawValue, "Middle Name".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.middle_name.rawValue : SKDataKeys.middle_name_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.last_name.rawValue, "Last Name".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.last_name.rawValue : SKDataKeys.last_name_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.gender.rawValue, "Gender".localized(""), strmaleFemale))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.email.rawValue, "Email".localized(""), strGetUserName_Email(SKDataKeys.email.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.mobile.rawValue, "Mobile No.".localized(""), strGetUserName_Email(SKDataKeys.mobile.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.telephone.rawValue, "Telephone Number".localized(""), strGetUserName_Email(SKDataKeys.telephone.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.relation.rawValue, "Relation".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.relation.rawValue : SKDataKeys.relation_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.marital_status.rawValue, "Marital Status".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.marital_status.rawValue : SKDataKeys.marital_status_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.pole_name.rawValue, "Pole".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.pole_name.rawValue : SKDataKeys.pole_name_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.saakh.rawValue, "Shakh".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.saakh.rawValue : SKDataKeys.saakh_name_gj.rawValue)))
        
        //Privious Shak Add
        /*let gender = strGetUserName_Email(SKDataKeys.gender.rawValue)
        
        let str_relation = strGetUserName_Email(langCode == "en" ? SKDataKeys.relation.rawValue : SKDataKeys.relation_gj.rawValue)
        
        let married = strGetUserName_Email(langCode == "en" ? SKDataKeys.marital_status.rawValue : SKDataKeys.marital_status_gj.rawValue)
        
        if str_relation == "Self-Female" || str_relation == "પોતે-સ્ત્રી" {
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.address.rawValue, "Previous Shakh".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.previous_saakh.rawValue : SKDataKeys.previous_saakh_gj.rawValue)))
        }
        else if (married == "married" || married == "પરણિત") &&  (gender == "female" || gender == "સ્ત્રી") {
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.address.rawValue, "Previous Shakh".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.previous_saakh.rawValue : SKDataKeys.previous_saakh_gj.rawValue)))
        }*/
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.address.rawValue, "Previous Shakh".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.previous_saakh.rawValue : SKDataKeys.previous_saakh_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.address.rawValue, "Address".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.address.rawValue : SKDataKeys.address_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.area.rawValue, "Area".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.area.rawValue : SKDataKeys.area_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.city.rawValue, "City".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.city.rawValue : SKDataKeys.city_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.country.rawValue, "Country".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.country.rawValue : SKDataKeys.country_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.pincode.rawValue, "Pincode".localized(""), strGetUserName_Email(SKDataKeys.pincode.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.birthdate.rawValue, "Birthdate".localized(""), strGetUserName_Email(SKDataKeys.birthdate.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.blood_group.rawValue, "Blood group".localized(""), strGetUserName_Email(SKDataKeys.blood_group.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.eduction.rawValue, "Education".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.eduction.rawValue : SKDataKeys.eduction_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.profession_name.rawValue, "Occupation".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.profession_name.rawValue : SKDataKeys.profession_name_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1, SKDataKeys.business_type_name.rawValue, "Industry".localized(""), strGetUserName_Email(langCode == "en" ?  SKDataKeys.business_type_name.rawValue : SKDataKeys.business_type_name_gj.rawValue)))
        
        let business_othrt = strGetUserName_Email(langCode == "en" ?  SKDataKeys.business_type_name.rawValue : SKDataKeys.business_type_name_gj.rawValue)
        
        if business_othrt.lowercased() == (langCode == "en" ? "other" : "અન્ય" ) {
            self.arrSectionsRow.append(ProfileRowsData.init(1, SKDataKeys.business_type_name.rawValue, "Industry".localized(""), strGetUserName_Email(langCode == "en" ?  SKDataKeys.other_business_type_name.rawValue : SKDataKeys.other_business_type_name_gj.rawValue)))
        }
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.company_name.rawValue, "Company Name".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.company_name.rawValue : SKDataKeys.company_name_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.company_address.rawValue, "Company Address".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.company_address.rawValue : SKDataKeys.company_address_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.company_phone.rawValue, "Company Phone No.".localized(""), strGetUserName_Email(SKDataKeys.company_phone.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.position.rawValue, "Position".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.position.rawValue : SKDataKeys.position_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.hobbies.rawValue, "Hobbies".localized(""), strGetUserName_Email(langCode == "en" ? SKDataKeys.hobbies.rawValue : SKDataKeys.hobbies_gj.rawValue)))
        
        self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.reference.rawValue, "Reference".localized(""), strGetUserName_Email(SKDataKeys.reference.rawValue)))

        self.tblView.reloadData()
    }
    
    
    //Setup Sections for Register user
    func setUpforProfileSectionsData() {
        self.arrSectionsRow.removeAll()
        
        let langCode = AppGetAppLanguage()
        
        if self.isScreenFrom == "Another_Profile"  {
            
            var strmaleFemale = ""
            let strmaleFme = self.dicListData.gender ?? ""
            if strmaleFme != "" {
                strmaleFemale = langCode == "en" ? strmaleFme.lowercased() == "male" ? "Male" : "Female" : strmaleFme.lowercased() == "male" ? "પુરુષ" : "સ્ત્રી"
            }
            
            self.arrSectionsRow.append(ProfileRowsData.init(1, "ProfileImage", "ProfileImage", self.dicListData.profile_picture ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1, SKDataKeys.first_name.rawValue, "First Name".localized(""), langCode == "en" ? self.dicListData.first_name ?? "" : self.dicListData.first_name_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.middle_name.rawValue, "Middle Name".localized(""), langCode == "en" ? self.dicListData.middle_name ?? "" : self.dicListData.middle_name_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.last_name.rawValue, "Last Name".localized(""), langCode == "en" ? self.dicListData.last_name ?? "" : self.dicListData.last_name_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.gender.rawValue, "Gender".localized(""), strmaleFemale))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.mobile.rawValue, "Mobile No.".localized(""), self.dicListData.mobile ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.telephone.rawValue, "Telephone Number".localized(""), self.dicListData.telephone ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.relation.rawValue, "Relation".localized(""), langCode == "en" ? self.dicListData.relation ?? "" : self.dicListData.relation_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.marital_status.rawValue, "Marital Status".localized(""), langCode == "en" ? self.dicListData.marital_status ?? "" : self.dicListData.marital_status_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.pole_name.rawValue, "Pole".localized(""), langCode == "en" ? self.dicListData.pole_name ?? "" : self.dicListData.pole_name_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.saakh.rawValue, "Shakh".localized(""), langCode == "en" ? self.dicListData.saakh ?? "" : self.dicListData.saakh_name_gj ?? ""))
            
            //Privious Shak Add
            /*var gender = self.dicListData.gender ?? ""
            if gender == "" {
                gender = strmaleFemale.lowercased()
            }
            let str_relation = self.dicListData.relation ?? ""
            let str_relation_gj = self.dicListData.relation_gj ?? ""
            let str_married = self.dicListData.marital_status
            let str_married_gj = self.dicListData.marital_status_gj
            
            if str_relation == "Self-Female" || str_relation_gj == "પોતે-સ્ત્રી" {
                self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.previous_saakh.rawValue, "Previous Shakh".localized(""), langCode == "en" ? self.dicFamilyListData.previous_saakh ?? "" : self.dicFamilyListData.previous_saakh_gj ?? ""))
            }
            else if (str_married == "married" || str_married_gj == "પરણિત") &&  (gender == "female" || gender == "સ્ત્રી") {
                self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.previous_saakh.rawValue, "Previous Shakh".localized(""), langCode == "en" ? self.dicFamilyListData.previous_saakh ?? "" : self.dicFamilyListData.previous_saakh_gj ?? ""))
            }*/
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.previous_saakh.rawValue, "Previous Shakh".localized(""), langCode == "en" ? self.dicFamilyListData.previous_saakh ?? "" : self.dicFamilyListData.previous_saakh_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.address.rawValue, "Address".localized(""), langCode == "en" ? self.dicListData.address ?? "" : self.dicListData.address_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.area.rawValue, "Area".localized(""), langCode == "en" ? self.dicListData.area ?? "" : self.dicListData.area_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.city.rawValue, "City".localized(""), langCode == "en" ? self.dicListData.city ?? "" : self.dicListData.city_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.country.rawValue, "Country".localized(""), langCode == "en" ? self.dicListData.country ?? "" : self.dicListData.country_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.pincode.rawValue, "Pincode".localized(""), self.dicListData.pincode ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.eduction.rawValue, "Education".localized(""), langCode == "en" ? self.dicListData.eduction ?? "" : self.dicListData.eduction_gj ?? ""))
            
        }
            //For Family Profile
        else if self.isScreenFrom == "Family_Profile" {
            
            let strmaleFme = self.dicFamilyListData.gender ?? ""
            let strmaleFemale = langCode == "en" ? strmaleFme.lowercased() == "male" ? "Male" : "Female" : strmaleFme.lowercased() == "male" ? "પુરુષ" : "સ્ત્રી"
            
            self.arrSectionsRow.append(ProfileRowsData.init(1, "FamilyProfileImage", "FamilyProfileImage", self.dicFamilyListData.profile_picture ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1, SKDataKeys.first_name.rawValue, "First Name".localized(""), langCode == "en" ? self.dicFamilyListData.first_name ?? "" : self.dicFamilyListData.first_name_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.middle_name.rawValue, "Middle Name".localized(""), langCode == "en" ? self.dicFamilyListData.middle_name ?? "" : self.dicFamilyListData.middle_name_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.last_name.rawValue, "Last Name".localized(""), langCode == "en" ? self.dicFamilyListData.last_name ?? "" : self.dicFamilyListData.last_name_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.gender.rawValue, "Gender".localized(""), strmaleFemale))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.mobile.rawValue, "Mobile No.".localized(""), self.dicFamilyListData.mobile ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.telephone.rawValue, "Telephone Number".localized(""), self.dicFamilyListData.telephone ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.relation.rawValue, "Relation".localized(""), langCode == "en" ? self.dicFamilyListData.relation ?? "" : self.dicFamilyListData.relation_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.marital_status.rawValue, "Marital Status".localized(""), langCode == "en" ? self.dicFamilyListData.marital_status ?? "" : self.dicFamilyListData.marital_status_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.pole_name.rawValue, "Pole".localized(""), langCode == "en" ? self.dicFamilyListData.pole_name ?? "" : self.dicFamilyListData.pole_name_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.saakh.rawValue, "Shakh".localized(""), langCode == "en" ? self.dicFamilyListData.saakh ?? "" : self.dicFamilyListData.saakh_name_gj ?? ""))
            
            
            //Privious Shak Add
            /*let gender = self.dicFamilyListData.gender ?? ""
            let str_relation = self.dicFamilyListData.relation ?? ""
            let str_relation_gj = self.dicFamilyListData.relation_gj ?? ""
            let str_married = self.dicFamilyListData.marital_status
            let str_married_gj = self.dicFamilyListData.marital_status_gj
            
            if str_relation == "Self-Female" || str_relation_gj == "પોતે-સ્ત્રી" {
                self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.previous_saakh.rawValue, "Previous Shakh".localized(""), langCode == "en" ? self.dicFamilyListData.previous_saakh ?? "" : self.dicFamilyListData.previous_saakh_gj ?? ""))
            }
            else if (str_married == "married" || str_married_gj == "પરણિત") &&  (gender == "female" || gender == "સ્ત્રી") {
                self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.previous_saakh.rawValue, "Previous Shakh".localized(""), langCode == "en" ? self.dicFamilyListData.previous_saakh ?? "" : self.dicFamilyListData.previous_saakh_gj ?? ""))
            }*/

            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.previous_saakh.rawValue, "Previous Shakh".localized(""), langCode == "en" ? self.dicFamilyListData.previous_saakh ?? "" : self.dicFamilyListData.previous_saakh_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.address.rawValue, "Address".localized(""), langCode == "en" ? self.dicFamilyListData.address ?? "" : self.dicFamilyListData.address_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.area.rawValue, "Area".localized(""), langCode == "en" ? self.dicFamilyListData.area ?? "" : self.dicFamilyListData.area_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.city.rawValue, "City".localized(""), langCode == "en" ? self.dicFamilyListData.city ?? "" : self.dicFamilyListData.city_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.country.rawValue, "Country".localized(""), langCode == "en" ? self.dicFamilyListData.country ?? "" : self.dicFamilyListData.country_gj ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.pincode.rawValue, "Pincode".localized(""), self.dicFamilyListData.pincode ?? ""))
            
            self.arrSectionsRow.append(ProfileRowsData.init(1,  SKDataKeys.eduction.rawValue, "Education".localized(""), langCode == "en" ? self.dicFamilyListData.eduction ?? "" : self.dicFamilyListData.eduction_gj ?? ""))
        }
        self.tblView.reloadData()
    }
    
    
    final func setButtonTitle(button: UIButton, text: String) {
        
        let attributedTitle = button.attributedTitle(for: .normal)
        attributedTitle?.setValue(text, forKey: "string")
        button.setAttributedTitle(attributedTitle, for: .normal)

    }
    
    func dialNumber(number : String) {
        
        if let url = URL(string: "tel://\(number)"),
            UIApplication.shared.canOpenURL(url) {
            
            UIApplication.shared.openURL(url)
            
        }
    }

    // MARK:- IBActions
    
    @objc func sideMenuButtonTapped() {
        
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @IBAction func editProfileButtonTapped(_ sender: UIButton) {
    }
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        
        if !MFMailComposeViewController.canSendMail() {
            showAlert(message: "Mail services are not available")
            return
        }
        
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        
        // Configure the fields of the interface.
        composeVC.setToRecipients([profileDetails?.email ?? ""])
        composeVC.setSubject("")
        composeVC.setMessageBody("", isHTML: false)
        
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    
    @IBAction func mobileNumberButtonTapped(_ sender: UIButton) {
        
        dialNumber(number: profileDetails?.mobile ?? "")
    }
    
    @IBAction func telephoneNumberButtonTapped(_ sender: UIButton) {
        
        dialNumber(number: profileDetails?.telephone ?? "")
    }
    
    @IBAction func companyPhoneNumberButtonTapped(_ sender: UIButton) {
        
        dialNumber(number: profileDetails?.company_phone ?? "")
    }
    
}

// MARK: UICOllection Veiew Delegate and Datasource Method
extension ViewProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrSectionsRow.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSectionsRow[section].numOfrows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strKey = self.arrSectionsRow[indexPath.section].key
        let strID = self.arrSectionsRow[indexPath.section].title
        let strValue = self.arrSectionsRow[indexPath.section].value
        
        if strID == "ProfileImage" {
            let cell: ProfileImageTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileImageTableCell", for: indexPath) as! ProfileImageTableCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear

            cell.btn_Edit.isHidden = self.isScreenFrom == "Another_Profile" ? true : false
            cell.constraint_btnHeight.constant = self.isScreenFrom == "Another_Profile" ? 0 : 30
            cell.constraint_Img_Top.constant = self.isScreenFrom == "Another_Profile" ? 30 : 15
            
            if strValue != "" {                
                cell.img_Profile.af_setImage(withURL: URL(string: strValue)!)
            }
            else {
                cell.img_Profile.image = #imageLiteral(resourceName: "user")
            }
            
            cell.btn_Edit.setTitle("Edit".localized(""), for: UIControl.State.normal)
            cell.btn_Edit.tag = indexPath.row
            cell.btn_Edit.addTarget(self, action: #selector(fun_EditProfile(sender:)), for: UIControl.Event.touchUpInside)
            
            return cell
        }
        else if strID == "FamilyProfileImage" {
            let cell: FamilyDetailImaeTableCell = tableView.dequeueReusableCell(withIdentifier: "FamilyDetailImaeTableCell", for: indexPath) as! FamilyDetailImaeTableCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear

            if strValue != "" {
                cell.img_Profile.af_setImage(withURL: URL(string: strValue)!)
            }
            else {
                cell.img_Profile.image = #imageLiteral(resourceName: "user")
            }
            
            let strAction = self.dicFamilyListData.action ?? 0
            if strAction == 1 {
                cell.btn_Edit.isHidden = false
                cell.btn_SingleEdit.isHidden = true
                cell.btn_Metromonial.isHidden = false
                cell.btn_Metromonial.setTitle("Request For Matrimonial".localized(""), for: UIControl.State.normal)
            }
            else if strAction == 2 {
                cell.btn_Edit.isHidden = false
                cell.btn_SingleEdit.isHidden = true
                cell.btn_Metromonial.isHidden = false
                cell.btn_Metromonial.setTitle("Matrimonial Requested".localized(""), for: UIControl.State.normal)
            }
            else if strAction == 3 {
                cell.btn_Edit.isHidden = false
                cell.btn_SingleEdit.isHidden = true
                cell.btn_Metromonial.isHidden = false
                cell.btn_Metromonial.setTitle("Add/Edit Matrimonial".localized(""), for: UIControl.State.normal)
            }
            else {
                cell.btn_Edit.isHidden = true
                cell.btn_Metromonial.isHidden = true
                cell.btn_SingleEdit.isHidden = false
            }
            
            cell.btn_Edit.setTitle("Edit".localized(""), for: UIControl.State.normal)
            cell.btn_SingleEdit.setTitle("Edit".localized(""), for: UIControl.State.normal)
            cell.btn_Edit.tag = indexPath.row
            cell.btn_SingleEdit.tag = indexPath.row
            cell.btn_Edit.addTarget(self, action: #selector(fun_EditFamilyProfile(sender:)), for: UIControl.Event.touchUpInside)
            cell.btn_SingleEdit.addTarget(self, action: #selector(fun_EditFamilyProfile(sender:)), for: UIControl.Event.touchUpInside)

            cell.btn_Metromonial.tag = strAction
            cell.btn_Metromonial.addTarget(self, action: #selector(fun_RequestMetromonial(sender:)), for: UIControl.Event.touchUpInside)
            
            return cell
        }
        else {
            let cell: ProfileTableCell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableCell", for: indexPath) as! ProfileTableCell
            cell.selectionStyle = .none
            
            cell.lbl_Title.text = strID + " : "
            cell.lbl_Value.text = strValue
            cell.lbl_Value.accessibilityHint = strKey
            cell.lbl_Value.textColor = UIColor.black
            cell.lbl_Value.textColor = UIColor.black
            cell.lbl_Value.accessibilityValue = strValue
            cell.lbl_Title.textColor = Constants.Color.blueColor
           
            if strKey == SKDataKeys.mobile.rawValue || strKey == SKDataKeys.email.rawValue {
                
                let newText = NSMutableAttributedString.init(string: strValue)
                let textRange = NSString(string: strValue)
                let textValueRange = textRange.range(of: strValue)
                
                newText.addAttribute(NSAttributedString.Key.underlineColor, value: Constants.Color.blueColor, range: textValueRange)
                newText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.thick.rawValue, range: textValueRange)
                
                cell.lbl_Value.attributedText = newText
                cell.lbl_Value.textColor = Constants.Color.blueColor
                
                let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(TapResponce(_:)))
                cell.lbl_Value.isUserInteractionEnabled = true
                cell.lbl_Value.addGestureRecognizer(tapGesture)
            }

            return cell
        }
        
        
    }
    
    // MARK:- IBActions Upload Image
    @objc func fun_EditProfile(sender:UIButton) {
        self.view.endEditing(true)
        
        var dicDetail = [String : String]()

        dicDetail[SKDataKeys.profile_picture.rawValue] = strGetUserName_Email(SKDataKeys.profile_picture.rawValue)
        dicDetail[SKDataKeys.first_name.rawValue] = strGetUserName_Email(SKDataKeys.first_name.rawValue)
        dicDetail[SKDataKeys.first_name_gj.rawValue] = strGetUserName_Email(SKDataKeys.first_name_gj.rawValue)
        dicDetail[SKDataKeys.middle_name.rawValue] = strGetUserName_Email(SKDataKeys.middle_name.rawValue)
        dicDetail[SKDataKeys.middle_name_gj.rawValue] = strGetUserName_Email(SKDataKeys.middle_name_gj.rawValue)
        dicDetail[SKDataKeys.last_name.rawValue] = strGetUserName_Email(SKDataKeys.last_name.rawValue)
        dicDetail[SKDataKeys.last_name_gj.rawValue] = strGetUserName_Email(SKDataKeys.last_name_gj.rawValue)
        dicDetail[SKDataKeys.gender.rawValue] = strGetUserName_Email(SKDataKeys.gender.rawValue)
        dicDetail[SKDataKeys.email.rawValue] = strGetUserName_Email(SKDataKeys.email.rawValue)
        dicDetail[SKDataKeys.country_code.rawValue] = strGetUserName_Email(SKDataKeys.country_code.rawValue)
        dicDetail[SKDataKeys.mobile.rawValue] = strGetUserName_Email(SKDataKeys.mobile.rawValue)
        dicDetail[SKDataKeys.telephone.rawValue] = strGetUserName_Email(SKDataKeys.telephone.rawValue)
        dicDetail[SKDataKeys.relation.rawValue] = strGetUserName_Email(SKDataKeys.relation.rawValue)
        dicDetail[SKDataKeys.relation_gj.rawValue] = strGetUserName_Email(SKDataKeys.relation_gj.rawValue)
        dicDetail[SKDataKeys.marital_status.rawValue] = strGetUserName_Email(SKDataKeys.marital_status.rawValue)
        dicDetail[SKDataKeys.marital_status_gj.rawValue] = strGetUserName_Email(SKDataKeys.marital_status_gj.rawValue)
        dicDetail[SKDataKeys.pole_name.rawValue] = strGetUserName_Email(SKDataKeys.pole_name.rawValue)
        dicDetail[SKDataKeys.pole_name_gj.rawValue] = strGetUserName_Email(SKDataKeys.pole_name_gj.rawValue)
        dicDetail[SKDataKeys.pole_id.rawValue] = strGetUserName_Email(SKDataKeys.pole_id.rawValue)
        dicDetail[SKDataKeys.pole_id_gj.rawValue] = strGetUserName_Email(SKDataKeys.pole_id_gj.rawValue)
        dicDetail[SKDataKeys.saakh.rawValue] = strGetUserName_Email(SKDataKeys.saakh.rawValue)
        dicDetail[SKDataKeys.saakh_name_gj.rawValue] = strGetUserName_Email(SKDataKeys.saakh_name_gj.rawValue)
        dicDetail[SKDataKeys.saakh_id.rawValue] = strGetUserName_Email(SKDataKeys.saakh_id.rawValue)
        dicDetail[SKDataKeys.saakh_id_gj.rawValue] = strGetUserName_Email(SKDataKeys.saakh_id_gj.rawValue)
        dicDetail[SKDataKeys.previous_saakh.rawValue] = strGetUserName_Email(SKDataKeys.previous_saakh.rawValue)
        dicDetail[SKDataKeys.previous_saakh_gj.rawValue] = strGetUserName_Email(SKDataKeys.previous_saakh_gj.rawValue)
        dicDetail[SKDataKeys.previous_saakh_id.rawValue] = strGetUserName_Email(SKDataKeys.previous_saakh_id.rawValue)
        dicDetail[SKDataKeys.previous_saakh_id_gj.rawValue] = strGetUserName_Email(SKDataKeys.previous_saakh_id_gj.rawValue)
        dicDetail[SKDataKeys.address.rawValue] = strGetUserName_Email(SKDataKeys.address.rawValue)
        dicDetail[SKDataKeys.address_gj.rawValue] = strGetUserName_Email(SKDataKeys.address_gj.rawValue)
        dicDetail[SKDataKeys.area.rawValue] = strGetUserName_Email(SKDataKeys.area.rawValue)
        dicDetail[SKDataKeys.area_gj.rawValue] = strGetUserName_Email(SKDataKeys.area_gj.rawValue)
        dicDetail[SKDataKeys.city.rawValue] = strGetUserName_Email(SKDataKeys.city.rawValue)
        dicDetail[SKDataKeys.city_gj.rawValue] = strGetUserName_Email(SKDataKeys.city_gj.rawValue)
        dicDetail[SKDataKeys.city_id.rawValue] = strGetUserName_Email(SKDataKeys.city_id.rawValue)
        dicDetail[SKDataKeys.city_id_gj.rawValue] = strGetUserName_Email(SKDataKeys.city_id_gj.rawValue)
        dicDetail[SKDataKeys.country.rawValue] = strGetUserName_Email(SKDataKeys.country.rawValue)
        dicDetail[SKDataKeys.country_gj.rawValue] = strGetUserName_Email(SKDataKeys.country_gj.rawValue)
        dicDetail[SKDataKeys.country_id.rawValue] = strGetUserName_Email(SKDataKeys.country_id.rawValue)
        dicDetail[SKDataKeys.country_id_gj.rawValue] = strGetUserName_Email(SKDataKeys.country_id_gj.rawValue)
        dicDetail[SKDataKeys.pincode.rawValue] = strGetUserName_Email(SKDataKeys.pincode.rawValue)
        dicDetail[SKDataKeys.birthdate.rawValue] = strGetUserName_Email(SKDataKeys.birthdate.rawValue)
        dicDetail[SKDataKeys.blood_group.rawValue] = strGetUserName_Email(SKDataKeys.blood_group.rawValue)
        dicDetail[SKDataKeys.eduction.rawValue] = strGetUserName_Email(SKDataKeys.eduction.rawValue)
        dicDetail[SKDataKeys.eduction_gj.rawValue] = strGetUserName_Email(SKDataKeys.eduction_gj.rawValue)
        dicDetail[SKDataKeys.profession_name.rawValue] = strGetUserName_Email(SKDataKeys.profession_name.rawValue)
        dicDetail[SKDataKeys.profession_name_gj.rawValue] = strGetUserName_Email(SKDataKeys.profession_name_gj.rawValue)
        dicDetail[SKDataKeys.profession_id.rawValue] = strGetUserName_Email(SKDataKeys.profession_id.rawValue)
        dicDetail[SKDataKeys.profession_id_gj.rawValue] = strGetUserName_Email(SKDataKeys.profession_id_gj.rawValue)
        dicDetail[SKDataKeys.business_type_name.rawValue] = strGetUserName_Email(SKDataKeys.business_type_name.rawValue)
        dicDetail[SKDataKeys.business_type_name_gj.rawValue] = strGetUserName_Email(SKDataKeys.business_type_name_gj.rawValue)
        dicDetail[SKDataKeys.business_type_id.rawValue] = strGetUserName_Email(SKDataKeys.business_type_id.rawValue)
        dicDetail[SKDataKeys.business_type_id_gj.rawValue] = strGetUserName_Email(SKDataKeys.business_type_id_gj.rawValue)
        dicDetail[SKDataKeys.other_business_type_name.rawValue] = strGetUserName_Email(SKDataKeys.other_business_type_name.rawValue)
        dicDetail[SKDataKeys.other_business_type_name_gj.rawValue] = strGetUserName_Email(SKDataKeys.other_business_type_name_gj.rawValue)
        dicDetail[SKDataKeys.company_name.rawValue] = strGetUserName_Email(SKDataKeys.company_name.rawValue)
        dicDetail[SKDataKeys.company_name_gj.rawValue] = strGetUserName_Email(SKDataKeys.company_name_gj.rawValue)
        dicDetail[SKDataKeys.company_address.rawValue] = strGetUserName_Email(SKDataKeys.company_address.rawValue)
        dicDetail[SKDataKeys.company_address_gj.rawValue] = strGetUserName_Email(SKDataKeys.company_address_gj.rawValue)
        dicDetail[SKDataKeys.company_phone.rawValue] = strGetUserName_Email(SKDataKeys.company_phone.rawValue)
        dicDetail[SKDataKeys.position.rawValue] = strGetUserName_Email(SKDataKeys.position.rawValue)
        dicDetail[SKDataKeys.position_gj.rawValue] = strGetUserName_Email(SKDataKeys.position_gj.rawValue)
        dicDetail[SKDataKeys.hobbies.rawValue] = strGetUserName_Email(SKDataKeys.hobbies.rawValue)
        dicDetail[SKDataKeys.hobbies_gj.rawValue] = strGetUserName_Email(SKDataKeys.hobbies_gj.rawValue)
        dicDetail[SKDataKeys.reference.rawValue] = strGetUserName_Email(SKDataKeys.reference.rawValue)
        
        let objRegister = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        
        let privShah = dicDetail[SKDataKeys.relation.rawValue] ?? ""
        let privShah_gj = dicDetail[SKDataKeys.relation_gj.rawValue] ?? ""
        let industry = dicDetail[SKDataKeys.business_type_name.rawValue] ?? ""
        let industry_gj = dicDetail[SKDataKeys.business_type_name_gj.rawValue] ?? ""

        objRegister.dictDetail = dicDetail
        objRegister.isScreenFrom = "Edit_profile"
        objRegister.otherIndustry = industry == "Other" ? true : false
        objRegister.otherIndustry = industry_gj == "અન્ય" ? true : false
        objRegister.PriviousShakh = privShah_gj == "પોતે-સ્ત્રી" ? true : false
        objRegister.PriviousShakh = privShah == "Self-Female" ? true : false
        self.navigationController?.pushViewController(objRegister, animated: true)
    }
    
    @objc func TapResponce(_ sender: UITapGestureRecognizer) {
        if let strKey = sender.view?.accessibilityHint {
            if strKey == SKDataKeys.mobile.rawValue {
                makeCall(number: sender.view?.accessibilityValue ?? "")
            }
            else if strKey == SKDataKeys.email.rawValue {
                
                if !MFMailComposeViewController.canSendMail() {
                    showAlert(message: "Mail services are not available")
                    return
                }
                
                let composeVC = MFMailComposeViewController()
                composeVC.mailComposeDelegate = self
                
                // Configure the fields of the interface.
                composeVC.setToRecipients([sender.view?.accessibilityValue ?? ""])
                composeVC.setSubject("")
                composeVC.setMessageBody("", isHTML: false)
                
                // Present the view controller modally.
                self.present(composeVC, animated: true, completion: nil)
            }
        }
    }
    
    
    
    // MARK:- IBActions Upload Image
    @objc func fun_EditFamilyProfile(sender:UIButton) {
        self.view.endEditing(true)
        
        var dicDetail = [String : String]()
        
        dicDetail[SKDataKeys.profile_picture.rawValue] = self.dicFamilyListData.profile_picture ?? ""
        dicDetail[SKDataKeys.first_name.rawValue] = self.dicFamilyListData.first_name ?? ""
        dicDetail[SKDataKeys.first_name_gj.rawValue] = self.dicFamilyListData.first_name_gj ?? ""
        dicDetail[SKDataKeys.middle_name.rawValue] = self.dicFamilyListData.middle_name ?? ""
        dicDetail[SKDataKeys.middle_name_gj.rawValue] = self.dicFamilyListData.middle_name_gj ?? ""
        dicDetail[SKDataKeys.last_name.rawValue] = self.dicFamilyListData.last_name ?? ""
        dicDetail[SKDataKeys.last_name_gj.rawValue] = self.dicFamilyListData.last_name_gj ?? ""
        dicDetail[SKDataKeys.gender.rawValue] = self.dicFamilyListData.gender ?? ""
        dicDetail[SKDataKeys.email.rawValue] = self.dicFamilyListData.email ?? ""
        dicDetail[SKDataKeys.country_code.rawValue] = self.dicFamilyListData.country_code ?? ""
        dicDetail[SKDataKeys.mobile.rawValue] = self.dicFamilyListData.mobile ?? ""

        dicDetail[SKDataKeys.telephone.rawValue] = self.dicFamilyListData.telephone ?? ""
        dicDetail[SKDataKeys.relation.rawValue] = self.dicFamilyListData.relation ?? ""
        dicDetail[SKDataKeys.relation_gj.rawValue] = self.dicFamilyListData.relation_gj ?? ""
        dicDetail[SKDataKeys.marital_status.rawValue] = self.dicFamilyListData.marital_status ?? ""
        dicDetail[SKDataKeys.marital_status_gj.rawValue] = self.dicFamilyListData.marital_status_gj ?? ""
        dicDetail[SKDataKeys.pole_name.rawValue] = self.dicFamilyListData.pole_name ?? ""
        dicDetail[SKDataKeys.pole_name_gj.rawValue] = self.dicFamilyListData.pole_name_gj ?? ""
        dicDetail[SKDataKeys.pole_id.rawValue] = self.dicFamilyListData.pole_id ?? ""
        dicDetail[SKDataKeys.pole_id_gj.rawValue] = self.dicFamilyListData.pole_id_gj ?? ""
        dicDetail[SKDataKeys.saakh.rawValue] = self.dicFamilyListData.saakh ?? ""
        dicDetail[SKDataKeys.saakh_name_gj.rawValue] = self.dicFamilyListData.saakh_name_gj ?? ""
        dicDetail[SKDataKeys.saakh_id.rawValue] = self.dicFamilyListData.saakh_id ?? ""
        dicDetail[SKDataKeys.saakh_id_gj.rawValue] = self.dicFamilyListData.saakh_id_gj  ?? ""
        dicDetail[SKDataKeys.previous_saakh.rawValue] = self.dicFamilyListData.previous_saakh ?? ""
        dicDetail[SKDataKeys.previous_saakh_gj.rawValue] = self.dicFamilyListData.previous_saakh_gj ?? ""
        dicDetail[SKDataKeys.previous_saakh_id.rawValue] = self.dicFamilyListData.previous_saakh_id ?? ""
        dicDetail[SKDataKeys.previous_saakh_id_gj.rawValue] = self.dicFamilyListData.previous_saakh_id_gj ?? ""
        dicDetail[SKDataKeys.address.rawValue] = self.dicFamilyListData.address ?? ""
        dicDetail[SKDataKeys.address_gj.rawValue] = self.dicFamilyListData.address_gj ?? ""
        dicDetail[SKDataKeys.area.rawValue] = self.dicFamilyListData.area ?? ""
        dicDetail[SKDataKeys.area_gj.rawValue] = self.dicFamilyListData.area_gj ?? ""
        dicDetail[SKDataKeys.city.rawValue] = self.dicFamilyListData.city ?? ""
        dicDetail[SKDataKeys.city_gj.rawValue] = self.dicFamilyListData.city_gj ?? ""
        dicDetail[SKDataKeys.city_id.rawValue] = self.dicFamilyListData.city_id ?? ""
        dicDetail[SKDataKeys.city_id_gj.rawValue] = self.dicFamilyListData.city_id_gj ?? ""
        dicDetail[SKDataKeys.country.rawValue] = self.dicFamilyListData.country ?? ""
        dicDetail[SKDataKeys.country_gj.rawValue] = self.dicFamilyListData.country_gj ?? ""
        dicDetail[SKDataKeys.country_id.rawValue] = self.dicFamilyListData.country_id ?? ""
        dicDetail[SKDataKeys.country_id_gj.rawValue] = self.dicFamilyListData.country_id_gj ?? ""
        dicDetail[SKDataKeys.pincode.rawValue] = self.dicFamilyListData.pincode ?? ""
        dicDetail[SKDataKeys.birthdate.rawValue] = self.dicFamilyListData.birthdate ?? ""
        dicDetail[SKDataKeys.blood_group.rawValue] = self.dicFamilyListData.blood_group ?? ""
        dicDetail[SKDataKeys.eduction.rawValue] = self.dicFamilyListData.eduction ?? ""
        dicDetail[SKDataKeys.eduction_gj.rawValue] = self.dicFamilyListData.eduction_gj ?? ""
        dicDetail[SKDataKeys.profession_name.rawValue] = self.dicFamilyListData.profession_name ?? ""
        dicDetail[SKDataKeys.profession_name_gj.rawValue] = self.dicFamilyListData.profession_name_gj ?? ""
        dicDetail[SKDataKeys.profession_id.rawValue] = self.dicFamilyListData.profession_id ?? ""
        dicDetail[SKDataKeys.profession_id_gj.rawValue] = self.dicFamilyListData.profession_id_gj ?? ""
            dicDetail[SKDataKeys.business_type_name.rawValue] = self.dicFamilyListData.business_type_name ?? ""
        dicDetail[SKDataKeys.business_type_name_gj.rawValue] = self.dicFamilyListData.business_type_name_gj ?? ""
        dicDetail[SKDataKeys.business_type_id.rawValue] = self.dicFamilyListData.business_type_id ?? ""
        dicDetail[SKDataKeys.business_type_id_gj.rawValue] = self.dicFamilyListData.business_type_id_gj ?? ""
        dicDetail[SKDataKeys.other_business_type_name.rawValue] = self.dicFamilyListData.other_business_type_name ?? ""
        dicDetail[SKDataKeys.other_business_type_name_gj.rawValue] = self.dicFamilyListData.other_business_type_name_gj ?? ""
        dicDetail[SKDataKeys.company_name.rawValue] = self.dicFamilyListData.company_name ?? ""
        dicDetail[SKDataKeys.company_name_gj.rawValue] = self.dicFamilyListData.company_name_gj ?? ""
        dicDetail[SKDataKeys.company_address.rawValue] = self.dicFamilyListData.company_address ?? ""
        dicDetail[SKDataKeys.company_address_gj.rawValue] = self.dicFamilyListData.company_address_gj ?? ""
        dicDetail[SKDataKeys.company_phone.rawValue] = self.dicFamilyListData.company_phone ?? ""
        dicDetail[SKDataKeys.position.rawValue] = self.dicFamilyListData.position ?? ""
        dicDetail[SKDataKeys.position_gj.rawValue] = self.dicFamilyListData.position_gj ?? ""
        dicDetail[SKDataKeys.hobbies.rawValue] = self.dicFamilyListData.hobbies ?? ""
        dicDetail[SKDataKeys.hobbies_gj.rawValue] = self.dicFamilyListData.hobbies_gj ?? ""
        dicDetail[SKDataKeys.reference.rawValue] = self.dicFamilyListData.reference ?? ""
        dicDetail[SKDataKeys.user_id.rawValue] = self.dicFamilyListData.user_id ?? ""
        
        let objRegister = storyboard?.instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        
        let privShah = dicDetail[SKDataKeys.relation.rawValue] ?? ""
        let privShah_gj = dicDetail[SKDataKeys.relation_gj.rawValue] ?? ""
        let industry = dicDetail[SKDataKeys.business_type_name.rawValue] ?? ""
        let industry_gj = dicDetail[SKDataKeys.business_type_name_gj.rawValue] ?? ""
        
        objRegister.dictDetail = dicDetail
        objRegister.isScreenFrom = "EditFamily_Profile"
        objRegister.familyMemberID = self.dicFamilyListData.user_id ?? ""
        objRegister.otherIndustry = industry == "Other" ? true : false
        objRegister.otherIndustry = industry_gj == "અન્ય" ? true : false
        objRegister.PriviousShakh = privShah_gj == "પોતે-સ્ત્રી" ? true : false
        objRegister.PriviousShakh = privShah == "Self-Female" ? true : false
        self.navigationController?.pushViewController(objRegister, animated: true)
    }
    
    
    // MARK:- IBActions Upload Image
    @objc func fun_RequestMetromonial(sender:UIButton) {
        let strAction = sender.tag
        if strAction == 1 {
            self.CallAPIForRequestMetromonial()
        }
        else if strAction == 2 {
        }
        else if strAction == 3 {
            let objeditMetromonial = self.storyboard?.instantiateViewController(withIdentifier: "EditMetromonialVC") as! EditMetromonialVC
            objeditMetromonial.metromonialID = self.dicFamilyListData.matrimonial_id ?? ""
            objeditMetromonial.familyMemberID = self.dicFamilyListData.user_id ?? ""
            self.navigationController?.pushViewController(objeditMetromonial, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (tableView.numberOfSections - 1){
            return 20
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ViewProfileVC: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}


