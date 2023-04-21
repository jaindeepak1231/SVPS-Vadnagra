//
//  RegisterVC.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 22/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField

class RegisterRowsData: NSObject {
    
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

class RegisterVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    var isScreenFrom = ""
    var strSelection = ""
    var correctScreenFrom = ""
    var isNewMember = false
    var familyMemberID = ""
    var isEditFamilyProfile = false
    var toolBar = UIToolbar()
    var is_ChangePhoto = false
    var SelectPhoto = UIImage()
    var otherIndustry = false
    var PriviousShakh = false
    var dictDetail = [String:Any]()
    
    var birthdatePicker = UIDatePicker()
    @IBOutlet weak var tblView: UITableView!
    let imagePicker = UIImagePickerController()
    var didSelectedDate: ((UIDatePicker)->Void)? = nil
    var completionGenderSelectedCell: ((String, Bool)->Void)?
    var completionCountryCodeSelectedCell: ((String, Bool)->Void)?
    var completionRelationSelectedCell: ((String, String, Bool)->Void)?
    var completionRelationGJSelectedCell: ((String, String, Bool)->Void)?
    var completionMaritalStatusSelectedCell: ((String, String, Bool)->Void)?
    var completionMaritalStatusGJSelectedCell: ((String, String, Bool)->Void)?
    var completionPoleSelectedCell: ((String, String, String, Bool)->Void)?
    var completionPoleGJSelectedCell: ((String, String, String, Bool)->Void)?
    var completionShakhSelectedCell: ((String, String, String, Bool)->Void)?
    var completionShakhGJSelectedCell: ((String, String, String, Bool)->Void)?
    var completionPriviousShakhSelectedCell: ((String, String, String, Bool)->Void)?
    var completionPriviousShakhGJSelectedCell: ((String, String, String, Bool)->Void)?
    var completionCitySelectedCell: ((String, String, String, Bool)->Void)?
    var completionCityGJSelectedCell: ((String, String, String, Bool)->Void)?
    var completionCountrySelectedCell: ((String, String, String, Bool)->Void)?
    var completionCountryGJSelectedCell: ((String, String, String, Bool)->Void)?
    var completionBloodgroupSelectedCell: ((String, Bool)->Void)?
    var completionBusinessSelectedCell: ((String, String, String, Bool)->Void)?
    var completionBusinessGJSelectedCell: ((String, String, String, Bool)->Void)?
    var completionProfessionSelectedCell: ((String, String, String, Bool)->Void)?
    var completionProfessionGJSelectedCell: ((String, String, String, Bool)->Void)?
    var completionPositionSelectedCell: ((String, Bool)->Void)?
    var completionBloodGroupSelectedCell: ((String, Bool)->Void)?

    var pickerForGender: UIPickerView = UIPickerView()
    var arrSectionsRow: [RegisterRowsData]! = [RegisterRowsData]()
    
