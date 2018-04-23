//
//  PostRatingViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 3/13/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class PostRatingViewController: UIViewController, UITextFieldDelegate {

    // outlets
    @IBOutlet weak var sliderFood: UISlider!
    @IBOutlet weak var sliderService: UISlider!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // local vars
    var restaurant: Restaurant?
    
    @IBAction func didBeginEditing(_ sender: UITextField) {
        /*
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y - 75, width:self.view.frame.size.width, height:self.view.frame.size.height);
        })
        */
    }
    
    @IBAction func didEndEditing(_ sender: UITextField) {
        /*
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame = CGRect(x:self.view.frame.origin.x, y:self.view.frame.origin.y + 75, width:self.view.frame.size.width, height:self.view.frame.size.height);
        })
        */
    }
    
    @IBAction func pressCancel(_ sender: UIBarButtonItem) {
        // exit vc
        self.dismiss(animated: true, completion: nil)
    }
    
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
        Rating.postRestaurantRating(latitude: latitude, longitude: longitude, google_link: (restaurant?.google_link)!, restaurant_name: (restaurant?.name)!, food_rating: food_rating, service_rating: service_rating, rating_text: rating_text){ result in
            switch result {
            case .success(_):
                title = "Success"
                message = "Posted rating for \((self.restaurant?.name)!)"
            case .failure(let error):
                title = "Error"
                message = "Unable to post rating."
                print("Error \(#file)")
                print("Error \(#line)")
                print("Unable to post rating.")
                print(error)
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
        
        // add cancel button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(pressCancel))
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(postRating))
        
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
        
        // init label to name
        self.labelName.text = (restaurant?.name)!
        self.labelName.textAlignment = .center
        
        // init textfield
        self.textField.placeholder = "leave a brief message"
        self.textField.delegate = self
        // @extension- hide keyboard when screen is tapped
        self.hideKeyboardWhenTappedAround()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
