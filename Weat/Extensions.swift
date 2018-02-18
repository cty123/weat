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
        self.setTitleColor(UIColor.lightText, for: .normal)
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

