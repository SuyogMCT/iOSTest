//
//  UserList_VC.swift
//  iOSTest
//
//  Created by Suyog Dubey on 07/02/22.
//

import UIKit
import CoreData

class UserList_VC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var TBL_Info: UITableView!
    @IBOutlet weak var BTN_LoadMore: UIButton!
    @IBOutlet weak var TF_Search: UITextField!
    
    var sinceVal: Int = 0
    
    var mainArray: NSMutableArray = NSMutableArray()
    var jsonArray: NSMutableArray = NSMutableArray()
    var SelectedUserData_Dict: NSMutableDictionary = NSMutableDictionary()
    
    var UserListViewModel_Obj = UserListViewModel()
    var UserDetailsViewModel_Obj = UserDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = CCViewBackground.applicationMainBG.setColor()
        
        TBL_Info.delegate = self
        TBL_Info.dataSource = self
        TBL_Info.separatorStyle = .none
        TBL_Info.backgroundColor = .clear
        TBL_Info.register(UINib(nibName: "UserList_TBL_Cell", bundle: nil), forCellReuseIdentifier: "UserList_TBL_Cell")
        TBL_Info.reloadData()
        
        BTN_LoadMore.isHidden = true
        
        TF_Search.delegate = self
        TF_Search.layer.cornerRadius = 10.0
        TF_Search.layer.borderWidth = 1.0
        TF_Search.layer.borderColor = UIColor.lightGray.cgColor
        TF_Search.clipsToBounds = true
        TF_Search.attributedPlaceholder = NSAttributedString(string: "Search",
                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])

        let Search_TFLV_BTN = UIButton(type: .custom)
        Search_TFLV_BTN.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        Search_TFLV_BTN.imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        Search_TFLV_BTN.setImage(UIImage(named: "search"), for: .normal)
        Search_TFLV_BTN.tintColor = UIColor.lightGray
        TF_Search.leftView = Search_TFLV_BTN
        TF_Search.leftViewMode = .always
        
        addDoneButtonOnKeyboard()
        
        TF_Search.addTarget(self, action: #selector(AppliedSearch), for: .allEditingEvents)
        
        GetUsersList_InvokeAPI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UserListViewModel_Obj.UserList_VC_Obj = self
        UserDetailsViewModel_Obj.UserDetailsList_VC_Obj = self
        
        // Get data from DB
        GetAndShowData()
    }
    
    /**************************************************************************/
    //MARK:-  Search
    /**************************************************************************/
    
    @objc func AppliedSearch() {
        
        self.BTN_LoadMore.isHidden = true
        
        let resultPredicate = NSPredicate(format: "login contains[c]%@", TF_Search.text ?? "")
        jsonArray = NSMutableArray(array: mainArray.filtered(using: resultPredicate))
        
        if TF_Search.text == "" {
            
            jsonArray = NSMutableArray(array: mainArray)
        }
        
        TBL_Info.reloadData()
    }
    
    /**************************************************************************/
    //MARK:-  Load more
    /**************************************************************************/
    
    @IBAction func btnLoadMoreClick(_ sender: Any) {
     
        sinceVal = sinceVal + 1
        
        self.GetUsersList_InvokeAPI()
    }
    
    /**************************************************************************/
    //MARK:-  ApI Call GetUsersList
    /**************************************************************************/

    func GetUsersList_InvokeAPI() {
        
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available", controller: self)
         
            // Get data from DB
            GetAndShowData()
            
        } else {
            
            showActivityIndicator(uiView: self.view)
            
            let Parameter = NSMutableDictionary()
            Parameter.setValue(sinceVal, forKey: "since")
            
            UserListViewModel_Obj.GetUsersList_APICall(Parameter)
            
            return
        }
    }
    
    func GetAndShowData() {
        
        DispatchQueue.main.async {
            hideActivityIndicator(uiView: self.view)
            
            // Get data from core data
            if let localArray: NSMutableArray = DataBaseHelper.shareInstant.GetData() as? NSMutableArray {
                
                self.mainArray = NSMutableArray(array: localArray)
                self.jsonArray = NSMutableArray(array: localArray)
            }
            
            self.TBL_Info.reloadData()
        }
    }
    
    /**************************************************************************/
    //MARK:-  ApI Call GetUserDetails
    /**************************************************************************/

    func GetUserDetails_InvokeAPI(usernameVal: String) {
        
        let reachability = Reachability()!
        if !reachability.isReachable
        {
            Toast.show(message: "No internet available", controller: self)
            
        } else {
            
            showActivityIndicator(uiView: self.view)
            
            let Parameter = NSMutableDictionary()
            Parameter.setValue(usernameVal, forKey: "username")
            
            UserDetailsViewModel_Obj.GetUserDetails_APICall(Parameter)
            
            return
        }
    }
    
    func GetUserDetails(userDetails: UserDetailsModel) {
        
        DispatchQueue.main.async {
         
            hideActivityIndicator(uiView: self.view)
            
            self.SelectedUserData_Dict = NSMutableDictionary()
            self.SelectedUserData_Dict.setValue(userDetails.login, forKey: "login")
            self.SelectedUserData_Dict.setValue(userDetails.avatar_url, forKey: "avatar_url")
            self.SelectedUserData_Dict.setValue(userDetails.name, forKey: "name")
            self.SelectedUserData_Dict.setValue(userDetails.followers, forKey: "followers")
            self.SelectedUserData_Dict.setValue(userDetails.following, forKey: "following")
            self.SelectedUserData_Dict.setValue(userDetails.company, forKey: "company")
            self.SelectedUserData_Dict.setValue(userDetails.blog, forKey: "blog")
            self.SelectedUserData_Dict.setValue("", forKey: "notes")
            
            self.performSegue(withIdentifier: "seg_UserDetails_VC", sender: self)
        }
    }
    
    func ShowAPIMessage(_ message : String) {
        hideActivityIndicator(uiView: self.view)
        
        Toast.show(message: message, controller: self)
    }
    
    /**************************************************************************/
    //MARK:- Keyboard /////////////////////////////////
    /**************************************************************************/
    
    // Mark :- Done text file method
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        TF_Search.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        TF_Search.resignFirstResponder();
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        CloseKeyBoard()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == TF_Search {
            
            let cs = NSCharacterSet(charactersIn: Valid.CHARACTERS_Search).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")

            if (string == filtered) {
                
                return (textField.text?.count ?? 0) + (string.count - range.length) <= Valid.MAX_Length_Search
                
            } else {
                
                return false
            }
            
        } else {
            
            return true
        }
    }
    
    func CloseKeyBoard() {
        
        self.view.endEditing(true)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "seg_UserDetails_VC" {
            
            let destinationController = segue.destination as! UserDetails_VC
            destinationController.SelectedUserData_Dict = NSMutableDictionary(dictionary: SelectedUserData_Dict)
        }
    }
}

