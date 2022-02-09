//
//  UserList_TBL_Cell.swift
//  iOSTest
//
//  Created by Suyog Dubey on 07/02/22.
//

import UIKit

class UserList_TBL_Cell: UITableViewCell {

    @IBOutlet var V_BG: UIView!
    
    @IBOutlet var IV_User: UIImageView!
    @IBOutlet var IV_Note: UIImageView!
    @IBOutlet var LB_Name: UILabel!
    @IBOutlet var LB_Details: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        IV_User.layer.cornerRadius = 10
        IV_User.layer.masksToBounds = true
        IV_User.layer.cornerRadius = 40.0
        
        LB_Name.numberOfLines = 0
        LB_Details.numberOfLines = 0
        
        LB_Name.adjustsFontSizeToFitWidth = true
        LB_Details.adjustsFontSizeToFitWidth = true
        
        V_BG.backgroundColor = UIColor(red: (10.0/255.0), green: (10.0/255.0), blue: (10.0/255.0), alpha: 1.0)
        V_BG.layer.cornerRadius = 10
        V_BG.layer.masksToBounds = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
