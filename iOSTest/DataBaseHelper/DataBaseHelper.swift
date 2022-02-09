//
//  DataBaseHelper.swift
//  iOSTest
//
//  Created by Suyog Dubey on 08/02/22.
//

import UIKit
import CoreData

class DataBaseHelper {
    
    static var shareInstant = DataBaseHelper()
    
    let context = APPDELEGATE.persistentContainer.viewContext
    
    /**************************************************************************/
    //MARK:- Save Data
    /**************************************************************************/
    
    func SaveData(object: [UserListModel]) {
     
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        
        for localDict in object {
            
//            if let dict : NSDictionary = localDict as? NSDictionary {
        
//                print("dict : \(dict)")
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")

//                fetchRequest.predicate = NSPredicate(format: "login = %@",
//                                                         argumentArray: [(dict.GotValue(key: "login") as String)])

                fetchRequest.predicate = NSPredicate(format: "login = %@",
                                                     argumentArray: [localDict.login ?? ""])
                
                do {
                    let results = try context.fetch(fetchRequest) as? [NSManagedObject]
                    if results?.count != 0 { // Atleast one was returned

                        // In my case, I only updated the first item in results
//                        results![0].setValue((dict.GotValue(key: "avatar_url") as String), forKey: "avatar_url")
                        results![0].setValue(localDict.avatar_url, forKey: "avatar_url")

                    } else {
                        
                        let newUser = NSManagedObject(entity: entity!, insertInto: context)
                        newUser.setValue(localDict.login, forKey: "login")
                        newUser.setValue(localDict.avatar_url, forKey: "avatar_url")
                        
//                        newUser.setValue((dict.GotValue(key: "login") as String), forKey: "login")
//                        newUser.setValue((dict.GotValue(key: "avatar_url") as String), forKey: "avatar_url")

                    }
                } catch {
                    print("Fetch Failed: \(error)")
                }
//            }
        }
        
        do {
           try context.save()
            
          } catch {
           print("Failed saving")
        }
    }
    
    /**************************************************************************/
    //MARK:- Get Data
    /**************************************************************************/
    
    func GetData() -> NSMutableArray {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            
            let retunArray: NSMutableArray = NSMutableArray()
            
            for data in result as! [NSManagedObject] {
                
//                print(data.value(forKey: "login") as! String)
                
                let localDict: NSMutableDictionary = NSMutableDictionary()
                
                if let str: String = data.value(forKey: "login") as? String {
                
                    localDict.setValue(str, forKey: "login")
                }
                
                if let str: String = data.value(forKey: "avatar_url") as? String {
                
                    localDict.setValue(str, forKey: "avatar_url")
                }
                
                if let str: String = data.value(forKey: "notes") as? String {
                
                    localDict.setValue(str, forKey: "notes")
                }
                
                if let str: String = data.value(forKey: "name") as? String {
                
                    localDict.setValue(str, forKey: "name")
                }
                
                if let str: String = data.value(forKey: "followers") as? String {
                
                    localDict.setValue(str, forKey: "followers")
                }
                
                if let str: String = data.value(forKey: "following") as? String {
                
                    localDict.setValue(str, forKey: "following")
                }
                
                if let str: String = data.value(forKey: "company") as? String {
                
                    localDict.setValue(str, forKey: "company")
                }
                
                if let str: String = data.value(forKey: "blog") as? String {
                
                    localDict.setValue(str, forKey: "blog")
                }
                
                retunArray.add(localDict)
            }
            
            return retunArray
            
        } catch {
            print("Failed")
            return NSMutableArray()
        }
    }
    
    /**************************************************************************/
    //MARK:- Update Data
    /**************************************************************************/
    
    func UpdateData(dict: NSMutableDictionary) {
     
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")

        fetchRequest.predicate = NSPredicate(format: "login = %@",
                                                 argumentArray: [(dict.GotValue(key: "login") as String)])

        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned

                // only updated the results
                results![0].setValue((dict.GotValue(key: "avatar_url") as String), forKey: "avatar_url")
                results![0].setValue((dict.GotValue(key: "name") as String), forKey: "name")
                results![0].setValue((dict.GotValue(key: "followers") as String), forKey: "followers")
                results![0].setValue((dict.GotValue(key: "following") as String), forKey: "following")
                results![0].setValue((dict.GotValue(key: "company") as String), forKey: "company")
                results![0].setValue((dict.GotValue(key: "blog") as String), forKey: "blog")
                results![0].setValue((dict.GotValue(key: "notes") as String), forKey: "notes")
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
           try context.save()
          } catch {
           print("Failed saving")
        }
    }
}
