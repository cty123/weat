//
//  RestaurantViewController.swift
//  Weat
//
//  Created by Sean Becker on 2/21/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import GooglePlaces

class RestaurantViewController: UIViewController {
    private let place: GMSPlace
    
    @IBOutlet weak var restaurantName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton:UIBarButtonItem = UIBarButtonItem()
        doneButton.target = self
        doneButton.title = "Done"
        doneButton.action = #selector(RestaurantViewController.leaveView)
        self.navigationItem.rightBarButtonItem = doneButton
        // Do any additional setup after loading the view.
        
        restaurantName.text = place.name
    }
    
    init(place: GMSPlace) {
        self.place = place
        super.init(nibName: String(describing: type(of: self)), bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @objc func leaveView(sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popToRootViewController(animated: true)
        //self.navigationController?.popViewController(animated: false)
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

