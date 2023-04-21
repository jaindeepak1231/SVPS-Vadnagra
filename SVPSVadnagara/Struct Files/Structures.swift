//
//  Structures.swift
//  xkeeper
//
//  Created by Zignuts Technolab on 07/08/18.
//  Copyright © 2018 Zignuts Technolab. All rights reserved.
//

import Foundation
import UIKit



//MARK:- Get Gender data

struct GenderData: Decodable {
    var data: [GenderListData]?
}

struct GenderListData: Decodable {
    var gender_guj: String?
    var gender_english: String?
}

//*******//


//MARK:- Get Yes No data

struct YESNOData: Decodable {
    var data: [YESNOListData]?
}

struct YESNOListData: Decodable {
    var yesNo_guj: String?
    var yesNo_english: String?
}

//*******//

//MARK:- Get Home Rent data

struct HomeRentData: Decodable {
    var data: [HomeRentListData]?
}

struct HomeRentListData: Decodable {
    var homeRent_guj: String?
    var homeRent_english: String?
}

//*******//


//MARK:- Get Blood Group data

struct BloodGroupData: Decodable {
    var data: [BloodGroupListData]?
}

struct BloodGroupListData: Decodable {
    var blood_group: String?
}

//*******//


//MARK:- Get Country Code data

struct CounryCodeData: Decodable {
    var data: [CountryCodeListData]?
}

struct CountryCodeListData: Decodable {
    var country_code: Int?
    var country_name: String?
}

//*******//

//MARK:- Get Relation data

struct RelationData: Decodable {
    var data: [RelationListData]?
}

struct RelationListData: Decodable {
    var relation_guj: String?
    var relation_english: String?
}

//*******//



//MARK:- Get Relation data

struct MaritalData: Decodable {
    var data: [MaritalListData]?
}

struct MaritalListData: Decodable {
    var marital_status_guj: String?
    var marital_status_eng: String?
}

//*******//

//MARK:- Get Relation data

struct PoleData: Decodable {
    var data: [PoleListData]?
}

struct PoleListData: Decodable {
    var pole_id: String?
    var pole_name: String?
    var pole_name_gj: String?
}

//*******//

//MARK:- Get Relation data

struct ShakhData: Decodable {
    var data: [ShakhListData]?
}

struct ShakhListData: Decodable {
    var saakh_id: String?
    var saakh_name: String?
    var saakh_name_gj: String?
}

//*******//


//MARK:- Get City data

struct CityData: Decodable {
    var data: [CityListData]?
}

struct CityListData: Decodable {
    var city_id: String?
    var city_name: String?
    var city_name_gj: String?
}

//*******//


//MARK:- Get Country data

struct CountryData: Decodable {
    var data: [CountryListData]?
}

struct CountryListData: Decodable {
    var country_id: String?
    var country_name: String?
    var country_name_gj: String?
}

//*******//


//MARK:- Get Profession data

struct ProfessionData: Decodable {
    var data: [ProfessionListData]?
}

struct ProfessionListData: Decodable {
    var profession_id: String?
    var profession_name: String?
    var profession_name_gj: String?
}

//*******//


//MARK:- Get Business data

struct BusinessData: Decodable {
    var data: [BusinessListData]?
}

struct BusinessListData: Decodable {
    var business_id: String?
    var business_name: String?
    var business_name_gj: String?
}

//*******//




//MARK:- Get Business data

struct SearchData: Decodable {
    var data: [SearchListData]?
}

struct SearchListData: Decodable {
    var address: String?
    var address_gj: String?
    var area: String?
    var area_gj: String?
//    var birthdate: String?
//    var blood_group: String?
//    var business_type_name: String?
//    var business_type_name_gj: String?
    var city: String?
    var city_gj: String?
//    var company_address: String?
//    var company_address_gj: String?
//    var company_name: String?
//    var company_name_gj: String?
//    var company_phone: String?
    var country: String?
    var country_gj: String?
    var country_code: String?
//    var country_gj: String?
    var eduction: String?
    var eduction_gj: String?
//    var email: String?
//    var familyMember: String?
    var first_name: String?
    var first_name_gj: String?
    var middle_name: String?
    var middle_name_gj: String?
    var gender: String?
//    var hobbies: String?
//    var hobbies_gj: String?
    var last_name: String?
    var last_name_gj: String?
    var marital_status: String?
    var marital_status_gj: String?
    
