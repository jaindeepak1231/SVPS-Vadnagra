//
//  MetromonialProfileImageTableCell.swift
//  SVPSVadnagara
//
//  Created by Deepak Jain on 04/06/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit

class MetromonialProfileImageTableCell: UITableViewCell {

    @IBOutlet weak var viewImgFullBG: UIView!
    @IBOutlet weak var viewImgPassportBG: UIView!
    @IBOutlet weak var btnUploadFullImage: UIButton!
    @IBOutlet weak var btnUploadPassportImage: UIButton!
    @IBOutlet weak var imgFull_Profile: UIImageView!
    @IBOutlet weak var imgPassport_Profile: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.viewImgFullBG.layer.cornerRadius = self.viewImgFullBG.frame.height/2
            self.viewImgPassportBG.layer.cornerRadius = self.viewImgPassportBG.frame.height/2
            self.viewImgFullBG.layer.masksToBounds = true
            self.viewImgPassportBG.layer.masksToBounds = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
