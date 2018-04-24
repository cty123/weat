//
//  GroupArchiveViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 4/17/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import Smile

class GroupArchiveViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    // actions
    @IBAction func pressBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressYes(index: Int) {
        let vc = GroupViewController(nibName: "GroupViewController", bundle: nil)
        let id = self.groups[index].id!
        
        Group.rejoin(group_id: id){ result in
            if result {
                vc.group = self.groups[index]
                self.dismiss(animated: true, completion: nil)
            } else {
                print("File: \(#file)")
                print("Line: \(#line)")
                print("Failed to get group")
            }
        }
        
    }
    
    // vars
    var groups: [Group] = []
    var emojiList: [String] = Smile.list()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make orange
        self.navigationBar.makeOrange()
        
        
        Group.getLeft(){ result in
            switch result {
            case .success(let groups):
                print(groups)
                self.groups = groups
                print("got left groups")
                self.tableView.reloadData()
            case .failure(_):
                print("File \(#file)")
                print("Line \(#line)")
                print("failed to get left groups")
            }
        }
 
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(pressBack))
    }



    
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // eturn self.members.count
        return self.groups.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height of cell
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(self.emojiList[self.groups[indexPath.row].icon_id!]) \(self.groups[indexPath.row].name!)"

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // unselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
        let group = self.groups[indexPath.row]
        let title = "Rejoin Group"
        let message = "Would you like to rejoin \(group.name!)?"
        
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No",
                                      style: .default,
                                      handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .default,
                                      handler: {alert in self.pressYes(index: indexPath.row)}))
        
        self.present(alert, animated: true, completion: nil)
    }

}
