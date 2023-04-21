//
//  Validations.swift
//  AbayaBazar
//
//  Created by iMac-4 on 7/14/17.
//  Copyright © 2017 iMac-4. All rights reserved.
//

import Foundation

open class Validator
{
    fileprivate static let defaultValidator: Validator = Validator()
    public let dateFormatter = DateFormatter()
    
    fileprivate static let
    ΕmailRegex: String = "[\\w._%+-|]+@[\\w0-9.-]+\\.[A-Za-z]{2,6}",
    ΑlphaRegex: String = "[a-zA-Z]+",
    NumericRegex: String = "[-+]?[0-9]+",
    FloatRegex: String = "([\\+-]?\\d+)?\\.?\\d*([eE][\\+-]\\d+)?",
    AlphanumericRegex: String = "[\\d[A-Za-z]]+",
    AlphanumericPlusApostropheRegex: String = "^[a-zA-Z0-9' ]*$", //OK "[a-zA-Z0-9|('|\\s)]+",
    AlphanumericPlusUnderscore: String = "[a-zA-Z0-9|_]+",
    PasswordRegex: String = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{3,15}$",
    ZipCodeRegex: String = "^\\d{5}(?:[-\\s]\\d{4})?",
    WebURLRegex: String = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?"
    
    
    /**
     checks if it is an empty string
     
     - returns: (String?)->Bool
     */
    public static var isValidString: (String?) -> Bool {
        return Validator.defaultValidator.isValidString
    }
    open var isValidString: (String?) -> Bool {
        return {
            (value: String?) in
            return value == "" || value == nil
        }
    }
    
    /**
     checks if it is an email
     
     - returns: (String?)->Bool
     */
    public static var isValidEmail: (String?) -> Bool {
        return Validator.defaultValidator.isValidEmail
    }
    open var isValidEmail: (String?) -> Bool {
        return {
            (value: String?) -> Bool in
            
            if value == "" || value == nil {
                return false
            }
            
            return self.regexValidate(Validator.ΕmailRegex, value!)
        }
    }
    
    
    /**
     checks if the value exists in the supplied array
     
     - parameter array: An array of strings
     - returns: (String?)->Bool
     */
    public static func isIn(_ array: Array<String>) -> (String?) -> Bool {
        return Validator.defaultValidator.isIn(array)
    }
    open func isIn(_ array: Array<String>) -> (String?) -> Bool {
        return {
            (value: String?) -> Bool in
            if value == "" || value == nil {
                return false
            }
            
            if let _ = array.index(of: value!) {
                return true
            } else {
                return false
            }
        }
    }
    
    
    /**
     checks if it is numeric
     
     - returns: (String?)->Bool
     */
    public static var isNumeric: (String?) -> Bool {
        return Validator.defaultValidator.isNumeric
    }
    open var isNumeric: (String?) -> Bool {
        return {
            (value: String?) in
            if value == "" || value == nil {
                return false
            }
            return self.regexValidate(Validator.NumericRegex, value!)
        }
    }
    
    
    /**
     checks if it is Alphabetics
     
     - returns: (String?)->Bool
     */
    public static var isAlphabetic: (String?) -> Bool {
        return Validator.defaultValidator.isAlphabetic
    }
    open var isAlphabetic: (String?) -> Bool {
        return {
            (value: String?) in
            if value == "" || value == nil {
                return false
            }
            return self.regexValidate(Validator.ΑlphaRegex, value!)
        }
    }
    
    
    /**
     checks if it has valid Password String
     
     - returns: (String?)->Bool
     */
    public static var isPasswordString: (String?) -> Bool {
        return Validator.defaultValidator.isPasswordString
    }
    open var isPasswordString: (String?) -> Bool {
        return {
            (value: String?) in
            if value == "" || value == nil {
                return false
            }
            return self.regexValidate(Validator.PasswordRegex, value!)
        }
    }
    
    
    /**
     checks if it is ZipCode
     
     - returns: (String?)->Bool
     */
    public static var isZipCode: (String?) -> Bool {
        return Validator.defaultValidator.isZipCode
    }
    open var isZipCode: (String?) -> Bool {
        return {
            (value: String?) in
            if value == "" || value == nil {
                return false
            }
            return self.regexValidate(Validator.ZipCodeRegex, value!)
        }
    }
    
    
    /**
     checks if it is WebSite URL String
     
     - returns: (String?)->Bool
     */
    public static var isWebSiteURL: (String?) -> Bool {
        return Validator.defaultValidator.isWebSiteURL
    }
    open var isWebSiteURL: (String?) -> Bool {
        return {
            (value: String?) in
            if value == "" || value == nil {
                return false
            }
            return self.regexValidate(Validator.WebURLRegex, value!)
        }
    }
    
    
    //MARK:- MAIN()
    fileprivate func regexValidate(_ regex: String, _ value: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: value)
    }
    
    
    
}
