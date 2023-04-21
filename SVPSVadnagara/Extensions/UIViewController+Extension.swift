//
//  UIViewController.swift
//  FrontPage
//
//  Created by Varun on 14/07/18.
//  Copyright © 2018 ivarun. All rights reserved.
//

import Foundation
import SVProgressHUD
import Alamofire

extension UIViewController {
    
    func showProgressHUD() {
        
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.show(withStatus: "please wait...".localized(""))
        }
    }
    
    func hideProgressHUD() {
        
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    func isConnectedToInternet() {
        
        guard NetworkReachabilityManager()?.isReachable == true else {
            let alert = UIAlertController(title: "SVPS Vadnagara".localized(""), message: AlertMessages.internetNotAvailable.localized(""), preferredStyle: .alert)
            alert.addAction(title: "Ok".localized(""), style: .default, handler: nil)
            alert.present(in: self)
            return
        }
    }
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: "SVPS Vadnagara".localized(""), message: message.localized(""), preferredStyle: .alert)
        alert.addAction(title: "Ok".localized(""), style: .default, handler: nil)
        alert.present(in: self)

    }
}
