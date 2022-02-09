//
//  UserDetailsViewModel.swift
//  iOSTest
//
//  Created by Suyog Dubey on 08/02/22.
//

import UIKit

class UserDetailsViewModel {
    
    weak var UserDetailsList_VC_Obj : UserList_VC?
    
    /**************************************************************************/
    //MARK:-  Api Call :- Get Users Details
    /**************************************************************************/
    
    func GetUserDetails_APICall(_ dictParameter:NSMutableDictionary)
    {
        let API_URL = APPDELEGATE.strBase_URL + "/" + (dictParameter.GotValue(key: "username") as String)
        
        print("URL : \(API_URL)")
        
        var request = URLRequest(url: URL(string: API_URL)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { [self] data, response, error in
            
            if error == nil {
                if let data = data {
                    do {
                        
                        let userResponse = try JSONDecoder().decode(UserDetailsModel.self, from: data)                        
                        UserDetailsList_VC_Obj?.GetUserDetails(userDetails: userResponse)
                        
                    } catch let err {
                        
                        print(err.localizedDescription)
                        UserDetailsList_VC_Obj?.ShowAPIMessage("Oops! something went wrong" as String)
                    }
                } else {
                    
                    UserDetailsList_VC_Obj?.ShowAPIMessage("Oops! something went wrong" as String)
                }
            } else {
                
                UserDetailsList_VC_Obj?.ShowAPIMessage("Oops! something went wrong" as String)
            }
        })
        
        task.resume()
    }
}
