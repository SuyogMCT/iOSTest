//
//  Back_BTN.swift
//  Noyo
//
//  Created by Retina on 10/08/18.
//  Copyright © 2018 Pavan. All rights reserved.
//

import UIKit

class Back_BTN: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setImage(UIImage(named: "Back"), for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 8)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setImage(UIImage(named: "Back"), for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.contentEdgeInsets = UIEdgeInsets(top: 14, left: 24, bottom: 14, right: 8)
    }
    
}
