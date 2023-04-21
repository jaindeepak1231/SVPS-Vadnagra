//
//  SearchTableCell.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 29/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit

class SearchTableCell: UITableViewCell {

    @IBOutlet weak var view_BG: UIView!
    @IBOutlet weak var lbl_Name: UILabel!
    @IBOutlet weak var lbl_Mobile: UILabel!
    @IBOutlet weak var img_Search: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
