//
//  FamilyDetailImaeTableCell.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 03/06/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit

class FamilyDetailImaeTableCell: UITableViewCell {

    @IBOutlet weak var img_Profile: UIImageView!
    @IBOutlet weak var btn_Edit: UIButton!
    @IBOutlet weak var btn_SingleEdit: UIButton!
    @IBOutlet weak var btn_Metromonial: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
