//
//  SearchDetailVC.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 29/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit

class SearchDetailVC: UIViewController {

    var arr_SearchDetailData = [SearchListData]()
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Family"
        self.navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
        self.navigationController?.navigationBar.tintColor = .white
        
        navigationItem.leftItemsSupplementBackButton = true
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        //Register Table Cell
        self.tblView.register(UINib.init(nibName: "SearchTableCell"
            , bundle: nil), forCellReuseIdentifier: "SearchTableCell")
        //*******************************************************//
    }
}


// MARK: UICOllection Veiew Delegate and Datasource Method
extension SearchDetailVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr_SearchDetailData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: SearchTableCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableCell", for: indexPath) as! SearchTableCell
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        
        let strImg = self.arr_SearchDetailData[indexPath.row].profile_picture ?? ""
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
        
        let strFName = langCode == "en" ? self.arr_SearchDetailData[indexPath.row].first_name ?? "" : self.arr_SearchDetailData[indexPath.row].first_name_gj ?? ""
        let strMName = langCode == "en" ? self.arr_SearchDetailData[indexPath.row].middle_name ?? "" : self.arr_SearchDetailData[indexPath.row].middle_name_gj ?? ""
        let strLName = langCode == "en" ? self.arr_SearchDetailData[indexPath.row].last_name ?? "" : self.arr_SearchDetailData[indexPath.row].last_name_gj ?? ""
        let strName = "\(strFName) \(strMName) \(strLName)"
        cell.lbl_Name.text = strName
        
        cell.lbl_Mobile.text = langCode == "en" ?  self.arr_SearchDetailData[indexPath.row].relation ?? "" : self.arr_SearchDetailData[indexPath.row].relation_gj ?? ""
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == (tableView.numberOfSections - 1){
            return 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objProfile = self.storyboard?.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        objProfile.isScreenFrom = "Another_Profile"
        objProfile.dicListData = self.arr_SearchDetailData[indexPath.row]
        self.navigationController?.pushViewController(objProfile, animated: true)
    }
}
