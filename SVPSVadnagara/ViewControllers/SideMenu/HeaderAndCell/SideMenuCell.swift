//
//  SideMenuCell.swift
//  SVPSVadnagara
//
//  Created by Varun on 02/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit

class SideMenuCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var cellTapAction: (() -> ())?
    
    override func awakeFromNib() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(cellTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func cellTapped(gestureRecognizer: UIGestureRecognizer) {
        cellTapAction?()
    }
    
}
