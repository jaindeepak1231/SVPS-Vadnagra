//
//  FilterDetailTableViewCell.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 29/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class FilterDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var txtField: SkyFloatingLabelTextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
