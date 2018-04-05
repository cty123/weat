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
    
    // local vars
    var restaurant: Restaurant?
    
    // make sliders stop at fixed points
    @IBAction func changedFood(_ sender: UISlider) {
        sender.setValue(Float(lroundf(sliderFood.value)), animated: true)
        
    }
    @IBAction func changedService(_ sender: UISlider) {
        sender.setValue(Float(lroundf(sliderService.value)), animated: true)
    }
    
    // submit ratings
    @IBAction func postRating(_ sender: Any) {
        let food_rating = Int(self.sliderFood.value)
        let service_rating = Int(self.sliderService.value)
        let rating_text = self.textField.text!
        var title = ""
        var message = ""
        
        /*
         * Need to know the latitude and longitude of the restaurant
         */
        let latitude = 0.0
        let longitude = 0.0
        Rating.postRestaurantRating(latitude: latitude, longitude: longitude, google_link: (restaurant?.google_link)!, restaurant_name: (restaurant?.name)!, food_rating: food_rating, service_rating: service_rating, rating_text: rating_text){ status in
            if (status){
                title = "Success"
                message = "Posted rating for \((self.restaurant?.name)!)"
            } else {
                title = "Error"
                message = "Unable to post rating."
                print("Error \(#file)")
                print("Error \(#line)")
                print("Unable to post rating.")
            }
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Done",
                                          style: .default,
                                          handler: {_ in
                                            CATransaction.setCompletionBlock({
                                                self.dismiss(animated: true, completion: nil)
                                            })
                                        }))
            self.present(alert, animated: true, completion: nil)
        }
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
        self.labelName.text = (restaurant?.name)!
        self.labelName.textAlignment = .center
        
        // init textfield, TODO: reword this
        self.textField.placeholder = "leave a brief message"
    }
    

    
    

}
