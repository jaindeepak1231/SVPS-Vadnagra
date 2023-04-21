//
//  EditMetromonialVC.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 04/06/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import Alamofire
import MobileCoreServices
import SkyFloatingLabelTextField


class EditMetromonialVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    var is_Passport = ""
    var strSelection = ""
    var metromonialID = "0"
    var familyMemberID = "0"
    var toolBar = UIToolbar()
    var isJanmashar = false
    var is_ChangePhoto1 = false
    var is_ChangePhoto2 = false
    var SelectPhoto1 = UIImage()
    var SelectPhoto2 = UIImage()
    var janmasharFilePath : URL?
    var dictDetail = [String:Any]()
    var birthdatePicker = UIDatePicker()
    @IBOutlet weak var tblView: UITableView!
    let imagePicker = UIImagePickerController()
    var pickerForGender: UIPickerView = UIPickerView()
    var didSelectedDate: ((UIDatePicker)->Void)? = nil
    var didSelectedTime: ((UIDatePicker)->Void)? = nil
    var completionGenderSelectedCell: ((String, Bool)->Void)?
    var completionMangalShaniSelectedCell: ((String, Bool)->Void)?
    var completionHoroscopeSelectedCell: ((String, Bool)->Void)?
    var completionGlassSelectedCell: ((String, Bool)->Void)?
    var completionHouseSelectedCell: ((String, Bool)->Void)?
    var arrSectionsRow: [RegisterRowsData]! = [RegisterRowsData]()
    var completionMaritalStatusSelectedCell: ((String, String, Bool)->Void)?
    var completionMaritalStatusGJSelectedCell: ((String, String, Bool)->Void)?
    var completionProfessionSelectedCell: ((String, String, String, Bool)->Void)?
    var completionProfessionGJSelectedCell: ((String, String, String, Bool)->Void)?

    var arr_YesNo = [YESNOListData]()
    var arr_HomeRent = [HomeRentListData]()
    var arr_Gender = [GenderListData]()
    var arr_Business = [BusinessListData]()
    var arr_MeritalData = [MaritalListData]()
    var arr_Profession = [ProfessionListData]()
    var dic_Metromonial = MetromonialListData()
    
    let documentPicker = UIDocumentPickerViewController.init(documentTypes: [String(kUTTypePDF), String(kUTTypeAudio),String(kUTTypeImage),String(kUTTypeArchive),String(kUTTypePlainText)], in: UIDocumentPickerMode.import)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Matrimonial".localized("")
        self.imagePicker.delegate = self
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        self.navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        setupUI()
        
        //Register Table Cell
        self.tblView.register(UINib.init(nibName: "MetromonialProfileImageTableCell"
            , bundle: nil), forCellReuseIdentifier: "MetromonialProfileImageTableCell")
        self.tblView.register(UINib.init(nibName: "RegisterTableCell", bundle: nil), forCellReuseIdentifier: "RegisterTableCell")
        self.tblView.register(UINib.init(nibName: "ButtonTableCell", bundle: nil), forCellReuseIdentifier: "ButtonTableCell")
        self.tblView.register(UINib.init(nibName: "TermsConditionTableCell", bundle: nil), forCellReuseIdentifier: "TermsConditionTableCell")
        //*******************************************************//
        
        self.CallAPIForGetMetromonialProfileByID()
        
        
        //set gender array
        let dic = GenderListData.init(gender_guj: "પુરુષ", gender_english: "Male")
        self.arr_Gender.append(dic)
        let dic1 = GenderListData.init(gender_guj: "સ્ત્રી", gender_english: "Female")
        self.arr_Gender.append(dic1)
        //**********************//
        
        //set Yes No array
        let dic2 = YESNOListData.init(yesNo_guj: "હા", yesNo_english: "Yes")
        self.arr_YesNo.append(dic2)
        let dic3 = YESNOListData.init(yesNo_guj: "ના", yesNo_english: "No")
        self.arr_YesNo.append(dic3)
        //**********************//
        
        //set Yes No array
        let dic4 = HomeRentListData.init(homeRent_guj: "પોતાનું ઘર", homeRent_english: "Own House")
        self.arr_HomeRent.append(dic4)
        let dic5 = HomeRentListData.init(homeRent_guj: "ભાડેનું ઘર", homeRent_english: "Rent")
        self.arr_HomeRent.append(dic5)
        //**********************//
        
        pickerForGender.delegate  = self
        pickerForGender.dataSource = self
        pickerForGender.reloadAllComponents()
    }
    
    final func setupUI() {
        self.navigationController?.navigationBar.barTintColor = Constants.Color.blueColor
    }
    
    
    //MARK: API CAll
    func CallAPIForGetMetromonialProfileByID() {
        
        ShowProgressHud(message: "please wait...".localized(""))
        
        let param = ["matrimonial_id" : metromonialID]
        
        print(URL_getMetromonialProfileByID, param)
        
        ServiceCustom.shared.requestURLwithData(URL_getMetromonialProfileByID, Method: "POST", parameters: param, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        
                        if let data = dataa {
                            do {
                                let arrData = try JSONDecoder().decode(MetromialData.self, from: data)
                                
                                if let arrCat = arrData.data {
                                    self.dic_Metromonial = arrCat
                                }
                                self.setUpforSectionsData()
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
    
    //Setup Sections
    func setUpforSectionsData() {
        self.arrSectionsRow.removeAll()
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, "ProfileImage", "ProfileImage", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.gender.rawValue, "Gender (જાતિ)*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.contact.rawValue, "Contact (સંપર્ક)*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.mother_name.rawValue, "Mother Name*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.mother_name_gj.rawValue, "માતાનું નામ*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.current_address.rawValue, "Current Address*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.current_address_gj.rawValue, "વર્તમાન સરનામુ*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.mobile_guardian.rawValue, "Mobile No. of guardian*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.birth_date.rawValue, "Birthdate/જન્મતારીખ*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.birth_time.rawValue, "Birth Time/જન્મનો સમય*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.mangal_shani.rawValue, "Mangal/Shani (મંગલ / શનિ)*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.birth_place.rawValue, "Birth Place*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.birth_place_gj.rawValue, "જન્મ સ્થળ*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.height.rawValue, "Height*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.weight.rawValue, "Weight*", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.complexion.rawValue, "Complexion", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.complexion_gj.rawValue, "રંગ", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.horoscope.rawValue, "Believe in Horoscope? (જન્માક્ષર માં માને છે?)", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.hobbies.rawValue, "Hobbies", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.hobbies_gj.rawValue, "રૂચિ અને શોખ", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.groom_bride_preferences.rawValue, "Groom / Bride Preference", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.groom_bride_preferences_gj.rawValue, "પુરૂષ / સ્ત્રી પસંદગી", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.qualification.rawValue, "Qualification", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.qualification_gj.rawValue, "લાયકાત", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.any_deficiency.rawValue, "Any deficiency", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.any_deficiency_gj.rawValue, "કોઈપણ અભાવ", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.current_activity.rawValue, "Current Activity", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.current_activity_gj.rawValue, "વર્તમાન પ્રવૃત્તિ", ""))

        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.profession_name.rawValue, "Occupation", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.profession_name_gj.rawValue, "વ્યવસાય", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.marital_status.rawValue, "Marital Status", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.marital_status_gj.rawValue, "વૈવાહિક સ્થિતિ", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.glasses_is.rawValue, "Wear EYE Glass", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.house.rawValue, "Home (ઘર)", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.annual_income.rawValue, "Annual Income", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.annual_income_family.rawValue, "Annual Income of Family", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.occupation_father.rawValue, "Occupation of Father", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.occupation_mother.rawValue, "Occupation of Mother", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.many_brothers.rawValue, "How many Brothers", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.married_brothers.rawValue, "How Many are married", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.many_sisters.rawValue, "How many Sisters", ""))

        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.married_sisters.rawValue, "How Many are married", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.mosad_details.rawValue, "Details:Name", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.witness_name.rawValue, "Reference Name", ""))

        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.requirement.rawValue, "Requirement", ""))

        self.arrSectionsRow.append(RegisterRowsData.init(1, SKDataKeys.janmakshar.rawValue, "Janmakshar / જન્માક્ષર", ""))

        self.arrSectionsRow.append(RegisterRowsData.init(1, "Terms_Conditions", "Terms and Conditions", ""))
        
        self.arrSectionsRow.append(RegisterRowsData.init(1, "button", "UPDATE".localized(""), ""))
        
        self.setUpValue()
        self.tblView.reloadData()
    }

    
    func setUpValue() {
        
        var gendr = self.dic_Metromonial.gender ?? ""
        if gendr.lowercased() == "male" {
            gendr = "\(gendr.capitalized) (પુરુષ)"
        }
        else {
            gendr = "\(gendr.capitalized) (સ્ત્રી)"
        }
        
        var strDate = self.dic_Metromonial.birth_date ?? ""
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        let dte = dateFormater.date(from: strDate)
        dateFormater.dateFormat = "dd-MM-yyyy"
        strDate = dateFormater.string(from: dte ?? Date())
        
        
        self.dictDetail[SKDataKeys.photo.rawValue] = self.dic_Metromonial.photo ?? ""
        self.dictDetail[SKDataKeys.photo_2.rawValue] = self.dic_Metromonial.photo_2 ?? ""
        self.dictDetail[SKDataKeys.gender.rawValue] = gendr
        self.dictDetail[SKDataKeys.contact.rawValue] = self.dic_Metromonial.contact ?? ""
        self.dictDetail[SKDataKeys.mother_name.rawValue] = self.dic_Metromonial.mother_name ?? ""
        self.dictDetail[SKDataKeys.mother_name_gj.rawValue] = self.dic_Metromonial.mother_name_gj ?? ""
        self.dictDetail[SKDataKeys.current_address.rawValue] = self.dic_Metromonial.current_address ?? ""
        self.dictDetail[SKDataKeys.current_address_gj.rawValue] = self.dic_Metromonial.current_address_gj ?? ""
        self.dictDetail[SKDataKeys.mobile_guardian.rawValue] = self.dic_Metromonial.mobile_guardian ?? ""
        self.dictDetail[SKDataKeys.birth_date.rawValue] = strDate
        self.dictDetail[SKDataKeys.birth_time.rawValue] = self.dic_Metromonial.birth_time ?? ""
        self.dictDetail[SKDataKeys.mangal_shani.rawValue] = self.dic_Metromonial.mangal_shani ?? ""
        self.dictDetail[SKDataKeys.birth_place.rawValue] = self.dic_Metromonial.birth_place ?? ""
        self.dictDetail[SKDataKeys.birth_place_gj.rawValue] = self.dic_Metromonial.birth_place_gj ?? ""
        self.dictDetail[SKDataKeys.height.rawValue] = self.dic_Metromonial.height ?? ""
        self.dictDetail[SKDataKeys.weight.rawValue] = self.dic_Metromonial.weight ?? ""
        self.dictDetail[SKDataKeys.complexion.rawValue] = self.dic_Metromonial.complexion ?? ""
        self.dictDetail[SKDataKeys.complexion_gj.rawValue] = self.dic_Metromonial.complexion_gj ?? ""
        self.dictDetail[SKDataKeys.horoscope.rawValue] = self.dic_Metromonial.horoscope ?? ""
        self.dictDetail[SKDataKeys.groom_bride_preferences.rawValue] = self.dic_Metromonial.groom_bride_preferences ?? ""
        self.dictDetail[SKDataKeys.groom_bride_preferences_gj.rawValue] = self.dic_Metromonial.groom_bride_preferences_gj ?? ""
        self.dictDetail[SKDataKeys.qualification.rawValue] = self.dic_Metromonial.qualification ?? ""
        self.dictDetail[SKDataKeys.qualification_gj.rawValue] = self.dic_Metromonial.qualification_gj ?? ""
        self.dictDetail[SKDataKeys.any_deficiency.rawValue] = self.dic_Metromonial.any_deficiency ?? ""
        self.dictDetail[SKDataKeys.any_deficiency_gj.rawValue] = self.dic_Metromonial.any_deficiency_gj ?? ""
        self.dictDetail[SKDataKeys.current_activity.rawValue] = self.dic_Metromonial.current_activity ?? ""
        self.dictDetail[SKDataKeys.current_activity_gj.rawValue] = self.dic_Metromonial.current_activity_gj ?? ""
        self.dictDetail[SKDataKeys.profession_name.rawValue] = self.dic_Metromonial.profession_name ?? ""
        self.dictDetail[SKDataKeys.profession_name_gj.rawValue] = self.dic_Metromonial.profession_name_gj ?? ""
        self.dictDetail[SKDataKeys.profession_id.rawValue] = self.dic_Metromonial.profession ?? ""
        self.dictDetail[SKDataKeys.marital_status.rawValue] = self.dic_Metromonial.marital_status ?? ""
        self.dictDetail[SKDataKeys.marital_status_gj.rawValue] = self.dic_Metromonial.marital_status_gj ?? ""
        self.dictDetail[SKDataKeys.glasses_is.rawValue] = self.dic_Metromonial.glasses_is ?? ""
        self.dictDetail[SKDataKeys.house.rawValue] = self.dic_Metromonial.house ?? ""
        self.dictDetail[SKDataKeys.annual_income.rawValue] = self.dic_Metromonial.annual_income ?? ""
        self.dictDetail[SKDataKeys.annual_income_family.rawValue] = self.dic_Metromonial.annual_income_family ?? ""
        
        self.dictDetail[SKDataKeys.occupation_father.rawValue] = self.dic_Metromonial.occupation_father ?? ""
        
        self.dictDetail[SKDataKeys.occupation_mother.rawValue] = self.dic_Metromonial.occupation_mother ?? ""
        
        self.dictDetail[SKDataKeys.many_brothers.rawValue] = self.dic_Metromonial.many_brothers ?? ""
        
        self.dictDetail[SKDataKeys.married_brothers.rawValue] = self.dic_Metromonial.married_brothers ?? ""
        
        self.dictDetail[SKDataKeys.many_sisters.rawValue] = self.dic_Metromonial.many_sisters ?? ""
        self.dictDetail[SKDataKeys.married_sisters.rawValue] = self.dic_Metromonial.married_sisters ?? ""

        self.dictDetail[SKDataKeys.mosad_details.rawValue] = self.dic_Metromonial.mosad_details ?? ""
        
        self.dictDetail[SKDataKeys.witness_name.rawValue] = self.dic_Metromonial.witness_name ?? ""
        
        self.dictDetail[SKDataKeys.requirement.rawValue] = self.dic_Metromonial.requirement ?? ""
        
        self.dictDetail[SKDataKeys.janmakshar.rawValue] = self.dic_Metromonial.janmakshar ?? ""
        
    }
    
    
    
    func validateData() -> Bool {
        
        let strGender = self.dictDetail[SKDataKeys.gender.rawValue] as? String ?? ""
        let strContct = self.dictDetail[SKDataKeys.contact.rawValue] as? String ?? ""
        let strMother_name = self.dictDetail[SKDataKeys.mother_name.rawValue] as? String ?? ""
        let strMother_name_GJ = self.dictDetail[SKDataKeys.mother_name_gj.rawValue] as? String ?? ""
        let strCurrentAddress = self.dictDetail[SKDataKeys.current_address.rawValue] as? String ?? ""
        let strCurrentAddress_gj = self.dictDetail[SKDataKeys.current_address_gj.rawValue] as? String ?? ""
        let strMobileGuardian = self.dictDetail[SKDataKeys.mobile_guardian
            .rawValue] as? String ?? ""
        let strBirthPlace = self.dictDetail[SKDataKeys.birth_place.rawValue] as? String ?? ""
        let strBirthPlace_gj = self.dictDetail[SKDataKeys.birth_place_gj.rawValue] as? String ?? ""
        let strBirthDate = self.dictDetail[SKDataKeys.birth_date
            .rawValue] as? String ?? ""
        let strBirthTime = self.dictDetail[SKDataKeys.birth_time
            .rawValue] as? String ?? ""
        let strMangal_Shani = self.dictDetail[SKDataKeys.mangal_shani
            .rawValue] as? String ?? ""
        let strHeight = self.dictDetail[SKDataKeys.height.rawValue] as? String ?? ""
        let strWeight = self.dictDetail[SKDataKeys.weight.rawValue] as? String ?? ""

        if strGender.trim.count == 0 {
            showAlert(message: AlertMessages.enterGender.localized(""))
            return false
        }
        else if strContct.trim.count == 0 {
            showAlert(message: AlertMessages.enterF_Name.localized(""))
            return false
        }
        else if strMother_name.trim.count == 0 {
            showAlert(message: AlertMessages.enterMother_Name.localized(""))
            return false
        }
        else if strMother_name_GJ.trim.count == 0 {
            showAlert(message: AlertMessages.enterMother_Name.localized(""))
            return false
        }
        else if strCurrentAddress.trim.count == 0 {
            showAlert(message: AlertMessages.enterL_Name.localized(""))
            return false
        }
        else if strCurrentAddress_gj.trim.count == 0 {
            showAlert(message: AlertMessages.enterL_Name.localized(""))
            return false
        }
        else if strMobileGuardian.trim.count == 0 {
            showAlert(message: AlertMessages.enterGender.localized(""))
            return false
        }
        else if strBirthPlace.trim.count == 0 {
            showAlert(message: AlertMessages.enterBirthDate.localized(""))
            return false
        }
        else if strBirthPlace_gj.trim.count == 0 {
            showAlert(message: AlertMessages.enterBirthDate.localized(""))
            return false
        }
        else if strBirthDate.trim.count == 0 {
            showAlert(message: AlertMessages.enterBirthDate.localized(""))
            return false
        }
        else if strBirthTime.trim.count == 0 {
            showAlert(message: AlertMessages.enterRelation.localized(""))
            return false
        }
        else if strMangal_Shani.trim.count == 0 {
            showAlert(message: AlertMessages.enterPole.localized(""))
            return false
        }
        else if strHeight.trim.count == 0 {
            showAlert(message: AlertMessages.enterPole.localized(""))
            return false
        }
        else if strWeight.trim.count == 0 {
            showAlert(message: AlertMessages.enterShakh.localized(""))
            return false
        }

        return true
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
        else if self.strSelection == SKDataKeys.mangal_shani.rawValue {
            return arr_YesNo.count
        }
        else if self.strSelection == SKDataKeys.horoscope.rawValue {
            return arr_YesNo.count
        }
        else if self.strSelection == SKDataKeys.glasses_is.rawValue {
            return arr_YesNo.count
        }
        else if self.strSelection == SKDataKeys.house.rawValue {
            return arr_HomeRent.count
        }
        else if self.strSelection == SKDataKeys.marital_status.rawValue || self.strSelection == SKDataKeys.marital_status_gj.rawValue {
            return arr_MeritalData.count
        }
        else if self.strSelection == SKDataKeys.profession_name.rawValue || self.strSelection == SKDataKeys.profession_name_gj.rawValue {
            return arr_Profession.count
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
        else if self.strSelection == SKDataKeys.mangal_shani.rawValue {
            let eng = arr_YesNo[row].yesNo_english ?? ""
            let guj = arr_YesNo[row].yesNo_guj ?? ""
            return "\(eng) (\(guj))"
        }
        else if self.strSelection == SKDataKeys.horoscope.rawValue {
            let eng = arr_YesNo[row].yesNo_english ?? ""
            let guj = arr_YesNo[row].yesNo_guj ?? ""
            return "\(eng) (\(guj))"
        }
        else if self.strSelection == SKDataKeys.glasses_is.rawValue {
            let eng = arr_YesNo[row].yesNo_english ?? ""
            let guj = arr_YesNo[row].yesNo_guj ?? ""
            return "\(eng) (\(guj))"
        }
        else if self.strSelection == SKDataKeys.house.rawValue {
            let eng = arr_HomeRent[row].homeRent_english ?? ""
            let guj = arr_HomeRent[row].homeRent_guj ?? ""
            return "\(eng) (\(guj))"
        }
        else if self.strSelection == SKDataKeys.marital_status.rawValue {
            return arr_MeritalData[row].marital_status_eng as String?
        }
        else if self.strSelection == SKDataKeys.marital_status_gj.rawValue {
            return arr_MeritalData[row].marital_status_guj as String?
        }
        else if self.strSelection == SKDataKeys.profession_name.rawValue {
            return arr_Profession[row].profession_name as String?
        }
        else if self.strSelection == SKDataKeys.profession_name_gj.rawValue {
            return arr_Profession[row].profession_name_gj as String?
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
            
        else if self.strSelection == SKDataKeys.mangal_shani.rawValue {
            let eng = arr_YesNo[row].yesNo_english ?? ""
            let guj = arr_YesNo[row].yesNo_guj ?? ""
            let genderrr = "\(eng) (\(guj))"
            
            if let callBack = self.completionMangalShaniSelectedCell {
                callBack(genderrr , true)
            }
        }
        else if self.strSelection == SKDataKeys.horoscope.rawValue {
            let eng = arr_YesNo[row].yesNo_english ?? ""
            let guj = arr_YesNo[row].yesNo_guj ?? ""
            let genderrr = "\(eng) (\(guj))"
            
            if let callBack = self.completionHoroscopeSelectedCell {
                callBack(genderrr , true)
            }
        }
        else if self.strSelection == SKDataKeys.glasses_is.rawValue {
            let eng = arr_YesNo[row].yesNo_english ?? ""
            let guj = arr_YesNo[row].yesNo_guj ?? ""
            let genderrr = "\(eng) (\(guj))"
            
            if let callBack = self.completionGlassSelectedCell {
                callBack(genderrr , true)
            }
        }
        else if self.strSelection == SKDataKeys.house.rawValue {
            let eng = arr_YesNo[row].yesNo_english ?? ""
            let guj = arr_YesNo[row].yesNo_guj ?? ""
            let genderrr = "\(eng) (\(guj))"
            
            if let callBack = self.completionHouseSelectedCell {
                callBack(genderrr , true)
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
        dicParamsforAPI.removeValue(forKey: SKDataKeys.photo.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.janmakshar.rawValue)
        dicParamsforAPI.removeValue(forKey: SKDataKeys.photo_2.rawValue)
        
        
        //Set Date
        let strDte = self.dictDetail[SKDataKeys.birth_date.rawValue] as? String ?? ""
        if strDte != "" {
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd-MM-yyyy"
            if let dte_Date = dateFormater.date(from: strDte) {
                dateFormater.dateFormat = "yyyy-MM-dd"
                dicParamsforAPI[SKDataKeys.birth_date.rawValue] = dateFormater.string(from: dte_Date)
            }
        }
        
        //Profession
        let professionID = self.dictDetail[SKDataKeys.profession_id.rawValue] as? String ?? ""
        dicParamsforAPI["profession"] = professionID
        dicParamsforAPI["profession_gj"] = professionID
        
        //Get Male
        let strMaleFemale = self.dictDetail[SKDataKeys.gender.rawValue] as? String ?? ""
        if strMaleFemale != "" {
            if strMaleFemale.contains(" ") {
                let arrMaleFemale = strMaleFemale.components(separatedBy: " ")
                let str_Male = arrMaleFemale.first ?? ""
                dicParamsforAPI[SKDataKeys.gender.rawValue] = str_Male.lowercased()
            }
        }
        
        //Get Mangal shani
        let strmangalShani = self.dictDetail[SKDataKeys.mangal_shani.rawValue] as? String ?? ""
        if strmangalShani != "" {
            if strmangalShani.contains(" ") {
                let arrShani = strmangalShani.components(separatedBy: " ")
                let str_shani = arrShani.first ?? ""
                dicParamsforAPI[SKDataKeys.mangal_shani.rawValue] = str_shani.lowercased()
            }
        }
        
        //Get Horoscope
        let strHoroscope = self.dictDetail[SKDataKeys.horoscope.rawValue] as? String ?? ""
        if strHoroscope != "" {
            if strHoroscope.contains(" ") {
                let arrHoroscope = strHoroscope.components(separatedBy: " ")
                let str_horoscop = arrHoroscope.first ?? ""
                dicParamsforAPI[SKDataKeys.horoscope.rawValue] = str_horoscop.lowercased()
            }
        }
        
        //Get Wear Eye Glass
        let strglass = self.dictDetail[SKDataKeys.glasses_is.rawValue] as? String ?? ""
        if strglass != "" {
            if strglass.contains(" ") {
                let arrGlass = strglass.components(separatedBy: " ")
                let str_Glass = arrGlass.first ?? ""
                dicParamsforAPI[SKDataKeys.glasses_is.rawValue] = str_Glass.lowercased()
            }
        }
        
        //Get Wear Eye Glass
        let strhose = self.dictDetail[SKDataKeys.house.rawValue] as? String ?? ""
        if strhose != "" {
            if strhose.contains(" ") {
                let arrhouse = strhose.components(separatedBy: " ")
                let str_House = arrhouse.first ?? ""
                dicParamsforAPI[SKDataKeys.house.rawValue] = str_House.lowercased()
            }
        }
        
        let str_FileName = self.dictDetail[SKDataKeys.janmakshar.rawValue] as? String ?? ""

        
        
        //For Edit Matrimonial
        dicParamsforAPI["matrimonial_id"] = metromonialID
        dicParamsforAPI["family_member_id"] = familyMemberID
        dicParamsforAPI["membership_no"] = strGetUserName_Email("membership_no")

        debugPrint("API Call", dicParamsforAPI)

        //API Calling for Update Matrimonial
        self.CallAPIForUpdateProfilewithProfilePicture(dicParamsforAPI, filename: str_FileName)
        
        //******************//
    }
    
    //MARK: Update Profile
    func CallAPIForUpdateProfile(_ dicPARAMS: Dictionary<String,String> = [:]) {
        
        ShowProgressHud(message: "please wait...".localized(""))
        
        print(URL_AddUpdateMatrimonial, dicPARAMS)
        
        ServiceCustom.shared.requestURLwithBlankHeaderData(URL_AddUpdateMatrimonial, Method: "POST", parameters: dicPARAMS, completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let dicUserData = dictResult["data"] as? NSDictionary {

                            // Create the alert controller
                            let alertController = UIAlertController(title: "SVPS Vadnagara".localized(""), message: str_Msg, preferredStyle: .alert)

                            // Create the actions
                            let okAction = UIAlertAction(title: "Ok".localized(""), style: UIAlertAction.Style.default) {
                                    UIAlertAction in
                                NSLog("OK Pressed")
                                self.navigationController?.popViewController(animated: true)

                            }
                            // Add the actions
                            alertController.addAction(okAction)
                            // Present the controller
                            self.present(alertController, animated: true, completion: nil)
                            //****************************//
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
    func CallAPIForUpdateProfilewithProfilePicture(_ dicPARAMS: Dictionary<String,String> = [:], filename: String) {
        
        ShowProgressHud(message: "please wait...".localized(""))
        
        print(URL_AddUpdateMatrimonial, dicPARAMS)
        
        ServiceCustom.shared.requestMultipleImageWithUrlAndParameters(api_url: URL_AddUpdateMatrimonial, params: dicPARAMS, image1: self.SelectPhoto1, image2: self.SelectPhoto2, imag1: self.is_ChangePhoto1, imag2: self.is_ChangePhoto2, janmasharFile: self.isJanmashar, urlBase2: self.janmasharFilePath, namePDF: filename, completion: { (request, response, jsonObj, dataa) in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let dicUserData = dictResult["data"] as? NSDictionary {
                            
                            // Create the alert controller
                            let alertController = UIAlertController(title: "SVPS Vadnagara".localized(""), message: str_Msg, preferredStyle: .alert)
                            
                            // Create the actions
                            let okAction = UIAlertAction(title: "Ok".localized(""), style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                                self.navigationController?.popViewController(animated: true)
                                
                            }
                            // Add the actions
                            alertController.addAction(okAction)
                            // Present the controller
                            self.present(alertController, animated: true, completion: nil)
                            //****************************//
                        }
                    }
                }
            }
            
        }) { (error) in
            
        }
        
        return
        
        
        
        guard let imageData = self.SelectPhoto1.jpegData(compressionQuality: 0.75) else { return }
        
        ServiceCustom.shared.requestMultiPartWithUrlAndParameters(URL_AddUpdateMatrimonial, Method: "POST", parameters: dicPARAMS, fileParameterName: "profile_picture", fileName: "image.jpeg", fileData: imageData, mimeType: "image/jpeg", completion: { (request, response, jsonObj, dataa)  in
            
            debugPrint(jsonObj ?? [:])
            DismissProgressHud()
            
            DispatchQueue.main.async {
                
                if let dictResult = jsonObj {
                    
                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        if let dicUserData = dictResult["data"] as? NSDictionary {
                            
                            // Create the alert controller
                            let alertController = UIAlertController(title: "SVPS Vadnagara".localized(""), message: str_Msg, preferredStyle: .alert)
                            
                            // Create the actions
                            let okAction = UIAlertAction(title: "Ok".localized(""), style: UIAlertAction.Style.default) {
                                UIAlertAction in
                                NSLog("OK Pressed")
                                
                            }
                            // Add the actions
                            alertController.addAction(okAction)
                            // Present the controller
                            self.present(alertController, animated: true, completion: nil)
                            //****************************//
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
    @objc func fun_PickPassportSizePhoto(sender: UIButton) {
        self.view.endEditing(true)
        self.is_Passport = "passport_photo"
        self.openImagePicker()
    }
    
    @objc func fun_PickFullSizePhoto(sender:UIButton) {
        self.view.endEditing(true)
        self.is_Passport = "full_photo"
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
                
                if self.is_Passport == "passport_photo" {
                    self.is_ChangePhoto1 = true
                    self.SelectPhoto1 = PickedImage
                }
                else {
                    self.is_ChangePhoto2 = true
                    self.SelectPhoto2 = PickedImage
                }

                self.tblView.reloadData()
            }
            
        }
    }
    
    
    
}


// MARK: UICOllection Veiew Delegate and Datasource Method
extension EditMetromonialVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrSectionsRow.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrSectionsRow[section].numOfrows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let strKey = self.arrSectionsRow[indexPath.section].key
        let strID = self.arrSectionsRow[indexPath.section].title
        
        if strKey == "ProfileImage" {
            let cell: MetromonialProfileImageTableCell = tableView.dequeueReusableCell(withIdentifier: "MetromonialProfileImageTableCell", for: indexPath) as! MetromonialProfileImageTableCell
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.clear
            //cell.viewImgFullBG.layer.cornerRadius = cell.viewImgFullBG.frame.height/2
            //cell.viewImgPassportBG.layer.cornerRadius = cell.viewImgPassportBG.frame.height/2
            
            if is_ChangePhoto1 {
                cell.imgPassport_Profile.image = self.SelectPhoto1
            }
            else {
                let strProfile = self.dictDetail[SKDataKeys.photo.rawValue] as? String ?? ""
                if strProfile != "" {
                    cell.imgPassport_Profile.af_setImage(withURL: URL(string: strProfile)!)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        self.SelectPhoto1 = cell.imgPassport_Profile.image ?? #imageLiteral(resourceName: "user")
                    }
                }
                else {
                    self.SelectPhoto1 = #imageLiteral(resourceName: "user")
                    cell.imgPassport_Profile.image = #imageLiteral(resourceName: "user")
                }
            }
            
            if is_ChangePhoto2 {
                cell.imgFull_Profile.image = self.SelectPhoto2
            }
            else {
                let strProfile = self.dictDetail[SKDataKeys.photo_2.rawValue] as? String ?? ""
                if strProfile != "" {
                    cell.imgFull_Profile.af_setImage(withURL: URL(string: strProfile)!)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        self.SelectPhoto2 = cell.imgFull_Profile.image ?? #imageLiteral(resourceName: "user")
                    }
                }
                else {
                    self.SelectPhoto2 = #imageLiteral(resourceName: "user")
                    cell.imgFull_Profile.image = #imageLiteral(resourceName: "user")
                }
            }
            
            //UIButton Mrthod
            cell.btnUploadPassportImage.addTarget(self, action: #selector(fun_PickPassportSizePhoto(sender:)), for: UIControl.Event.touchUpInside)
            
            cell.btnUploadFullImage.addTarget(self, action: #selector(fun_PickFullSizePhoto(sender:)), for: UIControl.Event.touchUpInside)
            
            
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
        else if strKey == "Terms_Conditions" {
            let cell: TermsConditionTableCell = tableView.dequeueReusableCell(withIdentifier: "TermsConditionTableCell", for: indexPath) as! TermsConditionTableCell
            cell.selectionStyle = .none
            //cell.backgroundColor = UIColor.clear
            
            
            return cell
        }
        else {
            let cell: RegisterTableCell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableCell", for: indexPath) as! RegisterTableCell
            cell.selectionStyle = .none
            //cell.backgroundColor = UIColor.clear
            
            cell.txt_field.delegate = self
            cell.txt_field.placeholder = strID
            cell.txt_field.selectedTitle = strID
            
            if strKey == SKDataKeys.janmakshar.rawValue {
                cell.txt_field.text = (self.dictDetail[strKey] as? String ?? "")
            }
            else {
                cell.txt_field.text = (self.dictDetail[strKey] as? String ?? "").capitalized
            }
            
            cell.txt_field.accessibilityHint = strKey
            cell.txt_field.accessibilityIdentifier = strKey
            
            if strKey == SKDataKeys.email.rawValue {
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .emailAddress
            }
            else if strKey == SKDataKeys.contact.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.mobile_guardian.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.pincode.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.annual_income.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.annual_income_family.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.many_brothers.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.married_brothers.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.many_sisters.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
            }
            else if strKey == SKDataKeys.married_sisters.rawValue {
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
            else if strKey == SKDataKeys.mangal_shani.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.inputView = pickerForGender
                pickerForGender.selectRow(0, inComponent: 0, animated: true)
                pickerForGender.reloadAllComponents()
                
                self.completionMangalShaniSelectedCell = {(value, success) in
                    self.dictDetail[strKey] = value
                    cell.txt_field.text = value
                }
            }
            else if strKey == SKDataKeys.horoscope.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.inputView = pickerForGender
                pickerForGender.selectRow(0, inComponent: 0, animated: true)
                pickerForGender.reloadAllComponents()
                
                self.completionHoroscopeSelectedCell = {(value, success) in
                    self.dictDetail[strKey] = value
                    cell.txt_field.text = value
                }
            }
            else if strKey == SKDataKeys.glasses_is.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.inputView = pickerForGender
                pickerForGender.selectRow(0, inComponent: 0, animated: true)
                pickerForGender.reloadAllComponents()
                
                self.completionGlassSelectedCell = {(value, success) in
                    self.dictDetail[strKey] = value
                    cell.txt_field.text = value
                }
            }
            else if strKey == SKDataKeys.house.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.inputView = pickerForGender
                pickerForGender.selectRow(0, inComponent: 0, animated: true)
                pickerForGender.reloadAllComponents()
                
                self.completionHouseSelectedCell = {(value, success) in
                    self.dictDetail[strKey] = value
                    cell.txt_field.text = value
                }
            }
                
            else if strKey == SKDataKeys.marital_status.rawValue {
                self.completionMaritalStatusSelectedCell = {(value, valueGJ, success) in
                    self.dictDetail[strKey] = value
                    self.dictDetail[SKDataKeys.marital_status_gj.rawValue] = valueGJ
                    cell.txt_field.text = value
                    self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.marital_status_gj.rawValue {
                self.completionMaritalStatusGJSelectedCell = {(value, valueGJ, success) in
                    self.dictDetail[strKey] = valueGJ
                    self.dictDetail[SKDataKeys.marital_status.rawValue] = value
                    cell.txt_field.text = valueGJ
                    self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.profession_name.rawValue {
                self.completionProfessionSelectedCell = {(value, valueGJ, profenID, success) in
                    self.dictDetail[strKey] = value
                    self.dictDetail[SKDataKeys.profession_name_gj.rawValue] = valueGJ
                    self.dictDetail[SKDataKeys.profession_id.rawValue] = profenID
                    self.dictDetail[SKDataKeys.profession_id_gj.rawValue] = profenID
                    cell.txt_field.text = value
                    self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.profession_name_gj.rawValue {
                self.completionProfessionGJSelectedCell = {(value, valueGJ, profenID, success) in
                    self.dictDetail[strKey] = valueGJ
                    self.dictDetail[SKDataKeys.profession_name.rawValue] = value
                    self.dictDetail[SKDataKeys.profession_id.rawValue] = profenID
                    self.dictDetail[SKDataKeys.profession_id_gj.rawValue] = profenID
                    cell.txt_field.text = valueGJ
                    self.tblView.reloadData()
                }
            }
            else if strKey == SKDataKeys.birth_date.rawValue {
                self.birthdatePicker.datePickerMode = .date
                self.birthdatePicker.maximumDate = Date()
                self.birthdatePicker.addTarget(self, action: #selector(datePickerDidSetectDate(_:)), for: UIControl.Event.valueChanged)
                self.didSelectedDate = {(sender) in
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "dd-MM-yyyy"
                    cell.txt_field.text = dateFormater.string(from: sender.date)
                }
                cell.txt_field.addDoneToolbar()
                cell.txt_field.inputView = self.birthdatePicker
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.rightViewMode = .always
            }
            else if strKey == SKDataKeys.birth_time.rawValue {
                self.birthdatePicker.datePickerMode = .date
                self.birthdatePicker.addTarget(self, action: #selector(dateTimePickerDidSetectTime(_:)), for: UIControl.Event.valueChanged)
                self.didSelectedTime = {(sender) in
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "HH.mm"
                    cell.txt_field.text = dateFormater.string(from: sender.date)
                }
                cell.txt_field.addDoneToolbar()
                cell.txt_field.inputView = self.birthdatePicker
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.rightViewMode = .always
            }
            else if strKey == SKDataKeys.company_phone.rawValue {
                cell.txt_field.addDoneToolbar()
                cell.txt_field.autocapitalizationType = .none
                cell.txt_field.keyboardType = .phonePad
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

extension EditMetromonialVC: UITextFieldDelegate {
    
    @IBAction func datePickerDidSetectDate(_ sender: UIDatePicker) {
        if self.didSelectedDate != nil {
            self.didSelectedDate!(sender)
        }
    }
    
    @IBAction func dateTimePickerDidSetectTime(_ sender: UIDatePicker) {
        if self.didSelectedTime != nil {
            self.didSelectedTime!(sender)
        }
    }
    
    
    
    @IBAction func DataPickerDidSetectDate(_ sender: UIDatePicker) {
        debugPrint(sender.tag)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let strID = textField.accessibilityHint {
            textField.inputView = nil
            
            if strID == SKDataKeys.janmakshar.rawValue {
                self.view.endEditing(true)
                self.documentPicker.delegate = self
                self.documentPicker.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.documentPicker.modalTransitionStyle = .crossDissolve
                self.navigationController?.present(self.documentPicker, animated: true, completion: nil)
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let strID = textField.accessibilityHint {
            textField.inputView = nil
            
            if strID == SKDataKeys.gender.rawValue {
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
            else if strID == SKDataKeys.mangal_shani.rawValue {
                self.strSelection = strID
                let eng = arr_YesNo[0].yesNo_english ?? ""
                let guj = arr_YesNo[0].yesNo_guj ?? ""
                let genderrr = "\(eng) (\(guj))"
                textField.text = genderrr
                pickerForGender.accessibilityIdentifier = strID
                textField.inputView = pickerForGender
                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                self.pickerForGender.reloadAllComponents()
            }
            else if strID == SKDataKeys.horoscope.rawValue {
                self.strSelection = strID
                let eng = arr_YesNo[0].yesNo_english ?? ""
                let guj = arr_YesNo[0].yesNo_guj ?? ""
                let genderrr = "\(eng) (\(guj))"
                textField.text = genderrr
                pickerForGender.accessibilityIdentifier = strID
                textField.inputView = pickerForGender
                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                self.pickerForGender.reloadAllComponents()
            }
            else if strID == SKDataKeys.glasses_is.rawValue {
                self.strSelection = strID
                let eng = arr_YesNo[0].yesNo_english ?? ""
                let guj = arr_YesNo[0].yesNo_guj ?? ""
                let genderrr = "\(eng) (\(guj))"
                textField.text = genderrr
                pickerForGender.accessibilityIdentifier = strID
                textField.inputView = pickerForGender
                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                self.pickerForGender.reloadAllComponents()
            }
            else if strID == SKDataKeys.house.rawValue {
                self.strSelection = strID
                let eng = arr_HomeRent[0].homeRent_english ?? ""
                let guj = arr_HomeRent[0].homeRent_guj ?? ""
                let genderrr = "\(eng) (\(guj))"
                textField.text = genderrr
                pickerForGender.accessibilityIdentifier = strID
                textField.inputView = pickerForGender
                self.pickerForGender.selectRow(0, inComponent: 0, animated: true)
                self.pickerForGender.reloadAllComponents()
            }
            else if strID == SKDataKeys.mother_name_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.mother_name.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.current_address_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.current_address.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.birth_place_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.birth_place.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
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
            else if strID == SKDataKeys.complexion_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.complexion.rawValue] as? String ?? ""
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
            else if strID == SKDataKeys.qualification_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.qualification.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
                
                
            else if strID == SKDataKeys.groom_bride_preferences_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.groom_bride_preferences.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.any_deficiency_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.any_deficiency.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }
            else if strID == SKDataKeys.current_activity_gj.rawValue {
                let strnme = self.dictDetail[SKDataKeys.current_activity.rawValue] as? String ?? ""
                if strnme != "" {
                    self.CallAPIForGetEnglishToGujarati(textField, strValue: strnme)
                }
            }

            else if strID == SKDataKeys.birth_date.rawValue {
                self.birthdatePicker.datePickerMode = .date
                self.birthdatePicker.maximumDate = Date()
                
                self.birthdatePicker.addTarget(self, action: #selector(datePickerDidSetectDate(_:)), for: UIControl.Event.valueChanged)
                
                if textField.text == "" {
                    birthdatePicker.date = Date()
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "dd-MM-yyyy"
                    textField.text = dateFormater.string(from: Date())
                }
                else {
                    if let strDate = textField.text {
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "dd-MM-yyyy"
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
            else if strID == SKDataKeys.birth_time.rawValue {
                self.birthdatePicker.datePickerMode = .time

                self.birthdatePicker.addTarget(self, action: #selector(dateTimePickerDidSetectTime(_:)), for: UIControl.Event.valueChanged)
                
                if textField.text == "" {
                    birthdatePicker.date = Date()
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "HH.mm"
                    textField.text = dateFormater.string(from: Date())
                }
                else {
                    if let strDate = textField.text {
                        let dateFormater = DateFormatter()
                        dateFormater.dateFormat = "HH.mm"
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
            else if strID == SKDataKeys.profession_name.rawValue {
                let strnme = self.dictDetail[SKDataKeys.occupation_father.rawValue] as? String ?? ""
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
            if strID == SKDataKeys.birth_date.rawValue {
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



//MARK:- textfield Delegate & Actions

extension EditMetromonialVC: UIDocumentPickerDelegate {

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        controller.dismiss(animated: true, completion: nil)
        self.isJanmashar = true
        self.janmasharFilePath = url
        let theFileName = url.lastPathComponent
        dictDetail[SKDataKeys.janmakshar.rawValue] = theFileName
        self.tblView.reloadData()
        print(url.absoluteString)
    }
}
