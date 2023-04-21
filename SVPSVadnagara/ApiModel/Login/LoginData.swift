/* 
Copyright (c) 2019 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct LoginData : Mappable {
	var user_id : String?
	var membership_no : String?
	var user_roll_id : String?
	var parent_id : String?
	var relation : String?
	var relation_gj : String?
	var pole_id : String?
	var pole_name : String?
	var pole_id_gj : String?
	var pole_name_gj : String?
	var saakh_id : String?
	var saakh : String?
	var saakh_id_gj : String?
	var saakh_name_gj : String?
	var previous_saakh_id : String?
	var previous_saakh : String?
	var previous_saakh_id_gj : String?
	var previous_saakh_gj : String?
	var first_name : String?
	var first_name_gj : String?
	var middle_name : String?
	var middle_name_gj : String?
	var last_name : String?
	var last_name_gj : String?
	var country_code : String?
	var mobile : String?
	var city_id : String?
	var city : String?
	var city_id_gj : String?
	var city_gj : String?
	var address : String?
	var address_gj : String?
	var area : String?
	var area_gj : String?
	var pincode : String?
	var birthdate : String?
	var email : String?
	var gender : String?
	var username : String?
	var blood_group : String?
	var eduction : String?
	var eduction_gj : String?
	var profession_id : String?
	var profession_name : String?
	var profession_id_gj : String?
	var profession_name_gj : String?
	var business_type_id : String?
	var business_type_name : String?
	var business_type_id_gj : String?
	var business_type_name_gj : String?
	var other_business_type_name : String?
	var other_business_type_name_gj : String?
	var company_name : String?
	var company_name_gj : String?
	var company_address : String?
	var company_address_gj : String?
	var position : String?
	var position_gj : String?
	var reference : String?
	var hobbies : String?
	var hobbies_gj : String?
	var profile_picture : String?
	var marital_status : String?
	var marital_status_gj : String?
	var telephone : String?
	var country_id : String?
	var country : String?
	var country_id_gj : String?
	var country_gj : String?
	var company_phone : String?
	var status : String?
	var token_id : Int?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		user_id <- map["user_id"]
		membership_no <- map["membership_no"]
		user_roll_id <- map["user_roll_id"]
		parent_id <- map["parent_id"]
		relation <- map["relation"]
		relation_gj <- map["relation_gj"]
		pole_id <- map["pole_id"]
		pole_name <- map["pole_name"]
		pole_id_gj <- map["pole_id_gj"]
		pole_name_gj <- map["pole_name_gj"]
		saakh_id <- map["saakh_id"]
		saakh <- map["saakh"]
		saakh_id_gj <- map["saakh_id_gj"]
		saakh_name_gj <- map["saakh_name_gj"]
		previous_saakh_id <- map["previous_saakh_id"]
		previous_saakh <- map["previous_saakh"]
		previous_saakh_id_gj <- map["previous_saakh_id_gj"]
		previous_saakh_gj <- map["previous_saakh_gj"]
		first_name <- map["first_name"]
		first_name_gj <- map["first_name_gj"]
		middle_name <- map["middle_name"]
		middle_name_gj <- map["middle_name_gj"]
		last_name <- map["last_name"]
		last_name_gj <- map["last_name_gj"]
		country_code <- map["country_code"]
		mobile <- map["mobile"]
		city_id <- map["city_id"]
		city <- map["city"]
		city_id_gj <- map["city_id_gj"]
		city_gj <- map["city_gj"]
		address <- map["address"]
		address_gj <- map["address_gj"]
		area <- map["area"]
		area_gj <- map["area_gj"]
		pincode <- map["pincode"]
		birthdate <- map["birthdate"]
		email <- map["email"]
		gender <- map["gender"]
		username <- map["username"]
		blood_group <- map["blood_group"]
		eduction <- map["eduction"]
		eduction_gj <- map["eduction_gj"]
		profession_id <- map["profession_id"]
		profession_name <- map["profession_name"]
		profession_id_gj <- map["profession_id_gj"]
		profession_name_gj <- map["profession_name_gj"]
		business_type_id <- map["business_type_id"]
		business_type_name <- map["business_type_name"]
		business_type_id_gj <- map["business_type_id_gj"]
		business_type_name_gj <- map["business_type_name_gj"]
		other_business_type_name <- map["other_business_type_name"]
		other_business_type_name_gj <- map["other_business_type_name_gj"]
		company_name <- map["company_name"]
		company_name_gj <- map["company_name_gj"]
		company_address <- map["company_address"]
		company_address_gj <- map["company_address_gj"]
		position <- map["position"]
		position_gj <- map["position_gj"]
		reference <- map["reference"]
		hobbies <- map["hobbies"]
		hobbies_gj <- map["hobbies_gj"]
		profile_picture <- map["profile_picture"]
		marital_status <- map["marital_status"]
		marital_status_gj <- map["marital_status_gj"]
		telephone <- map["telephone"]
		country_id <- map["country_id"]
		country <- map["country"]
		country_id_gj <- map["country_id_gj"]
		country_gj <- map["country_gj"]
		company_phone <- map["company_phone"]
		status <- map["status"]
		token_id <- map["token_id"]
	}

}
