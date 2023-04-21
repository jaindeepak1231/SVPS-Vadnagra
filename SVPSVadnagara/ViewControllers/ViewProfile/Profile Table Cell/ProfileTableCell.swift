//
//  ProfileTableCell.swift
//  SVPSVadnagara
//
//  Created by Zignuts Technolab on 21/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit

class ProfileTableCell: UITableViewCell {

    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_Value: UILabel!
    @IBOutlet weak var lbl_Indicator: UILabel!
    @IBOutlet weak var constrint_lblLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lbl_Indicator.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
