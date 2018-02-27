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
    var friend: User?
    
    @IBAction func pressDeny(_ sender: Any) {
        Friend.setFriendRequest(friend_id: (friend?.id!)!, acceptance: 2, completion: {
            (ret: Bool) in
            print("Denied friend request to \((self.friend?.name)!).")
            // TODO: Figure out how to just remove the whole cell
            self.buttonConfirm.isHidden = true
            self.buttonDeny.isHidden = true
            self.labelName.text = ""
        })
    }
    
    @IBAction func pressConfirm(_ sender: Any) {
        Friend.setFriendRequest(friend_id: (friend?.id!)!, acceptance: 1, completion: {
            (ret: Bool) in
            print("Accepted friend request to \((self.friend?.name)!).")
            // TODO: Figure out how to just remove the whole cell
            self.buttonDeny.isHidden = true
            self.buttonConfirm.isHidden = true
            self.labelName.text = ""
        })
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
