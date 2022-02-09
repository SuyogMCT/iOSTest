//
//  TopBar_V.swift
//  iOSTest
//
//  Created by Suyog Dubey on 07/02/22.
//

import UIKit

class TopBar_V: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = CCViewBackground.applicationMainBG.setColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = CCViewBackground.applicationMainBG.setColor()
    }
}