    var arr_Gender = [GenderListData]()
    var arr_BloodGroup = [BloodGroupListData]()
    var arr_CountryCodeListData = [CountryCodeListData]()
    var arr_RelationData = [RelationListData]()
    var arr_MeritalData = [MaritalListData]()
    var arr_PoleData = [PoleListData]()
    var arr_ShakhData = [ShakhListData]()
    var arr_City = [CityListData]()
    var arr_Country = [CountryListData]()
    var arr_Profession = [ProfessionListData]()
    var arr_Business = [BusinessListData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Sign up".localized("")
        self.imagePicker.delegate = self
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        self.navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        setupUI()
        
        //Register Table Cell
        self.tblView.register(UINib.init(nibName: "RegisterImageTableCell"
            , bundle: nil), forCellReuseIdentifier: "RegisterImageTableCell")
        self.tblView.register(UINib.init(nibName: "RegisterTableCell", bundle: nil), forCellReuseIdentifier: "RegisterTableCell")
        self.tblView.register(UINib.init(nibName: "ButtonTableCell", bundle: nil), forCellReuseIdentifier: "ButtonTableCell")
        //*******************************************************//
        
        self.correctScreenFrom = self.isScreenFrom
        
        if self.isScreenFrom == "Edit_profile" {
            self.isEditFamilyProfile = false
            self.title = "Edit profile".localized("")
            self.setUpforSectionsData()
        }
        else if self.isScreenFrom == "AddFamily_Member" {
            self.isNewMember = true
            self.isEditFamilyProfile = true
            self.isScreenFrom = "Edit_profile"
            self.title = "Add New Family Member".localized("")
            self.setUpforSectionsData()
            self.setUpValue()
        }
        else if self.isScreenFrom == "EditFamily_Profile" {
            self.isEditFamilyProfile = true
            self.isScreenFrom = "Edit_profile"
            self.title = "Edit profile".localized("")
            self.setUpforSectionsData()
        }
        else {
            self.isEditFamilyProfile = false
            self.setUpforSectionsData()
            self.setUpValue()
        }
        
        //set gender array
        let dic = GenderListData.init(gender_guj: "પુરુષ", gender_english: "Male")
        self.arr_Gender.append(dic)
        let dic1 = GenderListData.init(gender_guj: "સ્ત્રી", gender_english: "Female")
        self.arr_Gender.append(dic1)
        
        //Set Blood Group array
        let dic_A_plus = BloodGroupListData.init(blood_group: "A+")
        let dic_B_plus = BloodGroupListData.init(blood_group: "B+")
        let dic_AB_plus = BloodGroupListData.init(blood_group: "AB+")
        let dic_O_plus = BloodGroupListData.init(blood_group: "O+")
        let dic_A_Nagatice = BloodGroupListData.init(blood_group: "A-")
        let dic_B_Nagatice = BloodGroupListData.init(blood_group: "B-")
        let dic_AB_Nagatice = BloodGroupListData.init(blood_group: "AB-")
        let dic_O_Nagaticve = BloodGroupListData.init(blood_group: "AB-")
        self.arr_BloodGroup.append(dic_A_plus)
        self.arr_BloodGroup.append(dic_B_plus)
        self.arr_BloodGroup.append(dic_AB_plus)
        self.arr_BloodGroup.append(dic_O_plus)
        self.arr_BloodGroup.append(dic_A_Nagatice)
        self.arr_BloodGroup.append(dic_B_Nagatice)
        self.arr_BloodGroup.append(dic_AB_Nagatice)
        self.arr_BloodGroup.append(dic_O_Nagaticve)
        //**********************//
        
        pickerForGender.delegate  = self
        pickerForGender.dataSource = self
        pickerForGender.reloadAllComponents()
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("RELOADTABLEVIEW"), object: nil, queue: nil, using: { (noti) in
            self.tblView.reloadData()
        })
        
        
    }
    
    final func setupUI() {
        self.navigationController?.navigationBar.barTintColor = Constants.Color.blueColor
    }
    
    //Setup Sections
    func setUpforSectionsData() {
        self.arrSectionsRow.removeAll()

        self.arrSectionsRow.append(RegisterRowsData.init(1, "ProfileImage", "ProfileImage", ""))
        
        if self.isScreenFrom != "Edit_profile" {
            self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.membership_no.rawValue, "Reference of family Name/પરિવાર ની ઓળખાણ", ""))
        }
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.first_name.rawValue, "First Name*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.first_name_gj.rawValue, "પ્રથમ નામ*", ""))

        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.middle_name.rawValue, "Middle Name*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.middle_name_gj.rawValue, "પિતાનું/પતિનું નામ*", ""))

        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.last_name.rawValue, "Last Name*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.last_name_gj.rawValue, "અટક*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.gender.rawValue, "Gender (જાતિ)*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.email.rawValue, "Email/ઇમેઇલ*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.country_code.rawValue, "Country Code/દેશનો કોડ", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.mobile.rawValue, "Mobile No./મોબાઈલ નમ્બર*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.telephone.rawValue, "Telephone Number/ટેલીફોન નંબર", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.relation.rawValue, "Relation*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.relation_gj.rawValue, "સંબંધ*", ""))

        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.marital_status.rawValue, "Marital Status", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.marital_status_gj.rawValue, "વૈવાહિક સ્થિતિ", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.pole_name.rawValue, "Pole*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.pole_name_gj.rawValue, "પોળ*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.saakh.rawValue, "Shakh*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.saakh_name_gj.rawValue, "શાખ*", ""))

        if PriviousShakh {
            self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.previous_saakh.rawValue, "Previous Shakh", ""))
            
            self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.previous_saakh_gj.rawValue, "અગાઉના શાખ", ""))
        }
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.address.rawValue, "Address", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.address_gj.rawValue, "સરનામું", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.area.rawValue, "Area*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.area_gj.rawValue, "વિસ્તાર*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.city.rawValue, "City*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.city_gj.rawValue, "શહેર*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.country.rawValue, "Country*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.country_gj.rawValue, "દેશ*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.pincode.rawValue, "Pincode/પીન કોડ", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.birthdate.rawValue, "Birthdate/જન્મતારીખ*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.blood_group.rawValue, "Blood group/બ્લડ ગ્રુપ", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.eduction.rawValue, "Education", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.eduction_gj.rawValue, "અભ્યાસ", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.profession_name.rawValue, "Occupation", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.profession_name_gj.rawValue, "વ્યવસાય", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.business_type_name.rawValue, "Industry", ""))

        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.business_type_name_gj.rawValue, "ઉદ્યોગ", ""))
        
        if otherIndustry {
            self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.other_business_type_name.rawValue, "Industry", ""))
            
            self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.other_business_type_name_gj.rawValue, "ઉદ્યોગ", ""))
        }
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.company_name.rawValue, "Company Name", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.company_name_gj.rawValue, "કંપની નું નામ", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.company_address.rawValue, "Company Address", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.company_address_gj.rawValue, "કંપનીનું સરનામું", ""))

        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.company_phone.rawValue, "Company Phone No./કંપની ફોન નં", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.position.rawValue, "Position", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.position_gj.rawValue, "હોદ્દો", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.hobbies.rawValue, "Hobbies", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.hobbies_gj.rawValue, "રૂચિ અને શોખ", ""))

        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.reference.rawValue, "Reference/ઓળખાણ", ""))
        
        if self.isScreenFrom != "Edit_profile" {
            self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.password.rawValue, "Password*", ""))
            
            self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.confirm_password.rawValue, "Confirm password*", ""))
        }
        
        if self.isScreenFrom == "Edit_profile" {
            if self.isNewMember {
                self.arrSectionsRow.append(RegisterRowsData.init(1, "button", "Add New Family Member".localized(""), ""))
            }
            else {
                self.arrSectionsRow.append(RegisterRowsData.init(1, "button", "UPDATE".localized(""), ""))
            }
        }
        else {
            self.arrSectionsRow.append(RegisterRowsData.init(1, "button", "REGISTER".localized(""), ""))
        }
        
        
        
        self.tblView.reloadData()
    }
    
    func setUpValue() {
        self.dictDetail[SKDataKeys.membership_no.rawValue] = ""
        self.dictDetail[SKDataKeys.first_name.rawValue] = ""
        self.dictDetail[SKDataKeys.first_name_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.middle_name.rawValue] = ""
        self.dictDetail[SKDataKeys.middle_name_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.last_name.rawValue] = ""
        self.dictDetail[SKDataKeys.last_name_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.gender.rawValue] = ""
        self.dictDetail[SKDataKeys.email.rawValue] = ""
        self.dictDetail[SKDataKeys.country_code.rawValue] = ""
        self.dictDetail[SKDataKeys.mobile.rawValue] = ""
        self.dictDetail[SKDataKeys.telephone.rawValue] = ""
        self.dictDetail[SKDataKeys.relation.rawValue] = ""
        self.dictDetail[SKDataKeys.relation_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.marital_status.rawValue] = ""
        self.dictDetail[SKDataKeys.marital_status_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.pole_name.rawValue] = ""
        self.dictDetail[SKDataKeys.pole_name_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.saakh.rawValue] = ""
        self.dictDetail[SKDataKeys.saakh_name_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.address.rawValue] = ""
        self.dictDetail[SKDataKeys.address_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.area.rawValue] = ""
        self.dictDetail[SKDataKeys.area_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.city.rawValue] = ""
        self.dictDetail[SKDataKeys.city_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.country.rawValue] = ""
        self.dictDetail[SKDataKeys.country_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.pincode.rawValue] = ""
        self.dictDetail[SKDataKeys.birthdate.rawValue] = ""
        self.dictDetail[SKDataKeys.blood_group.rawValue] = ""
        self.dictDetail[SKDataKeys.eduction.rawValue] = ""
        self.dictDetail[SKDataKeys.eduction_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.profession_name.rawValue] = ""
        self.dictDetail[SKDataKeys.profession_name_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.business_type_name.rawValue] = ""
        self.dictDetail[SKDataKeys.business_type_name_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.company_name.rawValue] = ""
        self.dictDetail[SKDataKeys.company_name_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.company_address.rawValue] = ""
        self.dictDetail[SKDataKeys.company_address_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.company_phone.rawValue] = ""
        self.dictDetail[SKDataKeys.position.rawValue] = ""
        self.dictDetail[SKDataKeys.position_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.hobbies.rawValue] = ""
        self.dictDetail[SKDataKeys.hobbies_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.reference.rawValue] = ""
        self.dictDetail[SKDataKeys.previous_saakh.rawValue] = ""
        self.dictDetail[SKDataKeys.previous_saakh_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.other_business_type_name.rawValue] = ""
        self.dictDetail[SKDataKeys.other_business_type_name_gj.rawValue] = ""
        self.dictDetail[SKDataKeys.password.rawValue] = ""
        self.dictDetail[SKDataKeys.confirm_password.rawValue] = ""
    }
    
    func validateData() -> Bool {
        
        let strF_name = self.dictDetail[SKDataKeys.first_name.rawValue] as? String ?? ""
        let strF_name_gj = self.dictDetail[SKDataKeys.first_name_gj.rawValue] as? String ?? ""
        let strM_name = self.dictDetail[SKDataKeys.middle_name.rawValue] as? String ?? ""
        let strM_name_gj = self.dictDetail[SKDataKeys.middle_name_gj.rawValue] as? String ?? ""
        let strL_name = self.dictDetail[SKDataKeys.last_name.rawValue] as? String ?? ""
        let strL_name_gj = self.dictDetail[SKDataKeys.last_name_gj
            .rawValue] as? String ?? ""
        
        let strGender = self.dictDetail[SKDataKeys.gender.rawValue] as? String ?? ""
        let strEmail = self.dictDetail[SKDataKeys.email.rawValue] as? String ?? ""
        
        let strMobile = self.dictDetail[SKDataKeys.mobile.rawValue] as? String ?? ""
        
        let strRelation = self.dictDetail[SKDataKeys.relation.rawValue] as? String ?? ""
        let strRelation_gj = self.dictDetail[SKDataKeys.relation_gj.rawValue] as? String ?? ""
        
        let strPole = self.dictDetail[SKDataKeys.pole_name.rawValue] as? String ?? ""
        let strPole_gj = self.dictDetail[SKDataKeys.pole_name_gj.rawValue] as? String ?? ""
        
        let strShakh = self.dictDetail[SKDataKeys.saakh.rawValue] as? String ?? ""
        let strShakh_gj = self.dictDetail[SKDataKeys.saakh_name_gj.rawValue] as? String ?? ""
        
        let strArea = self.dictDetail[SKDataKeys.area.rawValue] as? String ?? ""
        let strArea_gj = self.dictDetail[SKDataKeys.area_gj.rawValue] as? String ?? ""
        
        let strCity = self.dictDetail[SKDataKeys.city.rawValue] as? String ?? ""
        let strCity_gj = self.dictDetail[SKDataKeys.city_gj.rawValue] as? String ?? ""
        
        let strCountry = self.dictDetail[SKDataKeys.country.rawValue] as? String ?? ""
        let strCountry_gj = self.dictDetail[SKDataKeys.country_gj.rawValue] as? String ?? ""
        let strBirthdate = self.dictDetail[SKDataKeys.birthdate.rawValue] as? String ?? ""
        let strPassword = self.dictDetail[SKDataKeys.password.rawValue] as? String ?? ""
        let strC_Password = self.dictDetail[SKDataKeys.confirm_password.rawValue] as? String ?? ""
        
        
        if strF_name.trim.count == 0 {
            showAlert(message: AlertMessages.enterF_Name.localized(""))
            return false
        }
        else if strF_name_gj.trim.count == 0 {
            showAlert(message: AlertMessages.enterF_Name.localized(""))
            return false
        }
        else if strM_name.trim.count == 0 {
            showAlert(message: AlertMessages.enterM_Name.localized(""))
            return false
        }
        else if strM_name_gj.trim.count == 0 {
            showAlert(message: AlertMessages.enterM_Name.localized(""))
            return false
        }
        else if strL_name.trim.count == 0 {
            showAlert(message: AlertMessages.enterL_Name.localized(""))
            return false
        }
        else if strL_name_gj.trim.count == 0 {
            showAlert(message: AlertMessages.enterL_Name.localized(""))
            return false
        }
        else if strGender.trim.count == 0 {
            showAlert(message: AlertMessages.enterGender.localized(""))
            return false
        }
        else if strEmail.trim.count == 0 {
            showAlert(message: AlertMessages.enterEmail.localized(""))
            return false
        }
        else if strMobile.trim.count == 0 {
            showAlert(message: AlertMessages.enterEmail.localized(""))
            return false
        }
        else if strRelation.trim.count == 0 {
            showAlert(message: AlertMessages.enterRelation.localized(""))
            return false
        }
        else if strRelation_gj.trim.count == 0 {
            showAlert(message: AlertMessages.enterRelation.localized(""))
            return false
        }
        else if strPole.trim.count == 0 {
            showAlert(message: AlertMessages.enterPole.localized(""))
            return false
        }
        else if strPole_gj.trim.count == 0 {
            showAlert(message: AlertMessages.enterPole.localized(""))
            return false
        }
        else if strShakh.trim.count == 0 {
            showAlert(message: AlertMessages.enterShakh.localized(""))
            return false
        }
        else if strShakh_gj.trim.count == 0 {
            showAlert(message: AlertMessages.enterShakh.localized(""))
            return false
        }
        else if strArea.trim.count == 0 {
            showAlert(message: AlertMessages.enterArea.localized(""))
            return false
        }
        else if strArea_gj.trim.count == 0 {
            showAlert(message: AlertMessages.enterArea.localized(""))
            return false
        }
        else if strCity.trim.count == 0 {
            showAlert(message: AlertMessages.enterCity.localized(""))
            return false
        }
        else if strCity_gj.trim.count == 0 {
            showAlert(message: AlertMessages.enterCity.localized(""))
            return false
        }
        
        else if strCountry.trim.count == 0 {
            showAlert(message: AlertMessages.enterCountry.localized(""))
            return false
        }
        else if strCountry_gj.trim.count == 0 {
            showAlert(message: AlertMessages.enterCountry.localized(""))
            return false
        }
        else if strBirthdate.trim.count == 0 {
            showAlert(message: AlertMessages.enterBirthDate.localized(""))
            return false
        }
        else if strPassword.trim.count == 0 {
            if self.isScreenFrom == "Edit_profile" {
                return true
            }
            else {
                showAlert(message: AlertMessages.enterPassword.localized(""))
                return false
            }
        }
        else if strPassword.isValidPassword() == false {
            if self.isScreenFrom == "Edit_profile" {
                return true
            }
            else {
                showAlert(message: AlertMessages.invalidPassword.localized(""))
                return false
            }
        }
        else if strC_Password.trim.count == 0 {
            if self.isScreenFrom == "Edit_profile" {
                return true
            }
            else {
                showAlert(message: AlertMessages.enterc_Password.localized(""))
                return false
            }
        }
        else if strC_Password.isValidPassword() == false {
            if self.isScreenFrom == "Edit_profile" {
                return true
            }
            else {
                showAlert(message: AlertMessages.invalidPassword.localized(""))
                return false
            }
        }
        else if strPassword != strC_Password {
            if self.isScreenFrom == "Edit_profile" {
                return true
            }
            else {
                showAlert(message: AlertMessages.passwordAndConfirmNotMatch.localized(""))
                return false
            }
        }
        return true
    }

    
    func CallAPIForGetPole(_ txtField: UITextField, gujarati: Bool) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        self.showProgressHUD()
        
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
                                    self.arr_PoleData = arrCat
                                }
                                
                                if gujarati {
                                    txtField.text = self.arr_PoleData[0].pole_name_gj
                                    self.dictDetail[SKDataKeys.pole_name.rawValue] = self.arr_PoleData[0].pole_name
                                    self.dictDetail[SKDataKeys.pole_id.rawValue] = self.arr_PoleData[0].pole_id
                                    self.dictDetail[SKDataKeys.pole_id_gj.rawValue] = self.arr_PoleData[0].pole_id
                                }
                                else {
                                    txtField.text = self.arr_PoleData[0].pole_name
                                    self.dictDetail[SKDataKeys.pole_name_gj.rawValue] = self.arr_PoleData[0].pole_name_gj
                                    self.dictDetail[SKDataKeys.pole_id_gj.rawValue] = self.arr_PoleData[0].pole_id
                                    self.dictDetail[SKDataKeys.pole_id.rawValue] = self.arr_PoleData[0].pole_id
                                }
                                
                                txtField.text = self.arr_PoleData[0].pole_name
                                txtField.inputView = self.pickerForGender
                                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                                txtField.becomeFirstResponder()
                                self.pickerForGender.reloadAllComponents()
                                
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
    
    func CallAPIForGetShakh(_ txtField: UITextField, gujarati: Bool , priviousSaaakh: Bool) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        self.showProgressHUD()
        
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
                                    self.arr_ShakhData = arrCat
                                }
                                if gujarati {
                                    txtField.text = self.arr_ShakhData[0].saakh_name_gj
                                    
                                    if priviousSaaakh {
                                        self.dictDetail[SKDataKeys.previous_saakh.rawValue] = self.arr_ShakhData[0].saakh_name
                                        self.dictDetail[SKDataKeys.previous_saakh_id.rawValue] = self.arr_ShakhData[0].saakh_id
                                        self.dictDetail[SKDataKeys.previous_saakh_id_gj.rawValue] = self.arr_ShakhData[0].saakh_id
                                    }
                                    else {
                                        self.dictDetail[SKDataKeys.saakh.rawValue] = self.arr_ShakhData[0].saakh_name
                                        self.dictDetail[SKDataKeys.saakh_id_gj.rawValue] = self.arr_ShakhData[0].saakh_id
                                        self.dictDetail[SKDataKeys.previous_saakh_id.rawValue] = self.arr_ShakhData[0].saakh_id
                                    }

                                }
                                else {
                                    txtField.text = self.arr_ShakhData[0].saakh_name
                                    
                                    if priviousSaaakh {
                                        self.dictDetail[SKDataKeys.previous_saakh_gj.rawValue] = self.arr_ShakhData[0].saakh_name_gj
                                       
                                        self.dictDetail[SKDataKeys.previous_saakh_id.rawValue] = self.arr_ShakhData[0].saakh_id
                                        self.dictDetail[SKDataKeys.previous_saakh_id_gj.rawValue] = self.arr_ShakhData[0].saakh_id
                                    }
                                    else {
                                        self.dictDetail[SKDataKeys.saakh_name_gj.rawValue] = self.arr_ShakhData[0].saakh_name
                                        self.dictDetail[SKDataKeys.saakh_id.rawValue] = self.arr_ShakhData[0].saakh_id
                                        self.dictDetail[SKDataKeys.saakh_id_gj.rawValue] = self.arr_ShakhData[0].saakh_id
                                    }
                                    
                                }

                                txtField.inputView = self.pickerForGender
                                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                                txtField.becomeFirstResponder()
                                self.pickerForGender.reloadAllComponents()
                                
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
    
    func CallAPIForGetCountryCode(_ txtFld: UITextField) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        self.showProgressHUD()
        
        ServiceCustom.shared.requestURLwithData(URL_GetCountryCode, Method: "POST", parameters: nil, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(CounryCodeData.self, from: data)
                                
                                if let arrCat = arrData.data {
                                    self.arr_CountryCodeListData = arrCat
                                }
                                let intCountryCode = self.arr_CountryCodeListData[0].country_code ?? 0
                                let strCountryCode = self.arr_CountryCodeListData[0].country_name ?? ""
                                let conyCode = "(\(intCountryCode)) \(strCountryCode)"

                                txtFld.text = conyCode
                                txtFld.inputView = self.pickerForGender
                                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                                txtFld.becomeFirstResponder()
                                self.pickerForGender.reloadAllComponents()

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
    
    func CallAPIForGetRelation(_ txtField: UITextField, gujarati: Bool) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        self.showProgressHUD()
        
        ServiceCustom.shared.requestURLwithData(URL_GetRelation, Method: "POST", parameters: nil, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(RelationData.self, from: data)
                                
                                if let arrCat = arrData.data {
                                    self.arr_RelationData = arrCat
                                }
                                
                                if gujarati {
                                    txtField.text = self.arr_RelationData[0].relation_guj
                                    self.dictDetail[SKDataKeys.relation.rawValue] = self.arr_RelationData[0].relation_english
                                }
                                else {
                                    txtField.text = self.arr_RelationData[0].relation_english
                                    self.dictDetail[SKDataKeys.relation_gj.rawValue] = self.arr_RelationData[0].relation_guj
                                }
                                txtField.inputView = self.pickerForGender
                                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                                txtField.becomeFirstResponder()
                                self.pickerForGender.reloadAllComponents()
                                
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
    
    func CallAPIForGetMarritalStatus(_ txtField: UITextField, gujarati: Bool) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        self.showProgressHUD()
        
        ServiceCustom.shared.requestURLwithData(URL_GetMaritalStatus, Method: "POST", parameters: nil, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(MaritalData.self, from: data)
                                
                                if let arrCat = arrData.data {
                                    self.arr_MeritalData = arrCat
                                }
                                if gujarati {
                                    txtField.text = self.arr_MeritalData[0].marital_status_guj
                                    self.dictDetail[SKDataKeys.marital_status.rawValue] = self.arr_MeritalData[0].marital_status_eng
                                }
                                else {
                                    txtField.text = self.arr_MeritalData[0].marital_status_eng
                                    self.dictDetail[SKDataKeys.marital_status_gj.rawValue] = self.arr_MeritalData[0].marital_status_guj
                                }
                                
                                
                                txtField.inputView = self.pickerForGender
                                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                                txtField.becomeFirstResponder()
                                self.pickerForGender.reloadAllComponents()
                                
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
    
    func CallAPIForGetCountry(_ txtField: UITextField, gujarati: Bool) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        self.showProgressHUD()
        
        ServiceCustom.shared.requestURLwithData(URL_GetCountry, Method: "POST", parameters: nil, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(CountryData.self, from: data)
                                
                                if let arrCat = arrData.data {
                                    self.arr_Country = arrCat
                                }
                                
                                if gujarati {
                                    txtField.text = self.arr_Country[0].country_name_gj
                                    self.dictDetail[SKDataKeys.country.rawValue] = self.arr_Country[0].country_name
                                    self.dictDetail[SKDataKeys.country_id_gj.rawValue] = self.arr_Country[0].country_id
                                }
                                else {
                                    txtField.text = self.arr_Country[0].country_name
                                    self.dictDetail[SKDataKeys.country_gj.rawValue] = self.arr_Country[0].country_name_gj
                                    self.dictDetail[SKDataKeys.country_id.rawValue] = self.arr_Country[0].country_id
                                }

                                txtField.inputView = self.pickerForGender
                                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                                txtField.becomeFirstResponder()
                                self.pickerForGender.reloadAllComponents()
                                
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
    
    func CallAPIForGetBusiness(_ txtField: UITextField, gujarati: Bool) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        self.showProgressHUD()
        
        ServiceCustom.shared.requestURLwithData(URL_GetBusiness, Method: "GET", parameters: nil, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(BusinessData.self, from: data)
                                
                                if let arrCat = arrData.data {
                                    self.arr_Business = arrCat
                                }
                                
                                if gujarati {
                                    txtField.text = self.arr_Business[0].business_name_gj
                                    self.dictDetail[SKDataKeys.business_type_name.rawValue] = self.arr_Business[0].business_name
                                    self.dictDetail[SKDataKeys.business_type_id_gj.rawValue] = self.arr_Business[0].business_id
                                }
                                else {
                                    txtField.text = self.arr_Business[0].business_name
                                    self.dictDetail[SKDataKeys.business_type_name_gj.rawValue] = self.arr_Business[0].business_name_gj
                                    self.dictDetail[SKDataKeys.business_type_id.rawValue] = self.arr_Business[0].business_id
                                }
                                
                                
                                txtField.inputView = self.pickerForGender
                                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                                txtField.becomeFirstResponder()
                                self.pickerForGender.reloadAllComponents()
                                
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
    
    func CallAPIForGetProfession(_ txtField: UITextField, gujarati: Bool) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        self.showProgressHUD()
        
        ServiceCustom.shared.requestURLwithData(URL_GetProfession, Method: "GET", parameters: nil, completion: { (request, response, jsonObj, dataa)  in
            
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
                                
                                if let arrCat = arrData.data {
                                    self.arr_Profession = arrCat
                                }
                                
                                if gujarati {
                                    txtField.text = self.arr_Profession[0].profession_name
                                    self.dictDetail[SKDataKeys.profession_name.rawValue] = self.arr_Profession[0].profession_name
                                    self.dictDetail[SKDataKeys.profession_id_gj.rawValue] = self.arr_Profession[0].profession_id
                                }
                                else {
                                    txtField.text = self.arr_Profession[0].profession_name
                                    self.dictDetail[SKDataKeys.profession_name_gj.rawValue] = self.arr_Profession[0].profession_name_gj
                                    self.dictDetail[SKDataKeys.profession_id.rawValue] = self.arr_Profession[0].profession_id
                                }
                                
                                txtField.inputView = self.pickerForGender
                                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                                txtField.becomeFirstResponder()
                                self.pickerForGender.reloadAllComponents()
                                
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
    
    func CallAPIForGetCity(_ txtField: UITextField, gujarati: Bool) {
        
        self.view.endEditing(true)
        
        ShowProgressHud(message: "please wait...".localized(""))
        self.showProgressHUD()
        
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
                                    self.arr_City = arrCat
                                }
                                
                                if gujarati {
                                    txtField.text = self.arr_City[0].city_name_gj
                                    self.dictDetail[SKDataKeys.city.rawValue] = self.arr_City[0].city_name
                                    self.dictDetail[SKDataKeys.city_id_gj.rawValue] = self.arr_City[0].city_id
                                }
                                else {
                                    txtField.text = self.arr_City[0].city_name
                                    self.dictDetail[SKDataKeys.city_gj.rawValue] = self.arr_City[0].city_name_gj
                                    self.dictDetail[SKDataKeys.city_id.rawValue] = self.arr_City[0].city_id
                                }
                                
                                txtField.inputView = self.pickerForGender
                                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                                txtField.becomeFirstResponder()
                                self.pickerForGender.reloadAllComponents()
                                
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
    
    
    //MARK: CAllAPI For GEt REFERENCE of The Family Name
    func CallAPIForGetReferenceofTheFamilyName(strValue: String, txtFild: UITextField) {
        
        if strValue == "" {
            return
        }
        
        let param = ["membership_no" : strValue]
        
        showProgressHUD()
        
        ServiceCustom.shared.requestURLwithData(URL_ValidateReference, Method: "POST", parameters: param, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                    }
                    else {
                        txtFild.text = ""
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
    
    
    
    //MARK: English To Hindi
    func CallAPIForGetEnglishToGujarati(_ txtField: UITextField, strValue: String) {

        let param = ["eng_name" : strValue]
        
        //showProgressHUD()
        
        ServiceCustom.shared.requestURLwithData(URL_GujTranslate, Method: "POST", parameters: param, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()

            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {

                        let strGJ = dictResult["data"] as? String ?? ""
                        txtField.text = strGJ

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
    
    
    // MARK: - PickerView Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.strSelection == SKDataKeys.gender.rawValue {
            return arr_Gender.count
        }
        else if self.strSelection == SKDataKeys.country_code.rawValue {
            return arr_CountryCodeListData.count
        }
        else if self.strSelection == SKDataKeys.relation.rawValue || self.strSelection == SKDataKeys.relation_gj.rawValue {
            return arr_RelationData.count
        }
        else if self.strSelection == SKDataKeys.marital_status.rawValue || self.strSelection == SKDataKeys.marital_status_gj.rawValue {
            return arr_MeritalData.count
        }
        else if self.strSelection == SKDataKeys.pole_name.rawValue || self.strSelection == SKDataKeys.pole_name_gj.rawValue {
            return arr_PoleData.count
        }
        else if self.strSelection == SKDataKeys.saakh.rawValue || self.strSelection == SKDataKeys.saakh_name_gj.rawValue || self.strSelection == SKDataKeys.previous_saakh.rawValue || self.strSelection == SKDataKeys.previous_saakh_gj.rawValue {
            return arr_ShakhData.count
        }
        else if self.strSelection == SKDataKeys.city.rawValue || self.strSelection == SKDataKeys.city_gj.rawValue {
            return arr_City.count
        }
        else if self.strSelection == SKDataKeys.country.rawValue || self.strSelection == SKDataKeys.country_gj.rawValue {
            return arr_Country.count
        }
        else if self.strSelection == SKDataKeys.profession_name.rawValue || self.strSelection == SKDataKeys.profession_name_gj.rawValue {
            return arr_Profession.count
        }
        else if self.strSelection == SKDataKeys.business_type_name.rawValue || self.strSelection == SKDataKeys.business_type_name_gj.rawValue {
            return arr_Business.count
        }
        else if self.strSelection == SKDataKeys.blood_group.rawValue {
            return arr_BloodGroup.count
        }
        else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if self.strSelection == SKDataKeys.gender.rawValue {
            let eng = arr_Gender[row].gender_english ?? ""
            let guj = arr_Gender[row].gender_guj ?? ""
            return "\(eng) (\(guj))"
        }
        else if self.strSelection == SKDataKeys.country_code.rawValue {
            let intCode = arr_CountryCodeListData[row].country_code ?? 0
            let strCode = arr_CountryCodeListData[row].country_name ?? ""
            return "(\(intCode)) \(strCode)"
        }
        else if self.strSelection == SKDataKeys.relation.rawValue {
            return arr_RelationData[row].relation_english as String?
        }
        else if self.strSelection == SKDataKeys.relation_gj.rawValue {
            return arr_RelationData[row].relation_guj as String?
        }
        else if self.strSelection == SKDataKeys.marital_status.rawValue {
            return arr_MeritalData[row].marital_status_eng as String?
        }
        else if self.strSelection == SKDataKeys.marital_status_gj.rawValue {
            return arr_MeritalData[row].marital_status_guj as String?
        }
        else if self.strSelection == SKDataKeys.pole_name.rawValue {
            return arr_PoleData[row].pole_name as String?
        }
        else if self.strSelection == SKDataKeys.pole_name_gj.rawValue {
            return arr_PoleData[row].pole_name_gj as String?
        }
        else if self.strSelection == SKDataKeys.saakh.rawValue {
            return arr_ShakhData[row].saakh_name as String?
        }
        else if self.strSelection == SKDataKeys.saakh_name_gj.rawValue {
            return arr_ShakhData[row].saakh_name_gj as String?
        }
        else if self.strSelection == SKDataKeys.previous_saakh.rawValue {
            return arr_ShakhData[row].saakh_name as String?
        }
        else if self.strSelection == SKDataKeys.previous_saakh_gj.rawValue {
            return arr_ShakhData[row].saakh_name_gj as String?
        }
        else if self.strSelection == SKDataKeys.city.rawValue {
            return arr_City[row].city_name as String?
        }
        else if self.strSelection == SKDataKeys.city_gj.rawValue {
            return arr_City[row].city_name_gj as String?
        }
        else if self.strSelection == SKDataKeys.country.rawValue {
            return arr_Country[row].country_name as String?
        }
        else if self.strSelection == SKDataKeys.country_gj.rawValue {
            return arr_Country[row].country_name_gj as String?
        }
        else if self.strSelection == SKDataKeys.profession_name.rawValue {
            return arr_Profession[row].profession_name as String?
        }
        else if self.strSelection == SKDataKeys.profession_name_gj.rawValue {
            return arr_Profession[row].profession_name_gj as String?
        }
        else if self.strSelection == SKDataKeys.business_type_name.rawValue {
            return arr_Business[row].business_name as String?
        }
        else if self.strSelection == SKDataKeys.business_type_name_gj.rawValue {
            return arr_Business[row].business_name_gj as String?
        }
        else if self.strSelection == SKDataKeys.blood_group.rawValue {
            return arr_BloodGroup[row].blood_group as String?
        }
        else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if self.strSelection == SKDataKeys.gender.rawValue {
            let eng = arr_Gender[row].gender_english ?? ""
            let guj = arr_Gender[row].gender_guj ?? ""
            let genderrr = "\(eng) (\(guj))"
            
            if let callBack = self.completionGenderSelectedCell {
                callBack(genderrr , true)
            }
        }
        else if self.strSelection == SKDataKeys.country_code.rawValue {
            let intCountryCode = arr_CountryCodeListData[row].country_code ?? 0
            let strCountryCode = arr_CountryCodeListData[row].country_name ?? ""
            let conyCode = "(\(intCountryCode)) \(strCountryCode)"
            
            if let callBack = self.completionCountryCodeSelectedCell {
                callBack(conyCode , true)
            }
        }
        else if self.strSelection == SKDataKeys.relation.rawValue {
            let strEng = arr_RelationData[row].relation_english ?? ""
            let strGJ = arr_RelationData[row].relation_guj ?? ""
            
            if let callBack = self.completionRelationSelectedCell {
                callBack(strEng, strGJ, true)
            }
        }
        else if self.strSelection == SKDataKeys.relation_gj.rawValue {
            let strEng = arr_RelationData[row].relation_english ?? ""
            let strGJ = arr_RelationData[row].relation_guj ?? ""
            
            if let callBack = self.completionRelationGJSelectedCell {
                callBack(strEng, strGJ, true)
            }
        }
        else if self.strSelection == SKDataKeys.marital_status.rawValue {
            let strEng = arr_MeritalData[row].marital_status_eng ?? ""
            let strGJ = arr_MeritalData[row].marital_status_guj ?? ""
            
            if let callBack = self.completionMaritalStatusSelectedCell {
                callBack(strEng, strGJ, true)
            }
        }
        else if self.strSelection == SKDataKeys.marital_status_gj.rawValue {
            let strEng = arr_MeritalData[row].marital_status_eng ?? ""
            let strGJ = arr_MeritalData[row].marital_status_guj ?? ""
            
            if let callBack = self.completionMaritalStatusGJSelectedCell {
                callBack(strEng, strGJ, true)
            }
        }
        else if self.strSelection == SKDataKeys.pole_name.rawValue {
            let poleID = arr_PoleData[row].pole_id ?? ""
            let strEng = arr_PoleData[row].pole_name ?? ""
            let strGJ = arr_PoleData[row].pole_name_gj ?? ""
            
            if let callBack = self.completionPoleSelectedCell {
                callBack(strEng, strGJ, poleID, true)
            }
        }
        else if self.strSelection == SKDataKeys.pole_name_gj.rawValue {
            let poleID = arr_PoleData[row].pole_id ?? ""
            let strEng = arr_PoleData[row].pole_name ?? ""
            let strGJ = arr_PoleData[row].pole_name_gj ?? ""
            
            if let callBack = self.completionPoleGJSelectedCell {
                callBack(strEng, strGJ, poleID, true)
            }
        }
        else if self.strSelection == SKDataKeys.saakh.rawValue {
            let sakhID = arr_ShakhData[row].saakh_id ?? ""
            let strEng = arr_ShakhData[row].saakh_name ?? ""
            let strGJ = arr_ShakhData[row].saakh_name_gj ?? ""
            
            if let callBack = self.completionShakhSelectedCell {
                callBack(strEng, strGJ, sakhID, true)
            }
        }
        else if self.strSelection == SKDataKeys.saakh_name_gj.rawValue {
            let sakhID = arr_ShakhData[row].saakh_id ?? ""
            let strEng = arr_ShakhData[row].saakh_name ?? ""
            let strGJ = arr_ShakhData[row].saakh_name_gj ?? ""
            
            if let callBack = self.completionShakhGJSelectedCell {
                callBack(strEng, strGJ, sakhID, true)
            }
        }
        else if self.strSelection == SKDataKeys.previous_saakh.rawValue {
            let sakhID = arr_ShakhData[row].saakh_id ?? ""
            let strEng = arr_ShakhData[row].saakh_name ?? ""
            let strGJ = arr_ShakhData[row].saakh_name_gj ?? ""
            
            if let callBack = self.completionPriviousShakhSelectedCell {
                callBack(strEng, strGJ, sakhID, true)
            }
        }
        else if self.strSelection == SKDataKeys.previous_saakh_gj.rawValue {
            let sakhID = arr_ShakhData[row].saakh_id ?? ""
            let strEng = arr_ShakhData[row].saakh_name ?? ""
            let strGJ = arr_ShakhData[row].saakh_name_gj ?? ""
            
            if let callBack = self.completionPriviousShakhGJSelectedCell {
                callBack(strEng, strGJ, sakhID, true)
            }
        }
        else if self.strSelection == SKDataKeys.city.rawValue {
            let cityID = arr_City[row].city_id ?? ""
            let strEng = arr_City[row].city_name ?? ""
            let strGJ = arr_City[row].city_name_gj ?? ""
            
            if let callBack = self.completionCitySelectedCell {
                callBack(strEng, strGJ, cityID, true)
            }
        }
        else if self.strSelection == SKDataKeys.city_gj.rawValue {
            let cityID = arr_City[row].city_id ?? ""
            let strEng = arr_City[row].city_name ?? ""
            let strGJ = arr_City[row].city_name_gj ?? ""
            
            if let callBack = self.completionCityGJSelectedCell {
                callBack(strEng, strGJ, cityID, true)
            }
        }
        else if self.strSelection == SKDataKeys.country.rawValue {
            let contID = arr_Country[row].country_id ?? ""
            let strEng = arr_Country[row].country_name ?? ""
            let strGJ = arr_Country[row].country_name_gj ?? ""
            
            if let callBack = self.completionCountrySelectedCell {
                callBack(strEng, strGJ, contID, true)
            }
        }
        else if self.strSelection == SKDataKeys.country_gj.rawValue {
            let contID = arr_Country[row].country_id ?? ""
            let strEng = arr_Country[row].country_name ?? ""
            let strGJ = arr_Country[row].country_name_gj ?? ""
            
            if let callBack = self.completionCountryGJSelectedCell {
                callBack(strEng, strGJ, contID, true)
            }
        }
        else if self.strSelection == SKDataKeys.profession_name.rawValue {
            let profesinID = arr_Profession[row].profession_id ?? ""
            let strEng = arr_Profession[row].profession_name ?? ""
            let strGJ = arr_Profession[row].profession_name_gj ?? ""
            
            if let callBack = self.completionProfessionSelectedCell {
                callBack(strEng, strGJ, profesinID, true)
            }
        }
        else if self.strSelection == SKDataKeys.profession_name_gj.rawValue {
            let profesinID = arr_Profession[row].profession_id ?? ""
            let strEng = arr_Profession[row].profession_name ?? ""
            let strGJ = arr_Profession[row].profession_name_gj ?? ""
            
            if let callBack = self.completionProfessionGJSelectedCell {
                callBack(strEng, strGJ, profesinID, true)
            }
        }
        else if self.strSelection == SKDataKeys.business_type_name.rawValue {
            let businesID = arr_Business[row].business_id ?? ""
            let strEng = arr_Business[row].business_name ?? ""
            let strGJ = arr_Business[row].business_name_gj ?? ""
            
            if let callBack = self.completionBusinessSelectedCell {
                callBack(strEng, strGJ, businesID, true)
            }
        }
        else if self.strSelection == SKDataKeys.business_type_name_gj.rawValue {
            let businesID = arr_Business[row].business_id ?? ""
            let strEng = arr_Business[row].business_name ?? ""
            let strGJ = arr_Business[row].business_name_gj ?? ""
            
            if let callBack = self.completionBusinessGJSelectedCell {
                callBack(strEng, strGJ, businesID, true)
            }
        }
        else if self.strSelection == SKDataKeys.blood_group.rawValue {
            
            let strEng = arr_BloodGroup[row].blood_group ?? ""
            
            if let callBack = self.completionBloodGroupSelectedCell {
                callBack(strEng, true)
            }
        }
    }
    
    
    // MARK:- IBActions
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSubmitTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if validateData() == false {
            return
        }

        var dicParamsforAPI: Dictionary<String,String> = [:]
        dicParamsforAPI = self.dictDetail as? [String : String] ?? [:]
        dicParamsforAPI.removeValue(forKey: SKDataKeys.profile_picture.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.pole_name.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.pole_name_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.pole_id.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.pole_id_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.saakh_id.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.saakh.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.saakh_id_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.previous_saakh.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.previous_saakh_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.previous_saakh_id.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.previous_saakh_id_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.saakh_name_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.city.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.city_id.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.city_id_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.city_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.country.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.country_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.country_id.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.country_id_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.profession_id.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.profession_id_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.profession_name.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.profession_name_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.business_type_id.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.business_type_id_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.business_type_name.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.business_type_name_gj.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.other_business_type_name.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.other_business_type_name_gj.rawValue)
        
        
        //Get Country Code
        let countryCode = self.dictDetail[SKDataKeys.country_code.rawValue] as? String ?? ""
        if countryCode != "" {
            if countryCode.contains(" ") && countryCode.contains("(") && countryCode.contains(")") {
                let arrcode = countryCode.components(separatedBy: ")")
                let arrFst = arrcode.first?.components(separatedBy: "(")
                let country_Code = arrFst?.last ?? ""
                dicParamsforAPI[SKDataKeys.country_code.rawValue] = country_Code
            }
        }
        
        //Get Male
        let strMaleFemale = self.dictDetail[SKDataKeys.gender.rawValue] as? String ?? ""
        if strMaleFemale != "" {
            if strMaleFemale.contains(" ") {
                let arrMaleFemale = strMaleFemale.components(separatedBy: " ")
                let str_Male = arrMaleFemale.first ?? ""
                dicParamsforAPI[SKDataKeys.gender.rawValue] = str_Male.lowercased()
            }
        }
        
        
        //Pole
        let poleID = self.dictDetail[SKDataKeys.pole_id.rawValue] as? String ?? ""
        dicParamsforAPI["pole"] = poleID
        dicParamsforAPI["pole_gj"] = poleID
        
        //Sakh
        let sakhID = self.dictDetail[SKDataKeys.saakh_id.rawValue] as? String ?? ""
        dicParamsforAPI[SKDataKeys.saakh.rawValue] = sakhID
        dicParamsforAPI["saakh_gj"] = sakhID
        
        //previous saakh
        let Prv_sakhID = self.dictDetail[SKDataKeys.previous_saakh_id.rawValue] as? String ?? ""
        dicParamsforAPI["previous_saakh"] = Prv_sakhID
        dicParamsforAPI["previous_saakh_gj"] = Prv_sakhID
        
        //City
        let cityID = self.dictDetail[SKDataKeys.city_id.rawValue] as? String ?? ""
        dicParamsforAPI[SKDataKeys.city.rawValue] = cityID
        dicParamsforAPI[SKDataKeys.city_gj.rawValue] = cityID
        
        
        //Country
        let counID = self.dictDetail[SKDataKeys.country_id.rawValue] as? String ?? ""
        dicParamsforAPI[SKDataKeys.country.rawValue] = counID
        dicParamsforAPI[SKDataKeys.country_gj.rawValue] = counID
        
        //Profession
        let professionID = self.dictDetail[SKDataKeys.profession_id.rawValue] as? String ?? ""
        dicParamsforAPI["profession"] = professionID
        dicParamsforAPI["profession_gj"] = professionID
        
        
        //Business
        let businID = self.dictDetail[SKDataKeys.business_type_id.rawValue] as? String ?? ""
        dicParamsforAPI["business_type"] = businID
        dicParamsforAPI["business_type_gj"] = businID
        
        //Other Business English
        let business_eng = self.dictDetail[SKDataKeys.other_business_type_name.rawValue] as? String ?? ""
        dicParamsforAPI["other_business_type"] = business_eng
        
        //Other Business GJ
        //Business
        let business_gj = self.dictDetail[SKDataKeys.other_business_type_name_gj.rawValue] as? String ?? ""
        dicParamsforAPI["other_business_type_gj"] = business_gj
        
        
        //For Edit Profile
        if self.isScreenFrom == "Edit_profile" {
            
            dicParamsforAPI.removeValue(forKey: SKDataKeys.password.rawValue)
            dicParamsforAPI.removeValue(forKey: SKDataKeys.membership_no.rawValue)
            dicParamsforAPI.removeValue(forKey: SKDataKeys.confirm_password.rawValue)
            
            if self.isEditFamilyProfile {

                if self.correctScreenFrom == "EditFamily_Profile" {
                    //Edit Member
                    dicParamsforAPI[SKDataKeys.family_member_id.rawValue] = self.familyMemberID
                }
                else {
                    //Add New Member
                    dicParamsforAPI[SKDataKeys.family_member_id.rawValue] = ""//blank
                }

                dicParamsforAPI[SKDataKeys.membership_no.rawValue] = strGetUserName_Email(SKDataKeys.membership_no.rawValue)
                dicParamsforAPI[SKDataKeys.user_id.rawValue] = strGetUserID()
            }
            else {
                dicParamsforAPI[SKDataKeys.user_id.rawValue] = strGetUserID()
            }

            debugPrint("API Call", dicParamsforAPI)
            
            //API Calling for Update User
            if self.is_ChangePhoto {
                self.CallAPIForUpdateProfilewithProfilePicture(false, dicParamsforAPI)
            }
            else {
                self.CallAPIForUpdateProfile(false, dicParamsforAPI)
            }
        }
        else {
            debugPrint("API Call", dicParamsforAPI)
            
            //API Calling for Register User
            if self.is_ChangePhoto {
                self.CallAPIForUpdateProfilewithProfilePicture(true, dicParamsforAPI)
            }
            else {
                self.CallAPIForUpdateProfile(true, dicParamsforAPI)
            }
        }

        //******************//

    }
    
    //MARK: Update Profile
    func CallAPIForUpdateProfile(_ is_SignupAPI: Bool, _ dicPARAMS: Dictionary<String,String> = [:]) {

        ShowProgressHud(message: "please wait...".localized(""))
        
        var APINAme = is_SignupAPI ? URL_SignupUser : URL_UpdateProfile
        
        if is_SignupAPI == false {
            if self.isEditFamilyProfile {
                APINAme = URL_AddFamilyMember
            }
        }

        print(APINAme, dicPARAMS)
        
        ServiceCustom.shared.requestURLwithBlankHeaderData(APINAme, Method: "POST", parameters: dicPARAMS, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let dicUserData = dictResult["data"] as? NSDictionary {

                            if is_SignupAPI == false {
                                if self.isEditFamilyProfile == false {
                                    _userDefault.set(true, forKey: "is_login")
                                    _userDefault.set(NSKeyedArchiver.archivedData(withRootObject: dicUserData), forKey: "AllUserData")
                                    UserDefaults.standard.synchronize()
                                }
                            }
                            
                            //For User Sign UP
                            if is_SignupAPI {
                                NotificationCenter.default.post(name: Notification.Name("UPDATEPSIDEMENU"), object: nil)
                                
                                //Go To Home Screen
                                let objMain = self.storyboard?.instantiateViewController(withIdentifier: "MainScreenVC") as! MainScreenVC
                                objMain.title = "Home".localized("")
                                self.navigationController?.pushViewController(objMain, animated: true)
                            }
                            else {
                                // Create the alert controller
                                let alertController = UIAlertController(title: "SVPS Vadnagara".localized(""), message: str_Msg, preferredStyle: .alert)
                                
                                // Create the actions
                                let okAction = UIAlertAction(title: "Ok".localized(""), style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                    NSLog("OK Pressed")
                                    
                                    if self.isEditFamilyProfile {
                                        for controller in self.navigationController!.viewControllers {
                                            if controller.isKind(of: MyFamilyVC.self) {
                                                NotificationCenter.default.post(name: Notification.Name("UPDATEPFAMILYLIST"), object: nil)
                                                _ =  self.navigationController!.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    }
                                    else {
                                        NotificationCenter.default.post(name: Notification.Name("UPDATEPROFLIE"), object: nil)
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                }
                                // Add the actions
                                alertController.addAction(okAction)
                                // Present the controller
                                self.present(alertController, animated: true, completion: nil)
                                //****************************//
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
    
    
    
    //MARK: Update Profile with Profile picture
    func CallAPIForUpdateProfilewithProfilePicture(_ is_SignupAPI: Bool, _ dicPARAMS: Dictionary<String,String> = [:]) {
        
        ShowProgressHud(message: "please wait...".localized(""))
        
        var APINAme = is_SignupAPI ? URL_SignupUser : URL_UpdateProfile
        
        if is_SignupAPI == false {
            if self.isEditFamilyProfile {
                APINAme = URL_AddFamilyMember
            }
        }
        
        print(APINAme, dicPARAMS)
        
        guard let imageData = self.SelectPhoto.jpegData(compressionQuality: 0.75) else { return }

        ServiceCustom.shared.requestMultiPartWithUrlAndParameters(APINAme, Method: "POST", parameters: dicPARAMS, fileParameterName: "profile_picture", fileName: "image.jpeg", fileData: imageData, mimeType: "image/jpeg", completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let dicUserData = dictResult["data"] as? NSDictionary {
                            
                            if self.isEditFamilyProfile == false {
                                _userDefault.set(NSKeyedArchiver.archivedData(withRootObject: dicUserData), forKey: "AllUserData")
                                UserDefaults.standard.synchronize()
                            }
                            
                            //For User Sign UP
                            if is_SignupAPI {
                                NotificationCenter.default.post(name: Notification.Name("UPDATEPSIDEMENU"), object: nil)
                                
                                //Go To Home Screen
                                let objMain = self.storyboard?.instantiateViewController(withIdentifier: "MainScreenVC") as! MainScreenVC
                                objMain.title = "Home".localized("")
                                self.navigationController?.pushViewController(objMain, animated: true)
                            }
                            else {
                                // Create the alert controller
                                let alertController = UIAlertController(title: "SVPS Vadnagara".localized(""), message: str_Msg, preferredStyle: .alert)
                                
                                // Create the actions
                                let okAction = UIAlertAction(title: "Ok".localized(""), style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                    NSLog("OK Pressed")
                                    
                                    if self.isEditFamilyProfile {
                                        for controller in self.navigationController!.viewControllers {
                                            if controller.isKind(of: MyFamilyVC.self) {
                                                NotificationCenter.default.post(name: Notification.Name("UPDATEPFAMILYLIST"), object: nil)
                                                _ =  self.navigationController!.popToViewController(controller, animated: true)
                                                break
                                            }
                                        }
                                    }
                                    else {
                                        NotificationCenter.default.post(name: Notification.Name("UPDATEPROFLIE"), object: nil)
                                       
                                        NotificationCenter.default.post(name: Notification.Name("UPDATEPSIDEMENU"), object: nil)
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    
                                }
                                // Add the actions
                                alertController.addAction(okAction)
                                // Present the controller
                                self.present(alertController, animated: true, completion: nil)
                                //****************************//
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK:- IBActions Upload Image
    @objc func fun_PickProfile(sender:UIButton) {
        self.view.endEditing(true)
        self.openImagePicker()
    }
    
    func openImagePicker() {

        let imageAlert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction.init(title: "Cancel".localized(""), style: .cancel, handler: { (action) in
            
            imageAlert.dismiss(animated: true, completion: nil)
        })
        
        let Capture = UIAlertAction.init(title: "Take Photo".localized(""), style: .destructive, handler: { (action) in
            
            self.imagePicker.sourceType = .camera
            self.imagePicker.cameraDevice = .front
            self.imagePicker.showsCameraControls = true
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        let chosefromlib = UIAlertAction.init(title: "Choose Photo".localized(""), style: .default, handler: { (action) in
            
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        imageAlert.addAction(Capture)
        imageAlert.addAction(chosefromlib)
        imageAlert.addAction(cancel)
        self.present(imageAlert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            if let PickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                self.is_ChangePhoto = true
                self.SelectPhoto = PickedImage
                self.tblView.reloadData()
            }
            
        }
    }
    
    
    
}


// MARK: UICOllection Veiew Delegate and Datasource Method
extension RegisterVC: UITableViewDelegate, UITableViewDataSource {
    
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
        
        if strKey == "ProfileImage" {
            let cell: RegisterImageTableCell = tableView.dequeueReusableCell(withIdentifier: "RegisterImageTableCell", for: indexPath) as! RegisterImageTableCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            cell.viewImgBG.layer.cornerRadius = cell.viewImgBG.frame.height/2
            cell.img_Profile.layer.cornerRadius = cell.img_Profile.frame.height/2
            
            if is_ChangePhoto {
                cell.img_Profile.image = self.SelectPhoto
            }
            else {
                let strProfile = self.dictDetail[SKDataKeys.profile_picture.rawValue] as? String ?? ""
                if strProfile != "" {
                    cell.img_Profile.af_setImage(withURL: URL(string: strProfile)!)
                }
                else {
                    cell.img_Profile.image = #imageLiteral(resourceName: "user")
                }
            }
            
            
            cell.btnUploadImage.tag = indexPath.row
            cell.btnUploadImage.addTarget(self, action: #selector(fun_PickProfile(sender:)), for: UIControl.Event.touchUpInside)
            
            return cell
        }
        else if strKey == "button" {
            let cell: ButtonTableCell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableCell", for: indexPath) as! ButtonTableCell
            cell.selectionStyle = .none
            //cell.backgroundColor = UIColor.clear
            
            
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
            cell.txt_field.isSecureTextEntry = false
            cell.txt_field.text = self.dictDetail[strKey] as? String ?? ""
            cell.txt_field.accessibilityHint = strKey
            cell.txt_field.accessibilityIdentifier = strKey
            
            if strKey == SKDataKeys.email.rawValue {
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .emailAddress
            }
            else if strKey == SKDataKeys.mobile.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.telephone.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.pincode.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.gender.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.inputView = pickerForGender
                pickerForGender.selectRow(0, inComponent: 0, animated: true)
                pickerForGender.reloadAllComponents()
                
                self.completionGenderSelectedCell = {(value, success) in
                    self.dictDetail[strKey] = value
                    cell.txt_field.text = value
                }
            }
            else if strKey == SKDataKeys.country_code.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.inputView = pickerForGender
                pickerForGender.selectRow(0, inComponent: 0, animated: true)
                pickerForGender.reloadAllComponents()
                
                self.completionCountryCodeSelectedCell = {(value, success) in
                    self.dictDetail[strKey] = value
                    cell.txt_field.text = value
                }
            }
            else if strKey == SKDataKeys.relation.rawValue {
                self.completionRelationSelectedCell = {(value, valueGJ, success) in
                    self.dictDetail[strKey] = value
                    self.dictDetail[SKDataKeys.relation_gj.rawValue] = valueGJ
                    cell.txt_field.text = value
                    self.PriviousShakh = value == "Self-Female" ? true : false
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                        self.setUpforSectionsData()
                    })
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.relation_gj.rawValue {
                self.completionRelationGJSelectedCell = {(value, valueGJ, success) in
                    self.dictDetail[strKey] = valueGJ
                    self.dictDetail[SKDataKeys.relation.rawValue] = value
                    cell.txt_field.text = valueGJ
                    self.PriviousShakh = valueGJ == "પોતે-સ્ત્રી" ? true : false
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                        self.setUpforSectionsData()
                    })
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.marital_status.rawValue {
                self.completionMaritalStatusSelectedCell = {(value, valueGJ, success) in
                    self.dictDetail[strKey] = value
                    self.dictDetail[SKDataKeys.marital_status_gj.rawValue] = valueGJ
                    cell.txt_field.text = value
                    self.setUpforSectionsData()
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.marital_status_gj.rawValue {
                self.completionMaritalStatusGJSelectedCell = {(value, valueGJ, success) in
                    self.dictDetail[strKey] = valueGJ
                    self.dictDetail[SKDataKeys.marital_status.rawValue] = value
                    cell.txt_field.text = valueGJ
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.pole_name.rawValue {
                self.completionPoleSelectedCell = {(value, valueGJ, poleiD, success) in
                    self.dictDetail[strKey] = value
                    self.dictDetail[SKDataKeys.pole_name_gj.rawValue] = valueGJ
                    self.dictDetail[SKDataKeys.pole_id.rawValue] = poleiD
                    self.dictDetail[SKDataKeys.pole_id_gj.rawValue] = poleiD
                    cell.txt_field.text = value
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.pole_name_gj.rawValue {
                self.completionPoleGJSelectedCell = {(value, valueGJ, poleiD, success) in
                    self.dictDetail[strKey] = valueGJ
                    self.dictDetail[SKDataKeys.pole_name.rawValue] = value
                    self.dictDetail[SKDataKeys.pole_id.rawValue] = poleiD
                    self.dictDetail[SKDataKeys.pole_id_gj.rawValue] = poleiD
                    cell.txt_field.text = valueGJ
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.saakh.rawValue {
                self.completionShakhSelectedCell = {(value, valueGJ, sakhID, success) in
                    self.dictDetail[strKey] = value
                    self.dictDetail[SKDataKeys.saakh_name_gj.rawValue] = valueGJ
                    
                    self.dictDetail[SKDataKeys.saakh_id.rawValue] = sakhID
                    self.dictDetail[SKDataKeys.saakh_id_gj.rawValue] = sakhID
                    cell.txt_field.text = value
                    
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.saakh_name_gj.rawValue {
                self.completionShakhGJSelectedCell = {(value, valueGJ, sakhID, success) in
                    self.dictDetail[strKey] = valueGJ
                    self.dictDetail[SKDataKeys.saakh.rawValue] = value
                    self.dictDetail[SKDataKeys.saakh_id.rawValue] = sakhID
                    self.dictDetail[SKDataKeys.saakh_id_gj.rawValue] = sakhID
                    cell.txt_field.text = valueGJ
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.previous_saakh.rawValue {
                self.completionPriviousShakhSelectedCell = {(value, valueGJ, sakhID, success) in
                    self.dictDetail[strKey] = value
                    self.dictDetail[SKDataKeys.previous_saakh_gj.rawValue] = valueGJ
                    self.dictDetail[SKDataKeys.previous_saakh_id.rawValue] = sakhID
                    self.dictDetail[SKDataKeys.previous_saakh_id_gj.rawValue] = sakhID
                    cell.txt_field.text = value
                    
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.previous_saakh_gj.rawValue {
                self.completionShakhGJSelectedCell = {(value, valueGJ, sakhID, success) in
                    self.dictDetail[strKey] = valueGJ
                    self.dictDetail[SKDataKeys.previous_saakh.rawValue] = value
                    self.dictDetail[SKDataKeys.previous_saakh_id.rawValue] = sakhID
                    self.dictDetail[SKDataKeys.previous_saakh_id_gj.rawValue] = sakhID
                    cell.txt_field.text = valueGJ
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.city.rawValue {
                self.completionCitySelectedCell = {(value, valueGJ, cityID, success) in
                    self.dictDetail[strKey] = value
                    self.dictDetail[SKDataKeys.city_gj.rawValue] = valueGJ
                    self.dictDetail[SKDataKeys.city_id.rawValue] = cityID
                    self.dictDetail[SKDataKeys.city_id_gj.rawValue] = cityID
                    cell.txt_field.text = value
                   // self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.city_gj.rawValue {
                self.completionCityGJSelectedCell = {(value, valueGJ, cityID, success) in
                    self.dictDetail[strKey] = valueGJ
                    self.dictDetail[SKDataKeys.city.rawValue] = value
                    self.dictDetail[SKDataKeys.city_id.rawValue] = cityID
                    self.dictDetail[SKDataKeys.city_id_gj.rawValue] = cityID
                    cell.txt_field.text = valueGJ
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.country.rawValue {
                self.completionCountrySelectedCell = {(value, valueGJ, counID, success) in
                    self.dictDetail[strKey] = value
                    self.dictDetail[SKDataKeys.country_gj.rawValue] = valueGJ
                    self.dictDetail[SKDataKeys.country_id.rawValue] = counID
                    self.dictDetail[SKDataKeys.country_id_gj.rawValue] = counID
                    cell.txt_field.text = value
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.country_gj.rawValue {
                self.completionCountryGJSelectedCell = {(value, valueGJ, counID, success) in
                    self.dictDetail[strKey] = valueGJ
                    self.dictDetail[SKDataKeys.country.rawValue] = value
                    self.dictDetail[SKDataKeys.country_id.rawValue] = counID
                    self.dictDetail[SKDataKeys.country_id_gj.rawValue] = counID
                    cell.txt_field.text = valueGJ
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.profession_name.rawValue {
                self.completionProfessionSelectedCell = {(value, valueGJ, profenID, success) in
                    self.dictDetail[strKey] = value
                    self.dictDetail[SKDataKeys.profession_name_gj.rawValue] = valueGJ
                    self.dictDetail[SKDataKeys.profession_id.rawValue] = profenID
                    self.dictDetail[SKDataKeys.profession_id_gj.rawValue] = profenID
                    cell.txt_field.text = value
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.profession_name_gj.rawValue {
                self.completionProfessionGJSelectedCell = {(value, valueGJ, profenID, success) in
                    self.dictDetail[strKey] = valueGJ
                    self.dictDetail[SKDataKeys.profession_name.rawValue] = value
                    self.dictDetail[SKDataKeys.profession_id.rawValue] = profenID
                    self.dictDetail[SKDataKeys.profession_id_gj.rawValue] = profenID
                    cell.txt_field.text = valueGJ
                    //self.tblView.reloadData()
                }
            }
                
            else if strKey == SKDataKeys.business_type_name.rawValue {
                self.completionBusinessSelectedCell = {(value, valueGJ, businID, success) in
                    self.dictDetail[strKey] = value
                    self.dictDetail[SKDataKeys.business_type_name_gj.rawValue] = valueGJ
                    self.dictDetail[SKDataKeys.business_type_id.rawValue] = businID
                    self.dictDetail[SKDataKeys.business_type_id_gj.rawValue] = businID
                    cell.txt_field.text = value
                    self.otherIndustry = value == "Other" ? true : false
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                        self.setUpforSectionsData()
                    })
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.business_type_name_gj.rawValue {
                self.completionBusinessGJSelectedCell = {(value, valueGJ, businID, success) in
                    self.dictDetail[strKey] = valueGJ
                    self.dictDetail[SKDataKeys.business_type_name.rawValue] = value
                    self.dictDetail[SKDataKeys.business_type_id.rawValue] = businID
                    self.dictDetail[SKDataKeys.business_type_id_gj.rawValue] = businID
                    cell.txt_field.text = valueGJ
                    self.otherIndustry = value == "Other" ? true : false
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
                        self.setUpforSectionsData()
                    })
                    //self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.blood_group.rawValue {
                self.completionBloodGroupSelectedCell = {(value, success) in
                    self.dictDetail[strKey] = value
                    cell.txt_field.text = value
                }
            }
            else if strKey == SKDataKeys.birthdate.rawValue {
                self.birthdatePicker.datePickerMode = .date
                self.birthdatePicker.maximumDate = Date()
                self.birthdatePicker.addTarget(self, action: #selector(datePickerDidSetectDate(_:)), for: UIControl.Event.valueChanged)
                self.didSelectedDate = {(sender) in
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "dd/MM/yyyy"
                    cell.txt_field.text = dateFormater.string(from: sender.date)
                }
                cell.txt_field.addDoneToolbar()
                cell.txt_field.inputView = self.birthdatePicker
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.rightViewMode = .always
                
                /*let button = UIButton()
                 button.frame = CGRect.init(x: 0, y: 0, width: cell.txt_field.bounds.height, height: cell.txt_field.bounds.height)
                 button.contentMode = .scaleAspectFit
                 button.isUserInteractionEnabled = false
                 button.setImage(#imageLiteral(resourceName: "ic_down"), for: .normal)
                 cell.txt_field.rightView = button*/
            }
            else if strKey == SKDataKeys.company_phone.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.company_phone.rawValue {
                cell.txt_field.isSecureTextEntry = true
            }
            else if strKey == SKDataKeys.company_phone.rawValue {
                cell.txt_field.isSecureTextEntry = true
            }
            else {
                cell.txt_field.autocapitalizationType = .words
                cell.txt_field.keyboardType = .default
            }
            
            
            return cell
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

//MARK:- textfield Delegate & Actions

extension RegisterVC: UITextFieldDelegate {
    
    @IBAction func datePickerDidSetectDate(_ sender: UIDatePicker) {
        if self.didSelectedDate != nil {
            self.didSelectedDate!(sender)
        }
    }
    
    @IBAction func DataPickerDidSetectDate(_ sender: UIDatePicker) {
        debugPrint(sender.tag)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let strID = textField.accessibilityHint {
            textField.inputView = nil
            textField.isSecureTextEntry = false
            
            if strID == SKDataKeys.first_name_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.first_name.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.middle_name_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.middle_name.rawValue] as? String ?? ""
                if strnme != "" {
                     self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.last_name_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.last_name.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.relation_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.relation_gj.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_RelationData.count != 0 {
                        self.strSelection = strID
                        textField.text = self.arr_RelationData[0].relation_guj
                        self.dictDetail[SKDataKeys.relation.rawValue] = self.arr_RelationData[0].relation_english
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetRelation(textField, gujarati: true)
                    }
                }
                else {
                    if self.arr_RelationData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_RelationData[0].relation_guj
                        self.dictDetail[SKDataKeys.relation.rawValue] = self.arr_RelationData[0].relation_english
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetRelation(textField, gujarati: true)
                    }
                }
            }
            else if strID == SKDataKeys.birthdate.rawValue {
                self.birthdatePicker.datePickerMode = .date
                self.birthdatePicker.maximumDate = Date()
                
                self.birthdatePicker.addTarget(self, action: #selector(datePickerDidSetectDate(_:)), for: UIControl.Event.valueChanged)
                
                if textField.text == "" {
                    birthdatePicker.date = Date()
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "dd/MM/yyyy"
                    textField.text = dateFormater.string(from: Date())
                }
                else {
                    if let strDate = textField.text {
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "dd/MM/yyyy"
                        let dateee = dateFormater.date(from: strDate)
                        birthdatePicker.date = dateee ?? Date()
                    }
                    else {
                        birthdatePicker.date = Date()
                    }
                }
                textField.addDoneToolbar()
                textField.inputView = self.birthdatePicker
                textField.autocapitalizationType = .none
            }
            else if strID == SKDataKeys.gender.rawValue {
                self.strSelection = strID
                let eng = arr_Gender[0].gender_english ?? ""
                let guj = arr_Gender[0].gender_guj ?? ""
                let genderrr = "\(eng) (\(guj))"
                textField.text = genderrr
                pickerForGender.accessibilityIdentifier = strID
                textField.inputView = pickerForGender
                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                self.pickerForGender.reloadAllComponents()
            }
            else if strID == SKDataKeys.country_code.rawValue {
                if self.arr_CountryCodeListData.count != 0 {
                    self.strSelection = strID
                    let intCountryCode = self.arr_CountryCodeListData[0].country_code ?? 0
                    let strCountryCode = self.arr_CountryCodeListData[0].country_name ?? ""
                    let conyCode = "(\(intCountryCode)) \(strCountryCode)"
                    textField.text = conyCode
                    textField.inputView = pickerForGender
                    self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    self.pickerForGender.reloadAllComponents()
                }
                else {
                    self.strSelection = strID
                    self.CallAPIForGetCountryCode(textField)
                }
            }
            else if strID == SKDataKeys.relation.rawValue {
                let strnme = self.dictDetail[SKDataKeys.relation.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_RelationData.count != 0 {
                        self.strSelection = strID
                        textField.text = self.arr_RelationData[0].relation_english
                        self.dictDetail[SKDataKeys.relation_gj.rawValue] = self.arr_RelationData[0].relation_guj
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetRelation(textField, gujarati: false)
                    }
                }
                else {
                    if self.arr_RelationData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_RelationData[0].relation_english
                        self.dictDetail[SKDataKeys.relation_gj.rawValue] = self.arr_RelationData[0].relation_guj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetRelation(textField, gujarati: false)
                    }
                }
            }
            else if strID == SKDataKeys.marital_status.rawValue {
                let strnme = self.dictDetail[SKDataKeys.marital_status.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_MeritalData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_MeritalData[0].marital_status_eng
                        self.dictDetail[SKDataKeys.marital_status_gj.rawValue] = self.arr_MeritalData[0].marital_status_guj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetMarritalStatus(textField, gujarati: false)
                    }
                }
                else {
                    if self.arr_MeritalData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_MeritalData[0].marital_status_eng
                        self.dictDetail[SKDataKeys.marital_status_gj.rawValue] = self.arr_MeritalData[0].marital_status_guj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetMarritalStatus(textField, gujarati: false)
                    }
                }
            }
                
            else if strID == SKDataKeys.marital_status_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.marital_status_gj.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_MeritalData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_MeritalData[0].marital_status_guj
                        self.dictDetail[SKDataKeys.marital_status.rawValue] = self.arr_MeritalData[0].marital_status_eng
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetMarritalStatus(textField, gujarati: true)
                    }
                }
                else {
                    if self.arr_MeritalData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_MeritalData[0].marital_status_guj
                        self.dictDetail[SKDataKeys.marital_status.rawValue] = self.arr_MeritalData[0].marital_status_eng
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetMarritalStatus(textField, gujarati: true)
                    }
                }
            }
            else if strID == SKDataKeys.pole_name.rawValue {
                let strnme = self.dictDetail[SKDataKeys.pole_name.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_PoleData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_PoleData[0].pole_name
                        self.dictDetail[SKDataKeys.pole_name_gj.rawValue] = self.arr_PoleData[0].pole_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetPole(textField, gujarati: false)
                    }
                }
                else {
                    if self.arr_PoleData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_PoleData[0].pole_name
                        self.dictDetail[SKDataKeys.pole_name_gj.rawValue] = self.arr_PoleData[0].pole_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetPole(textField, gujarati: false)
                    }
                }
            }
                
            else if strID == SKDataKeys.pole_name_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.pole_name_gj.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_PoleData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_PoleData[0].pole_name_gj
                        self.dictDetail[SKDataKeys.pole_name.rawValue] = self.arr_PoleData[0].pole_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetPole(textField, gujarati: true)
                    }
                }
                else {
                    if self.arr_PoleData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_PoleData[0].pole_name_gj
                        self.dictDetail[SKDataKeys.pole_name.rawValue] = self.arr_PoleData[0].pole_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetPole(textField, gujarati: true)
                    }
                }
            }
            else if strID == SKDataKeys.saakh.rawValue {
                let strnme = self.dictDetail[SKDataKeys.saakh.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_ShakhData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_ShakhData[0].saakh_name
                        self.dictDetail[SKDataKeys.saakh_name_gj.rawValue] = self.arr_ShakhData[0].saakh_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetShakh(textField, gujarati: false, priviousSaaakh: false)
                    }
                }
                else {
                    if self.arr_ShakhData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_ShakhData[0].saakh_name
                        self.dictDetail[SKDataKeys.saakh_name_gj.rawValue] = self.arr_ShakhData[0].saakh_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetShakh(textField, gujarati: false, priviousSaaakh: false)
                    }
                }
            }
                
            else if strID == SKDataKeys.saakh_name_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.saakh_name_gj.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_ShakhData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_ShakhData[0].saakh_name_gj
                        self.dictDetail[SKDataKeys.saakh.rawValue] = self.arr_ShakhData[0].saakh_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetShakh(textField, gujarati: true, priviousSaaakh: false)
                    }
                }
                else {
                    if self.arr_ShakhData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_ShakhData[0].saakh_name_gj
                        self.dictDetail[SKDataKeys.saakh.rawValue] = self.arr_ShakhData[0].saakh_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetShakh(textField, gujarati: true, priviousSaaakh: false)
                    }
                }
            }
            else if strID == SKDataKeys.previous_saakh.rawValue {
                let strnme = self.dictDetail[SKDataKeys.previous_saakh.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_ShakhData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_ShakhData[0].saakh_name
                        self.dictDetail[SKDataKeys.previous_saakh_gj.rawValue] = self.arr_ShakhData[0].saakh_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetShakh(textField, gujarati: false, priviousSaaakh: true)
                    }
                }
                else {
                    if self.arr_ShakhData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_ShakhData[0].saakh_name
                        self.dictDetail[SKDataKeys.previous_saakh_gj.rawValue] = self.arr_ShakhData[0].saakh_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetShakh(textField, gujarati: false, priviousSaaakh: true)
                    }
                }
            }
            else if strID == SKDataKeys.previous_saakh_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.previous_saakh_gj.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_ShakhData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_ShakhData[0].saakh_name_gj
                        self.dictDetail[SKDataKeys.previous_saakh.rawValue] = self.arr_ShakhData[0].saakh_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetShakh(textField, gujarati: true, priviousSaaakh: true)
                    }
                }
                else {
                    if self.arr_ShakhData.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_ShakhData[0].saakh_name_gj
                        self.dictDetail[SKDataKeys.previous_saakh.rawValue] = self.arr_ShakhData[0].saakh_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetShakh(textField, gujarati: true, priviousSaaakh: true)
                    }
                }
            }
            else if strID == SKDataKeys.address_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.address.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.area_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.area.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.city.rawValue {
                let strnme = self.dictDetail[SKDataKeys.city.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_City.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_City[0].city_name
                        self.dictDetail[SKDataKeys.city_gj.rawValue] = self.arr_City[0].city_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetCity(textField, gujarati: false)
                    }
                }
                else {
                    if self.arr_City.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_City[0].city_name
                        self.dictDetail[SKDataKeys.city_gj.rawValue] = self.arr_City[0].city_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetCity(textField, gujarati: false)
                    }
                }
            }
                
            else if strID == SKDataKeys.city_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.city_gj.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_City.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_City[0].city_name_gj
                        self.dictDetail[SKDataKeys.city.rawValue] = self.arr_City[0].city_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetCity(textField, gujarati: true)
                    }
                }
                else {
                    if self.arr_City.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_City[0].city_name_gj
                        self.dictDetail[SKDataKeys.city.rawValue] = self.arr_City[0].city_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetCity(textField, gujarati: true)
                    }
                }
            }
            else if strID == SKDataKeys.country.rawValue {
                let strnme = self.dictDetail[SKDataKeys.country.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_Country.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_Country[0].country_name
                        self.dictDetail[SKDataKeys.country_gj.rawValue] = self.arr_Country[0].country_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetCountry(textField, gujarati: false)
                    }
                }
                else {
                    if self.arr_Country.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_Country[0].country_name
                        self.dictDetail[SKDataKeys.country_gj.rawValue] = self.arr_Country[0].country_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetCountry(textField, gujarati: false)
                    }
                }
            }
                
            else if strID == SKDataKeys.country_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.country_gj.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_Country.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_Country[0].country_name_gj
                        self.dictDetail[SKDataKeys.country.rawValue] = self.arr_Country[0].country_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetCountry(textField, gujarati: true)
                    }
                }
                else {
                    if self.arr_Country.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_Country[0].country_name_gj
                        self.dictDetail[SKDataKeys.country.rawValue] = self.arr_Country[0].country_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetCountry(textField, gujarati: true)
                    }
                }
            }
            else if strID == SKDataKeys.eduction_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.eduction.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.profession_name.rawValue {
                let strnme = self.dictDetail[SKDataKeys.profession_name.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_Profession.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_Profession[0].profession_name
                        self.dictDetail[SKDataKeys.profession_name_gj.rawValue] = self.arr_Profession[0].profession_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetProfession(textField, gujarati: false)
                    }
                }
                else {
                    if self.arr_Profession.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_Profession[0].profession_name
                        self.dictDetail[SKDataKeys.profession_name_gj.rawValue] = self.arr_Profession[0].profession_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetProfession(textField, gujarati: false)
                    }
                }
            }
                
            else if strID == SKDataKeys.profession_name_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.profession_name_gj.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_Profession.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_Profession[0].profession_name_gj
                        self.dictDetail[SKDataKeys.profession_name.rawValue] = self.arr_Profession[0].profession_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetProfession(textField, gujarati: true)
                    }
                }
                else {
                    if self.arr_Profession.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_Profession[0].profession_name_gj
                        self.dictDetail[SKDataKeys.profession_name.rawValue] = self.arr_Profession[0].profession_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetProfession(textField, gujarati: true)
                    }
                }
            }
            else if strID == SKDataKeys.business_type_name.rawValue {
                let strnme = self.dictDetail[SKDataKeys.business_type_name.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_Business.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_Business[0].business_name
                        self.dictDetail[SKDataKeys.business_type_name_gj.rawValue] = self.arr_Business[0].business_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetBusiness(textField, gujarati: false)
                    }
                }
                else {
                    if self.arr_Business.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_Business[0].business_name
                        self.dictDetail[SKDataKeys.business_type_name_gj.rawValue] = self.arr_Business[0].business_name_gj
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetBusiness(textField, gujarati: false)
                    }
                }
            }
                
            else if strID == SKDataKeys.business_type_name_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.business_type_name_gj.rawValue] as? String ?? ""
                if strnme != "" {
                    if self.arr_Business.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        self.pickerForGender.reloadAllComponents()
                        textField.text = self.arr_Business[0].business_name_gj
                        self.dictDetail[SKDataKeys.business_type_name.rawValue] = self.arr_Business[0].business_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetBusiness(textField, gujarati: true)
                    }
                }
                else {
                    if self.arr_Business.count != 0 {
                        self.strSelection = strID
                        textField.inputView = pickerForGender
                        textField.text = self.arr_Business[0].business_name_gj
                        self.dictDetail[SKDataKeys.business_type_name.rawValue] = self.arr_Business[0].business_name
                        self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                        self.pickerForGender.reloadAllComponents()
                    }
                    else {
                        self.strSelection = strID
                        self.CallAPIForGetBusiness(textField, gujarati: true)
                    }
                }
            }
                
            else if strID == SKDataKeys.blood_group.rawValue {
                self.strSelection = strID
                textField.inputView = pickerForGender
                self.pickerForGender.reloadAllComponents()
                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                textField.text = self.arr_BloodGroup[0].blood_group
            }
            else if strID == SKDataKeys.company_name_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.company_name.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.company_address_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.company_address.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.position_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.position.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.hobbies_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.hobbies.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.other_business_type_name_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.other_business_type_name.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.password.rawValue {
                textField.isSecureTextEntry = true
            }
            else if strID == SKDataKeys.confirm_password.rawValue {
                textField.isSecureTextEntry = true
            }
            else {
                textField.inputView = nil
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
            if strID == SKDataKeys.membership_no.rawValue {
                self.CallAPIForGetReferenceofTheFamilyName(strValue: textField.text ?? "", txtFild: textField)
            }
        }
    }
    
}





extension UITextField {
    
    func addDoneToolbar()
    {
        self.inputAccessoryView = nil
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle       = UIBarStyle.default
        let flexSpace              = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.done))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        doneToolbar.tintColor = #colorLiteral(red: 0.1961376071, green: 0.491124928, blue: 0.7413111925, alpha: 1)
        
        //let gradientLayer = CAGradientLayer(frame: self.frame, colors: [#colorLiteral(red: 0.9725490196, green: 0.09019607843, blue: 0.4039215686, alpha: 1),#colorLiteral(red: 0.9411764706, green: 0.2666666667, blue: 0.2666666667, alpha: 1)], direction: .Right)
        
        //let image = gradientLayer.creatGradientImage()
        
        //doneToolbar.tintColor = image == nil ? #colorLiteral(red: 0.1961376071, green: 0.491124928, blue: 0.7413111925, alpha: 1) : UIColor.init(patternImage: image ?? #imageLiteral(resourceName: "dashDefault"))
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func done() {
        self.endEditing(true)
        NotificationCenter.default.post(name: NSNotification.Name.init("RELOADTABLEVIEW"), object: nil)
    }
}
