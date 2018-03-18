//
//  PostRatingViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 3/13/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class PostRatingViewController: UIViewController {

    // outlets
    @IBOutlet weak var sliderFood: UISlider!
    @IBOutlet weak var sliderService: UISlider!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // make sliders stop at fixed points
    @IBAction func changedFood(_ sender: UISlider) {
        sender.setValue(Float(lroundf(sliderFood.value)), animated: true)
        
    }
    @IBAction func changedService(_ sender: UISlider) {
        sender.setValue(Float(lroundf(sliderService.value)), animated: true)
    }
    
    // submit ratings
    @IBAction func postRating(_ sender: Any) {
        // TODO: post here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Weat colors
        self.sliderFood.tintColor = UIColor.orange
        self.sliderService.tintColor = UIColor.orange
    
        // initial colors
        self.sliderFood.value = 1
        self.sliderService.value = 1
        
        // set max of 3 increments (dislike, neutral, like)
        self.sliderFood.minimumValue = -1
        self.sliderFood.maximumValue = 1
        self.sliderService.minimumValue = -1
        self.sliderService.maximumValue = 1
        
        // init submit button
        self.button.setup(title: "Submit", color: UIColor.orange)
        
        // init label to name (TODO)
        self.labelName.text = "Restaurant Name"
        self.labelName.textAlignment = .center
        
        // init textfield, TODO: reword this
        self.textField.placeholder = "leave a brief message (optional)"
    }
    

    
    

}
