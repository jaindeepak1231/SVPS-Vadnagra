//
//  RegisterImageTableCell.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 22/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit

class RegisterImageTableCell: UITableViewCell {

    @IBOutlet weak var viewImgBG: UIView!
    @IBOutlet weak var btnUploadImage: UIButton!
    @IBOutlet weak var img_Profile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.viewImgBG.layer.cornerRadius = self.viewImgBG.frame.height/2
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
