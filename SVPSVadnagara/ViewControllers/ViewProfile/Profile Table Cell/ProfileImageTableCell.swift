//
//  ProfileImageTableCell.swift
//  SVPSVadnagara
//
//  Created by Zignuts Technolab on 21/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit

class ProfileImageTableCell: UITableViewCell {

    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var btn_Edit: UIButton!
    @IBOutlet weak var constraint_btnHeight: NSLayoutConstraint!
    @IBOutlet weak var constraint_Img_Top: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
