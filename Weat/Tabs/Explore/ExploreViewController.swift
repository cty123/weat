//
//  ExploreViewController.swift
//  Weat
//
//  Created by Sean Becker on 2/20/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var seg: UISegmentedControl!
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        
        var nextController: UIViewController
        var prevController: UIViewController
        // Choose child
        if(sender.selectedSegmentIndex == 0) {
            nextController = self.storyboard?.instantiateViewController(withIdentifier: "Map") as! MapViewController
            //prevController = self.storyboard?.instantiateViewController(withIdentifier: "List") as! ListViewController
        } else {
            nextController = self.storyboard?.instantiateViewController(withIdentifier: "List") as! ListViewController
            //prevController = self.storyboard?.instantiateViewController(withIdentifier: "Map") as! MapViewController
        }
        
        // Set up new child
        nextController.view.frame = self.view.bounds
        nextController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify old child
        prevController = self.childViewControllers.last!
        prevController.willMove(toParentViewController: nil)
        prevController.view.removeFromSuperview()
        prevController.removeFromParentViewController()
        
        // Add child to subview
        self.addChildViewController(nextController)
        self.view.addSubview(nextController.view)
        nextController.didMove(toParentViewController: self)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Change segmented control looks
        seg.setup(segmentNames: ["Map", "List"], color: UIColor.orange)
        
        // Show maps view
        let initialController = self.storyboard?.instantiateViewController(withIdentifier: "Map") as! MapViewController
        self.addChildViewController(initialController)
        self.view.addSubview(initialController.view)
        initialController.view.frame = self.view.bounds
        initialController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        initialController.didMove(toParentViewController: self)
        
        
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
