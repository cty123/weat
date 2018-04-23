//
//  FriendTableViewCell.swift
//  Weat
//
//  Created by admin on 2/18/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewPic: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var addFriendsButton: UIButton!
    var parentVC: UIViewController?
    var user: User?
    var facebook_id: String?
    @IBAction func addFriendPressed(_ sender: UIButton) {
        if (user != nil) {
            let user_id = "\((user?.id)!)"
            Friend.sendFriendRequest(friend_id: user_id) { result in
                switch result {
                case .success(_):
                    // Alert the user
                    let alert = UIAlertController(title: "Success", message: "Sent friend request", preferredStyle: UIAlertControllerStyle.alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    // show the alert
                    self.parentVC?.present(alert, animated: true, completion: nil)
                case .failure(let error):
                    switch error{
                    case RequestError.alreadySent(let msg):
                        // Alert the user
                        let alert = UIAlertController(title: "Failure", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        // show the alert
                        self.parentVC?.present(alert, animated: true, completion: nil)
                    default:
                        // Alert the user
                        let msg = "\(error)"
                        let alert = UIAlertController(title: "Failure", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        // show the alert
                        self.parentVC?.present(alert, animated: true, completion: nil)
                        print("File: \(#file)")
                        print("Line: \(#line)")
                        print("Failed to send friend request.")
                    }
                }
            }
        } else if (facebook_id != nil){
            // get user from facebook link
            let facebook_link = facebook_id!
            
            Friend.getUserByFacebookLink(facebook_link: facebook_link){ result in
                switch result{
                case .success(let facebook_user):
                    // send request
                    let user_id = "\((facebook_user.id)!)"
                    Friend.sendFriendRequest(friend_id: user_id) { result in
                        switch result {
                        case .success(_):
                            // Alert the user
                            let alert = UIAlertController(title: "Success", message: "Sent friend request", preferredStyle: UIAlertControllerStyle.alert)
                            // add an action (button)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            // show the alert
                            self.parentVC?.present(alert, animated: true, completion: nil)
                        case .failure(let error):
                            switch error{
                            case RequestError.alreadySent(let msg):
                                // Alert the user
                                let alert = UIAlertController(title: "Failure", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                // show the alert
                                self.parentVC?.present(alert, animated: true, completion: nil)
                            default:
                                // Alert the user
                                let msg = "\(error)"
                                let alert = UIAlertController(title: "Failure", message: msg, preferredStyle: UIAlertControllerStyle.alert)
                                // add an action (button)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                // show the alert
                                self.parentVC?.present(alert, animated: true, completion: nil)
                                print("File: \(#file)")
                                print("Line: \(#line)")
                                print("Failed to send friend request.")
                            }
                        }
                    }
                case .failure(_):
                    print("File: \(#file)")
                    print("Line: \(#line)")
                    print("failed to get Weat.User from facebook_id")
                }
            }
        } else {
            print("File: \(#file)")
            print("Line: \(#line)")
            print("failed to add friend")
        }
    }
}

