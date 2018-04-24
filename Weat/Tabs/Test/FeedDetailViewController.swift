//
//  FeedDetailViewController.swift
//  Weat
//
//  Created by Sean Becker on 4/23/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController {
    @IBOutlet weak var labelActor: UILabel!
    @IBOutlet weak var labelAction: UILabel!
    @IBOutlet weak var labelReceiver: UILabel!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var feed_obj: FeedElement?
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationBar.makeOrange()
        labelActor.text = (feed_obj?.actor_name)!
        labelAction.text = (feed_obj?.feed_text)!
        if (feed_obj?.restaurant_name != nil) {
            labelReceiver.text = (feed_obj?.restaurant_name)!
        } else {
            labelReceiver.text = (feed_obj?.receiver_name)!
        }
    }
}
