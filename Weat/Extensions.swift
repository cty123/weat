//
//  Extensions.swift
//  Weat
//
//  Created by admin on 2/18/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import Foundation
import UIKit

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
