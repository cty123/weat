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
    @IBOutlet weak var favoriteLabel: UILabel!
    
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
    
    @IBAction func recordVisitPress(_ sender: UIButton) {
        // perform segue to checkin
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
        let vc = RecommendToFriendsViewController(nibName: "RecommendToFriendsViewController", bundle: nil)
        vc.restaurant = self.restaurant!
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonPress(_ sender: Any) {
        Favorite.addFavoriteRestaurant(google_link: (self.restaurant?.google_link)!, restaurant_name: (self.restaurant?.name)!){ status in
            
            // delare strings TODO: figure out error messages
            var title: String
            var message: String
            
            if (status) {
                // show message
                title = "Success"
                message = "Added \(String(describing: self.restaurant!.name!)) as a favorite!"
            
            }else{
                // TODO: change this message bc it's not yser friend
                title = "An error occured"
                message = "Unable to add \(String(describing: self.restaurant!.name!)) as a favorite"
            }
            
            // present message
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Done",
                                          style: .default,
                                          handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
        
        
    }
    
    
    @IBAction func menuButtonPress(_ sender: Any) {
        // go to menu view
        let menuViewController = MenuViewController(nibName: "MenuViewController", bundle: nil)
        menuViewController.menu = restaurant?.menu
        self.present(menuViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(back_string == nil) {
            back_string = "Back"
        }
        
        // use restaurant to fill in details
        if(restaurant != nil) {
            // Google things
            // TODO: error check
            restaurantNameLabel.text = restaurant?.name
            phoneNumberLabel.text = restaurant?.phone
            priceLabel.text = restaurant?.price
            headerImage.image = restaurant?.image
            hoursLabel.text = restaurant?.open_now
            
            /*
            if((restaurant?.is_favorite)!) {
                favoriteLabel.text = "Remove Favorite"
            } else {
                favoriteLabel.text = "Favorite"
            }
            */
            
            // Weat things
            // service rating
            // serviceRatingLabel.text =
            // food rating
            // foodRatingLabel.text =
            // tags text
            
        }
        //self.favoriteButton.addFullWidthBottomBorderWithColor(color: UIColor.lightGray, width: 0.4)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.recommendButton.addFullWidthBottomBorderWithColor(color: UIColor.lightGray, width: 0.4)
        self.recordVisitButton.addFullWidthBottomBorderWithColor(color: UIColor.lightGray, width: 0.4)
        self.recommendButton.addRightBorderWithColor(color: UIColor.lightGray, width: 0.4)
        self.favoriteButton.addRightBorderWithColor(color: UIColor.lightGray, width: 0.4)
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
