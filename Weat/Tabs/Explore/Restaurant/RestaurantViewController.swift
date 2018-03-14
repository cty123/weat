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
    
    @IBOutlet weak var recommendButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var recordVisitButton: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    
    var restaurant: Restaurant?
    var back_string: String?
    var ratings: [Rating]?
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func callButtonPress(_ sender: Any) {
        // call restaurant using its phone number
        // test this when server up
        if(restaurant?.phone == nil) {
            return
        }
        let cleanNumber = (restaurant?.phone)!.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
        guard let number = URL(string: "telprompt://" + cleanNumber) else {
            return }
        
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    @IBAction func recommendButtonPress(_ sender: Any) {
        // go to recommend to friend view
        let recommendViewController = RecommendViewController(nibName: "RecommendViewController", bundle: nil)
        self.present(recommendViewController, animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonPress(_ sender: Any) {
        // save restaurant as favorite and do something on front end
    }
    
    @IBAction func menuButtonPress(_ sender: Any) {
        // go to menu view
        let menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        self.present(menuViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(back_string == nil) {
            back_string = "Back"
        }
        
        
        
        // use restaurant to fill in details
        if(restaurant != nil) {
            // get ratings
            Restaurant.getRestaurantRating(google_link: (restaurant?.google_link)!, restaurant_name: (restaurant?.name)!, completion: { (ratings: [Rating]) in
                self.ratings = ratings
                // reload tableview
            })
            
            // Google things
            // TODO: error check
            restaurantNameLabel.text = restaurant?.name
            phoneNumberLabel.text = restaurant?.phone
            priceLabel.text = restaurant?.price
            headerImage.image = restaurant?.image
            hoursLabel.text = restaurant?.open_now
            
            
            // Weat things
            // service rating
            // serviceRatingLabel.text =
            // food rating
            // foodRatingLabel.text =
            // tags text
            
        }
        
        self.recommendButton.addFullWidthBottomBorderWithColor(color: UIColor.lightGray, width: 0.4)
        self.recordVisitButton.addFullWidthBottomBorderWithColor(color: UIColor.lightGray, width: 0.4)
        self.recommendButton.addRightBorderWithColor(color: UIColor.lightGray, width: 0.4)
        self.favoriteButton.addRightBorderWithColor(color: UIColor.lightGray, width: 0.4)
        //self.favoriteButton.addFullWidthBottomBorderWithColor(color: UIColor.lightGray, width: 0.4)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
