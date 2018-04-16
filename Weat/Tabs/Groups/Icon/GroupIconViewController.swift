//
//  GroupIconViewController.swift
//  Weat
//
//  Created by Jordan Barkley on 4/15/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import Smile

class GroupIconViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    // actions
    @IBAction func pressCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressDone(_ sender: Any) {
        
        let id = self.group.id!
        let name = self.group.name!
        let icon_id = self.group.icon_id!
        
        Group.edit(group_id: id, group_name: name, group_icon_id: icon_id){ result in
            print("File: \(#file)")
            print("Line: \(#line)")
            if result {
                print("edit group success")
            } else {
                print("edit group failure")
            }
        }
        
        let pvc = self.presentingViewController as! GroupDetailsViewController
        pvc.group = self.group
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // vars
    var emojiList: [String] = Smile.list()
    var group: Group = Group()
    var row: Int = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // delegate/datasource
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // set up selection
        self.tableView.allowsMultipleSelection = false
        self.tableView.sectionIndexColor = UIColor.orange
        
        // select currently selected
        var row = 0
        if let _ = self.group.icon_id {
            row = self.group.icon_id!
        }
        
        let ip = IndexPath(row: row, section: 0)
        self.tableView.selectRow(at: ip, animated: true, scrollPosition: UITableViewScrollPosition(rawValue: 0)!)
        
        // add back button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pressCancel))
        
        // add done button
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(pressDone))
        
        // reload
        self.tableView.reloadData()
    }


    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.emojiList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // height of cell
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("GroupTableViewCell", owner: self, options: nil)?.first as! GroupTableViewCell
        
        cell.textLabel?.text = self.emojiList[indexPath.row]
        cell.labelName.text = ""
        cell.labelIconID.text = ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.group.icon_id = indexPath.row
    }

}
