//
//  App_BTN.swift
//  SLATransit
//
//  Created by apple on 3/23/21.
//  Copyright © 2021 Maitrey. All rights reserved.
//

import UIKit

class App_BTN: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.orange
        setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        layer.cornerRadius = 25
        layer.masksToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.orange
        setTitleColor(.black, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        layer.cornerRadius = 25
        layer.masksToBounds = false
    }
}
