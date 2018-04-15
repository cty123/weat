//
//  GroupViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 4/8/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    // actions
    @IBAction func pressBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressEdit(_ sender: Any) {
        let vc = GroupDetailsViewController(nibName: "GroupDetailsViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    // vars
    var group: Group = Group()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add back button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(pressBack))
        
        // add edit button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(pressEdit))

        // set title to group name
        self.navigationBar.topItem?.title = self.group.name
        
        // tableview setup
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
    }


    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return ?????
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height of cell
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect row
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
