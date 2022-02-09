//
//  Utility.swift
//  Noyo
//
//  Created by Retina on 06/08/18.
//  Copyright © 2018 Pavan. All rights reserved.
//

import Foundation
import UIKit

enum CCViewBackground: String {
    
    case applicationMainBG = "#17181a"
    case statusBarBG = "#948200"
    case findFriendBottomOuterBG = "#1a1b1e"
    case findFriendBottonInnerBG = "#26292e"
    case contactBG = "#2b2b2c"
    case chatViewBG = "#ffffff"
    case stripBG = "#202227"
    case pageIndicator = "#66696e"
    case pageIndicatorSelected = "#e4c90a"
        
    func setColor() -> UIColor {
        return UIColor(hexFromString:self.rawValue)
    }
}

extension UIColor {
    
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageWithUrl(_ url: URL) {

        var imageURL: URL?
        let activityIndicator = UIActivityIndicatorView()
        
        // setup activityIndicator...
        activityIndicator.color = .darkGray

        self.addSubview(activityIndicator)
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        imageURL = url

        self.image = nil
        activityIndicator.startAnimating()

        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {

            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }

        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in

            if error != nil {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    activityIndicator.stopAnimating()
                })
                return
            }

            DispatchQueue.main.async(execute: {

                if let unwrappedData = data, let imageToCache = UIImage(data: unwrappedData) {

                    if imageURL == url {
                        self.image = imageToCache
                    }

                    imageCache.setObject(imageToCache, forKey: url as AnyObject)
                }
                activityIndicator.stopAnimating()
            })
        }).resume()
    }
}

class Toast {
    
    static func show(message: String, controller: UIViewController) {
        
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = #colorLiteral(red: 0.3534786999, green: 0.3337596655, blue: 0.3043811321, alpha: 1)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(10.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -95)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
}

var container: UIView = UIView()
var loadingView: UIView = UIView()
var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

/*
 Show customized activity indicator,
 actually add activity indicator to passing view
 
 @param uiView - add activity indicator to this view
 */
func showActivityIndicator(uiView: UIView) {
    container.frame = uiView.frame
    container.center = uiView.center
    container.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
        
    loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
    loadingView.center = uiView.center
    loadingView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
    activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
    activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    uiView.addSubview(container)
    activityIndicator.startAnimating()
}

func showActivityIndicatorWithMSG(message: String, uiView: UIView) {
    container.frame = uiView.frame
    container.center = uiView.center
    container.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.5)
    
    loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
    loadingView.center = uiView.center
    loadingView.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.6)
    loadingView.clipsToBounds = true
    loadingView.layer.cornerRadius = 10
    
    activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
    activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
    activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
    
    let msg_LB = UILabel(frame: CGRect(x: 10.0, y: (activityIndicator.frame.origin.y+70.0), width: (CurrentDevice.ScreenWidth-20), height: 50.0))
    msg_LB.textColor = UIColor.white
    msg_LB.textAlignment = .center;
    msg_LB.font.withSize(10.0)
    msg_LB.text = message
    msg_LB.clipsToBounds  =  true
    msg_LB.numberOfLines = 0
    
    loadingView.addSubview(msg_LB)
    
    loadingView.addSubview(activityIndicator)
    container.addSubview(loadingView)
    uiView.addSubview(container)
    activityIndicator.startAnimating()
}

/*
 Hide activity indicator
 Actually remove activity indicator from its super view
 
 @param uiView - remove activity indicator from this view
 */
func hideActivityIndicator(uiView: UIView) {
    activityIndicator.stopAnimating()
    container.removeFromSuperview()
}

// MARK: - Validation
struct Valid {
    
    static let MAX_Length_Search: Int = 500
    
    static let CHARACTERS_Search = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
}


let APPDELEGATE = UIApplication.shared.delegate as! AppDelegate

struct CurrentDevice {
    
    // iDevice detection code
    static let IS_IPAD               = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_IPHONE             = UIDevice.current.userInterfaceIdiom == .phone
    static let IS_RETINA             = UIScreen.main.scale >= 2.0
    
    static let SCREEN_WIDTH          = Int(UIScreen.main.bounds.size.width)
    static let SCREEN_HEIGHT         = Int(UIScreen.main.bounds.size.height)
    static let SCREEN_MAX_LENGTH     = Int( max(SCREEN_WIDTH, SCREEN_HEIGHT) )
    static let SCREEN_MIN_LENGTH     = Int( min(SCREEN_WIDTH, SCREEN_HEIGHT) )
    
    static let IS_IPHONE_6_OR_HIGHER = IS_IPHONE && SCREEN_MAX_LENGTH  > 568
    static let IS_IPHONE_6           = IS_IPHONE && SCREEN_MAX_LENGTH == 667
    static let IS_IPHONE_6P          = IS_IPHONE && SCREEN_MAX_LENGTH == 736
    static let IS_IPHONE_X           = IS_IPHONE && SCREEN_MAX_LENGTH == 812
    static let IS_IPHONE_X_OR_HIGHER = IS_IPHONE && SCREEN_MAX_LENGTH  > 812
    static let IS_IPHONE_X_OR_LOWER  = IS_IPHONE && SCREEN_MAX_LENGTH  < 812
    
    static let IS_IPHONE_4_OR_LESS   = IS_IPHONE && SCREEN_MAX_LENGTH  < 568
    static let IS_IPHONE_5_OR_LESS   = IS_IPHONE && SCREEN_MAX_LENGTH <= 568
    
    // MARK: - Singletons
    static var ScreenWidth: CGFloat {
        struct Singleton {
            static let width = UIScreen.main.bounds.size.width
        }
        return Singleton.width
    }
    
    static var ScreenHeight: CGFloat {
        struct Singleton {
            static let height = UIScreen.main.bounds.size.height
        }
        return Singleton.height
    }
}

extension NSDictionary {
    func GotValue(key : String)-> NSString {
        
        if self[key] != nil {
            
            if((self["\(key)"] as? NSObject) != nil && (key .isEmpty) == false) {
                
                let obj_value = self["\(key)"] as? NSObject
                
                let str = NSString(format:"%@", obj_value!)
                
                if str == "<null>" || str == "undefined" || str == "null" {
                    
                    return ""
                }
                
                return str
            }
        }
        
        return ""
    }
}
