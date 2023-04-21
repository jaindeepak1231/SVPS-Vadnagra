//
//  SideMenuHeaderView.swift
//  SVPSVadnagara
//
//  Created by Varun on 02/05/19.
//  Copyright © 2019 ivarun. All rights reserved.
//

import UIKit

class SideMenuHeaderView: UIView {
    
    @IBOutlet weak var menuItemImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    
    var headerTapAction: (() -> ())?
    
    override func awakeFromNib() {
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 1
        tapGesture.addTarget(self, action: #selector(headerTapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc func headerTapped(gestureRecognizer: UIGestureRecognizer) {
        headerTapAction?()
    }
}