    var mobile: String?
    var profile_picture: String?
    var relation: String?
    var relation_gj: String?
    var pincode: String?
    var pole_name: String?
    var pole_name_gj: String?
    var position: String?
//    var position_gj: String?
//    var previous_saakh: String?
//    var previous_saakh_gj: String?
//    var profession_name: String?
//    var profession_name_gj: String?
//    var reference: String?
//    var relation: String?
//    var relation_gj: String?
    var saakh: String?
    var saakh_name_gj: String?
    var telephone: String?
//    //var user_id: String?
//    var username: String?
    
    
}



//*******//


//MARK:- Get Family data

struct FamilyData: Decodable {
    var data: [FamilyListData]?
}

struct FamilyListData: Decodable {
    var address: String?
    var address_gj: String?
    var area: String?
    var area_gj: String?
    var birthdate: String?
    var blood_group: String?
    var business_type_name: String?
    var business_type_name_gj: String?
    var city: String?
    var city_gj: String?
    var company_address: String?
    var company_address_gj: String?
    var company_name: String?
    var company_name_gj: String?
    var company_phone: String?
    var country: String?
    var country_gj: String?
    var country_code: String?
    var eduction: String?
    var eduction_gj: String?
    var email: String?
    var first_name: String?
    var first_name_gj: String?
    var middle_name: String?
    var middle_name_gj: String?
    var gender: String?
    var hobbies: String?
    var hobbies_gj: String?
    var last_name: String?
    var last_name_gj: String?
    var marital_status: String?
    var marital_status_gj: String?
    var country_id: String?
    var mobile: String?
    var profile_picture: String?
    var relation: String?
    var relation_gj: String?
    var pincode: String?
    var pole_name: String?
    var pole_name_gj: String?
    var position: String?
    var position_gj: String?
    var previous_saakh: String?
    var previous_saakh_gj: String?
    var profession_name: String?
    var profession_name_gj: String?
    var saakh: String?
    var saakh_name_gj: String?
    var telephone: String?
    var other_business_type_name: String?
    var other_business_type_name_gj: String?
    var user_id: String?
    var action : Int?
    var reference: String?
    var business_type_id: String?
    var business_type_id_gj: String?
    var profession_id: String?
    var profession_id_gj: String?
    var country_id_gj: String?
    var city_id: String?
    var city_id_gj: String?
    var pole_id: String?
    var pole_id_gj: String?
    var saakh_id: String?
    var saakh_id_gj: String?
    var previous_saakh_id: String?
    var previous_saakh_id_gj: String?
    var matrimonial_id: String?
    
    
    
    //    var username: String?
    
    
}
//*******//






//MARK:- Get Family data

struct MetromialData: Decodable {
    var data: MetromonialListData?
}

struct MetromonialListData: Decodable {
    //var membership_id: Int?
    //var family_member_id: Int?
    var first_name: String?
    var first_name_gj: String?
    var middle_name: String?
    var middle_name_gj: String?
    var last_name: String?
    var last_name_gj: String?
    var contact: String?
    var gender: String?
    var saakh: String?
    var saakh_name_gj: String?
    var mother_name: String?
    var mother_name_gj: String?
    var current_address: String?
    var current_address_gj: String?
    var mobile_guardian: String?
    var birth_date: String?
    var birth_time: String?
    var mangal_shani: String?
    var birth_place: String?
    var birth_place_gj: String?
    var height: String?
    var weight: String?
    var complexion: String?
    var complexion_gj: String?
    var blood_group: String?
    var horoscope: String?
    var hobbies: String?
    var hobbies_gj: String?
    var groom_bride_preferences: String?
    var groom_bride_preferences_gj: String?
    var qualification: String?
    var qualification_gj: String?
    var any_deficiency: String?
    var any_deficiency_gj: String?
    var current_activity: String?
    var current_activity_gj: String?
    var profession: String?
    var profession_gj: String?
    var profession_name: String?
    var profession_name_gj: String?
    var marital_status: String?
    var marital_status_gj: String?
    var annual_income: String?
    var annual_income_family: String?
    var occupation_father: String?
    var occupation_mother: String?
    var married_brothers: String?
    var many_sisters: String?
    var married_sisters: String?
    var mosad_details: String?
    var witness_name: String?
    var janmakshar: String?
    var photo: String?
    var photo_2: String?
    var glasses_is: String?
    var house: String?
    var many_brothers: String?
    var requirement: String?
    var reference: String?
    
    /*var glasses_is: String?
    var house: String?
    
    var many_brothers : Int?
    
    
    
    //var status: Int?
    var approved_date: String?*/
 
}
//*******//
