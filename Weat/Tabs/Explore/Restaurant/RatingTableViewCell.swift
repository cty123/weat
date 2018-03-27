//
//  RatingTableViewCell.swift
//  Weat
//
//  Created by Sean Becker on 3/26/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class RatingTableViewCell: UITableViewCell {
    // User info
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    // Rating info
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var foodRatingImage: UIImageView!
    @IBOutlet weak var serviceRatingImage: UIImageView!
    @IBOutlet weak var ratingText: UITextView!
    
    var rating: Comment?
}
