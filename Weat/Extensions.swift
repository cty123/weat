//
//  Extensions.swift
//  Weat
//
//  Created by admin on 2/18/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import UIKit
import FBSDKCoreKit
import SwiftyJSON

extension UIButton {
    func setup(title: String!, color: UIColor) {
        // set attributes
        self.setTitle(title, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = color
    }
}

extension UISegmentedControl {
    func setup (segmentNames: [String], color: UIColor) {
        // start from cratch
        self.removeAllSegments()
        
        // add segmenets
        var i = 0
        for title in segmentNames {
            self.insertSegment(withTitle: title, at: i, animated: false)
            i = i + 1
        }
        
        // update color
        self.tintColor = color
        
        // select first box
        self.selectedSegmentIndex = 0
    }
}


extension UIView {
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addFullWidthBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: (self.superview?.frame.size.width)!, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImageView {
    
    func setFacebookProfilePicture(facebook_link: String) {
        FBSDKGraphRequest(graphPath: facebook_link, parameters: ["fields": "name, location, picture.type(large)"]).start(completionHandler: { (connection, result, error) -> Void in
            
            if (error == nil) {
                // get json
                let json = JSON(result!)
                
                // get profile string profile picture
                let urlString: String = json["picture", "data", "url"].string!
                let url = URL(string: urlString)
                if let data = try? Data(contentsOf: url!) {
                    self.image = UIImage(data: data)!
                    self.layer.cornerRadius = self.frame.size.height / 2;
                    self.layer.masksToBounds = true;
                    self.layer.borderWidth = 0;
                }
                
            } else {
                print("File: \(#file)")
                print("Line: \(#line)")
            }
        })
        
    }
    

}