// Table view
extension UserList_VC {
    
    func numberOfSections(in tableView: UITableView) -> Int {
     
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return jsonArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserList_TBL_Cell", for: indexPath) as? UserList_TBL_Cell else { return UITableViewCell() }
        
        cell.contentView.backgroundColor = .clear
        cell.backgroundColor = .clear
        
        cell.IV_Note.isHidden = true
        
        if let LocalDict : NSDictionary = jsonArray.object(at: indexPath.row) as? NSDictionary {
            
            // unwrapped url safely...
            if let strUrl = (LocalDict.GotValue(key: "avatar_url") as String).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
               let imgUrl = URL(string: strUrl) {
                
                cell.IV_User.loadImageWithUrl(imgUrl)
            }
            
            cell.LB_Name.text = (LocalDict.GotValue(key: "login") as String)
            cell.LB_Details.text = "Details"
            
            if (LocalDict.GotValue(key: "notes") as String).count > 0 {
                
                cell.IV_Note.isHidden = false
            }
        }
        
        let reachability = Reachability()!
        
        if (indexPath.row > (jsonArray.count - 10)) && TF_Search.text == "" && reachability.isReachable {
            
            BTN_LoadMore.isHidden = false
            
        } else {
            
            BTN_LoadMore.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let LocalDict : NSDictionary = jsonArray.object(at: indexPath.row) as? NSDictionary {
            
            if (LocalDict.GotValue(key: "notes") as String).count > 0 {
                
                SelectedUserData_Dict = NSMutableDictionary(dictionary: LocalDict)
                performSegue(withIdentifier: "seg_UserDetails_VC", sender: self)
                
            } else {
                
                GetUserDetails_InvokeAPI(usernameVal: (LocalDict.GotValue(key: "login") as String))
            }
        }
    }
}
