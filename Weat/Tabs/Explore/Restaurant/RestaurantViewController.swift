//
//  RestaurantViewController.swift
//  Weat
//
//  Created by Sean Becker on 2/27/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import GooglePlaces
import FBSDKCoreKit
import SwiftyJSON

class RestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
    
    @IBOutlet weak var tableView: UITableView!
    
    var restaurant: Restaurant?
    var back_string: String?
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func recordVisitPress(_ sender: UIButton) {
        let postRatingViewController = PostRatingViewController(nibName: "PostRatingViewController", bundle: nil)
        postRatingViewController.restaurant = restaurant
        self.present(postRatingViewController, animated: true, completion: nil)
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
        if((restaurant?.is_favorite)!) {
            Favorite.deleteFavoriteRestaurant(google_link: (self.restaurant?.google_link)!, restaurant_name: (self.restaurant?.name)!){ status in
                
                // delare strings TODO: figure out error messages
                var title: String
                var message: String
                
                if (status) {
                    // show message
                    title = "Success"
                    message = "Deleted \(String(describing: self.restaurant!.name!)) from favorites!"
                    self.favoriteLabel.text = "Favorite"
                    self.restaurant?.is_favorite = false
                    
                }else{
                    // TODO: change this message bc it's not yser friend
                    title = "Error"
                    message = "Unable to remove \(String(describing: self.restaurant!.name!)) from favorites"
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
        else {
            Favorite.addFavoriteRestaurant(google_link: (self.restaurant?.google_link)!, restaurant_name: (self.restaurant?.name)!){ status in
                
                // delare strings TODO: figure out error messages
                var title: String
                var message: String
                
                if (status) {
                    // show message
                    title = "Success"
                    message = "Added \(String(describing: self.restaurant!.name!)) as a favorite!"
                    self.favoriteLabel.text = "Remove Favorite"
                    self.restaurant?.is_favorite = true
                
                } else {
                    // TODO: change this message bc it's not yser friend
                    title = "Error"
                    message = "Unable to add \(String(describing: self.restaurant!.name!)) as a favorite"
                }
                
                // present message
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Done", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
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
            
            // rating calculations
            var food_rating: Int = 0
            var service_rating: Int = 0
            print(restaurant!)
            if( (restaurant?.rating.food_count_all)! > 0) {
                let rating = Float((restaurant?.rating.food_good_all)!) / Float((restaurant?.rating.food_count_all)!) * 100
                food_rating = Int(rating)
                foodRatingLabel.text = "\(food_rating)% of people like the food"
            } else {
                foodRatingLabel.text = ""
            }
            if( (restaurant?.rating.service_count_all)! > 0) {
                let rating = Float((restaurant?.rating.service_good_all)!) / Float((restaurant?.rating.service_count_all)!) * 100
                service_rating = Int(rating)
                serviceRatingLabel.text = "\(service_rating)% of people like the service"
            } else {
                serviceRatingLabel.text = ""
            }
            
            if((restaurant?.is_favorite)!) {
                favoriteLabel.text = "Remove Favorite"
            } else {
                favoriteLabel.text = "Favorite"
            }
            
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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /******* RATINGS TABLE *******/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // feed = 0
        let count: Int = (restaurant?.comments.count)!
        
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("RatingTableViewCell", owner: self, options: nil)?.first as! RatingTableViewCell
        
        cell.labelName.text = restaurant?.comments[indexPath.row].author
        cell.dateLabel.text = restaurant?.comments[indexPath.row].time?.toString(dateFormat: "MMM d, yyyy, h:mm a")
        cell.ratingText.text = restaurant?.comments[indexPath.row].comment_text
        cell.rating = restaurant?.comments[indexPath.row]
        
        // Set rating pictures
        switch((restaurant?.comments[indexPath.row].food_rating)!){
        case -1:
            cell.foodRatingImage.image = UIImage(named: "thumbs-down")
        case 1:
            cell.foodRatingImage.image = UIImage(named: "thumbs-up")
        default:
            cell.foodRatingImage.image = UIImage(named: "so-so")
        }
        switch((restaurant?.comments[indexPath.row].service_rating)!){
        case -1:
            cell.serviceRatingImage.image = UIImage(named: "thumbs-down")
        case 0:
            cell.serviceRatingImage.image = UIImage(named: "thumbs-up")
        default:
            cell.serviceRatingImage.image = UIImage(named: "so-so")
        }
        
        // Set profile picture
        FBSDKGraphRequest(graphPath: (cell.rating?.author_FB_link)!, parameters: ["fields": "name, location, picture.type(small)"]).start(completionHandler: { (connection, result, error) -> Void in
            if (error == nil){
                // get json
                let json = JSON(result!)
                // profile picture
                let urlString: String = json["picture","data","url"].stringValue
                let url = URL(string: urlString)
                if let data = try? Data(contentsOf: url!) {
                    cell.profileImage.image = UIImage(data: data)!
                    cell.profileImage.layer.cornerRadius = cell.profileImage.frame.size.height / 2;
                    cell.profileImage.layer.masksToBounds = true;
                    cell.profileImage.layer.borderWidth = 0;
                }
                
            } else {
                print(error as Any)
            }
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // keeps a row from being permenantly selected
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
