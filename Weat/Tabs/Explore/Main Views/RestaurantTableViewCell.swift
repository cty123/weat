//
//  RestaurantTableViewCell.swift
//  Weat
//
//  Created by admin on 2/18/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageViewPic: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDetail: UILabel!
    @IBOutlet weak var labelRank: UILabel!
    var restaurant: Restaurant!
}

