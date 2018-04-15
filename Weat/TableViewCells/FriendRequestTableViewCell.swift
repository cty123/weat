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
    var friend: User? = nil
    
    @IBAction func pressDeny(_ sender: Any) {
        Friend.setFriendRequest(friend_id: (friend?.id!)!, acceptance: 2) { result in
            switch result{
            case .success(_):
                print("Denied friend request to \((self.friend?.name)!).")
                // TODO: Figure out how to just remove the whole cell
                self.buttonConfirm.isHidden = true
                self.buttonDeny.isHidden = true
                self.labelName.text = ""
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @IBAction func pressConfirm(_ sender: Any) {
        Friend.setFriendRequest(friend_id: (friend?.id!)!, acceptance: 1) { result in
            switch result {
            case .success(_):
                print("Accepted friend request to \((self.friend?.name)!).")
                // TODO: Figure out how to just remove the whole cell
                self.buttonDeny.isHidden = true
                self.buttonConfirm.isHidden = true
                self.labelName.text = ""
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
