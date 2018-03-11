//
//  RestaurantViewController.swift
//  Weat
//
//  Created by Sean Becker on 2/27/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import GooglePlaces

class RestaurantViewController: UIViewController {

    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var foodRatingLabel: UILabel!
    @IBOutlet weak var serviceRatingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var place: GMSPlace?
    var restaurant: Restaurant?
    var back_string: String?
    
    @IBAction func action(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(back_string == nil) {
            back_string = "< Back" // Change '<' to be a uiimage
        }
        
        // use place to fill in details if possible
        if(place != nil) {
            restaurantNameLabel.text = place?.name
            phoneNumberLabel.text = place?.phoneNumber
        }
        // use restaurant to fill in details if GMSPlace not supplied
        else if(restaurant != nil) {
            restaurantNameLabel.text = restaurant?.name
            phoneNumberLabel.text = restaurant?.phone
        }
        // set price text from place.price
        
        // get our food and service ratings
        // get image
        // get tags
        // get reviews
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let doneButton:UIBarButtonItem = UIBarButtonItem()
        doneButton.target = self
        doneButton.title = "\((back_string)!)"
        doneButton.action = #selector(action)
        self.navigationBar.topItem?.leftBarButtonItem = doneButton
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
