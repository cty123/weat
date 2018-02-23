//
//  FriendRequestTableViewCell.swift
//  Weat
//
//  Created by Jordan Barkley on 2/23/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class FriendRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewProfilePic: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var buttonDeny: UIButton!
    @IBOutlet weak var buttonConfirm: UIButton!
    
    //acceptance - 0 pending, 1 accept, 2 deny
    var acceptance: Int = 0
    
    @IBAction func pressDeny(_ sender: Any) {
        self.acceptance = 2
        self.buttonConfirm.isHidden = true
        self.buttonDeny.isHidden = true
        print("DENY")
    }
    
    @IBAction func pressConfirm(_ sender: Any) {
        self.acceptance = 1
        self.buttonDeny.isHidden = true
        self.buttonConfirm.isHidden = true
        print("CONFIRM")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
