//
//  UserDetails_VC.swift
//  iOSTest
//
//  Created by Suyog Dubey on 07/02/22.
//

import UIKit

class UserDetails_VC: UIViewController, UITextViewDelegate {

    @IBOutlet var SV_Info: UIScrollView!
    @IBOutlet var IV_User: UIImageView!
    @IBOutlet var LB_Name: UILabel!
    @IBOutlet var LB_Followers: UILabel!
    @IBOutlet var LB_Following: UILabel!
    @IBOutlet var LB_Company: UILabel!
    @IBOutlet var LB_Blog: UILabel!
    @IBOutlet var TV_Notes: UITextView!
    
    var SelectedUserData_Dict: NSMutableDictionary = NSMutableDictionary()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        SV_Info.contentSize = CGSize(width: CurrentDevice.ScreenWidth, height: 620.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = CCViewBackground.applicationMainBG.setColor()
        
        LB_Name.numberOfLines = 0
        LB_Name.adjustsFontSizeToFitWidth = true
        
        IV_User.layer.cornerRadius = 10
        IV_User.layer.masksToBounds = true
        IV_User.layer.cornerRadius = 15.0
        
        LB_Followers.numberOfLines = 0
        LB_Following.numberOfLines = 0
        
        LB_Followers.adjustsFontSizeToFitWidth = true
        LB_Following.adjustsFontSizeToFitWidth = true
        
        LB_Company.numberOfLines = 0
        LB_Company.adjustsFontSizeToFitWidth = true
        
        LB_Blog.numberOfLines = 0
        LB_Blog.adjustsFontSizeToFitWidth = true
        
        TV_Notes.delegate = self
        TV_Notes.layer.cornerRadius = 15.0
        TV_Notes.isScrollEnabled = false
        TV_Notes.textContainerInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        SV_Info.contentSize = CGSize(width: CurrentDevice.ScreenWidth, height: 620.0)
        
        addDoneButtonOnKeyboard()
        GetAndShowData()
    }

    func GetAndShowData() {
        
        LB_Name.text = (SelectedUserData_Dict.GotValue(key: "name") as String)
        LB_Followers.text = "Followers ( " + (SelectedUserData_Dict.GotValue(key: "followers") as String) + " )"
        LB_Following.text = "following ( " + (SelectedUserData_Dict.GotValue(key: "following") as String) + " )"
        LB_Company.text = (SelectedUserData_Dict.GotValue(key: "company") as String)
        LB_Blog.text = (SelectedUserData_Dict.GotValue(key: "blog") as String)
        TV_Notes.text = (SelectedUserData_Dict.GotValue(key: "notes") as String)
        
        // unwrapped url safely...
        if let strUrl = (SelectedUserData_Dict.GotValue(key: "avatar_url") as String).addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
           let imgUrl = URL(string: strUrl) {
            
            self.IV_User.loadImageWithUrl(imgUrl)
        }
    }
    
    /**************************************************************************/
    //MARK:-  Go Back Screen
    /**************************************************************************/
    
    @IBAction func btnBackClick(_ sender: Any) {
     
        self.navigationController?.popViewController(animated: true)
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
        
        TV_Notes.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        TV_Notes.resignFirstResponder();
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.SV_Info.contentInset
        contentInset.bottom = keyboardFrame.size.height + 50
        SV_Info.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        SV_Info.contentInset = contentInset
    }
    
    func CloseKeyBoard() {
        
        self.view.endEditing(true)
    }
    
    /**************************************************************************/
    //MARK:-  Save & Update
    /**************************************************************************/
    
    @IBAction func btnSaveClick(_ sender: Any) {
     
        CloseKeyBoard()
            
        if TV_Notes.text?.isEmpty ?? false {
            
            Toast.show(message: "Please write your Notes", controller: self)
            
        } else {
        
            let UpdateDict: NSMutableDictionary = NSMutableDictionary()
            
            UpdateDict.setValue((SelectedUserData_Dict.GotValue(key: "login") as String), forKey: "login")
            UpdateDict.setValue((SelectedUserData_Dict.GotValue(key: "avatar_url") as String), forKey: "avatar_url")
            UpdateDict.setValue((SelectedUserData_Dict.GotValue(key: "name") as String), forKey: "name")
            UpdateDict.setValue((SelectedUserData_Dict.GotValue(key: "followers") as String), forKey: "followers")
            UpdateDict.setValue((SelectedUserData_Dict.GotValue(key: "following") as String), forKey: "following")
            UpdateDict.setValue((SelectedUserData_Dict.GotValue(key: "company") as String), forKey: "company")
            UpdateDict.setValue((SelectedUserData_Dict.GotValue(key: "blog") as String), forKey: "blog")
            UpdateDict.setValue((TV_Notes.text ?? ""), forKey: "notes")
            
            // Save data on core data
            DataBaseHelper.shareInstant.UpdateData(dict: UpdateDict)
            
            Toast.show(message: "Successfully Updated", controller: self)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
