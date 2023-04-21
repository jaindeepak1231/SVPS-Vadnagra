//
//  ForgotPasswordVC.swift
//  SVPSVadnagara
//
//  Created by Zignuts Technolab on 21/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import Alamofire
import SkyFloatingLabelTextField

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var txt_informationID: SkyFloatingLabelTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Forgot Password".localized("")
        
        self.txt_informationID.placeholder = "Information ID".localized("")
        self.txt_informationID.selectedTitle = "Information ID".localized("")
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        self.navigationController?.navigationBar.tintColor = .white

        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

        setupUI()
    }
    
    final func setupUI() {
        self.navigationController?.navigationBar.barTintColor = Constants.Color.blueColor
    }
    
    //Validations
    func validateData() -> Bool {
        if txt_informationID.text?.trim.count == 0 {
            showAlert(message: AlertMessages.informationIdEmpty.localized(""))
            return false
        }
        return true
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

        let param = ["membership_no": txt_informationID.text ?? ""]

        ShowProgressHud(message: "please wait...".localized(""))

        print(URL_ForgotPassword, param)

        ServiceCustom.shared.requestURLwithData(URL_ForgotPassword, Method: "POST", parameters: param, completion: { (request, response, jsonObj, dataa)  in

            debugPrint(jsonObj ?? [:])
            DismissProgressHud()

            DispatchQueue.main.async {

                if let dictResult = jsonObj {

                    let status = dictResult["status"] as? Int ?? 0
                    let str_Msg = dictResult["message"] as? String ?? ""
                    if status == 1 {
                        
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

}
