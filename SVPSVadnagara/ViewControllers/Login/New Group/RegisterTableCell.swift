//
//  RegisterTableCell.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 22/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterTableCell: UITableViewCell {
    
    @IBOutlet weak var txt_field: SkyFloatingLabelTextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
