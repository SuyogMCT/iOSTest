//
//  UserListViewModel.swift
//  iOSTest
//
//  Created by Suyog Dubey on 08/02/22.
//

import UIKit

class UserListViewModel {
    
    weak var UserList_VC_Obj : UserList_VC?
    var UserList_Array = [UserListModel]()
    
    /**************************************************************************/
    //MARK:-  Api Call :- Get Users List
    /**************************************************************************/
    
    func GetUsersList_APICall(_ dictParameter:NSMutableDictionary)
    {
        let API_URL = APPDELEGATE.strBase_URL + "?since=" + (dictParameter.GotValue(key: "since") as String)
        
        print("URL : \(API_URL)")
        
        var request = URLRequest(url: URL(string: API_URL)!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { [self] data, response, error in
            
            if error == nil {
                if let data = data {
                    do {
                        
                        let userResponse = try JSONDecoder().decode([UserListModel].self, from: data)
                        self.UserList_Array.append(contentsOf: userResponse)
                        
                        // Save data on core data
                        DataBaseHelper.shareInstant.SaveData(object: self.UserList_Array)                        
                        
                        UserList_VC_Obj?.GetAndShowData()
                        
                    } catch let err {
                        
                        print(err.localizedDescription)
                        UserList_VC_Obj?.ShowAPIMessage("Oops! something went wrong" as String)
                    }
                } else {
                    
                    UserList_VC_Obj?.ShowAPIMessage("Oops! something went wrong" as String)
                }
            } else {
                
                UserList_VC_Obj?.ShowAPIMessage("Oops! something went wrong" as String)
            }
        })
        
        task.resume()
    }
}
