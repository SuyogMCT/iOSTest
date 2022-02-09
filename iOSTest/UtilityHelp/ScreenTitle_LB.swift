//
//  ScreenTitle_LB.swift
//  iOSTest
//
//  Created by Suyog Dubey on 07/02/22.
//

import UIKit

class ScreenTitle_LB: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textAlignment = .center
        self.font = UIFont.boldSystemFont(ofSize: 22)
        self.textColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textAlignment = .center
        self.font = UIFont.boldSystemFont(ofSize: 22)
        self.textColor = .white
    }
}
