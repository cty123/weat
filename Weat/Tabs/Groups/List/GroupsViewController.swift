//
//  GroupsViewController.swift
//  Weat
//
//  Created by Sean Becker on 2/20/18.
//  Copyright © 2018 Weat. All rights reserved.
//

import UIKit
import Smile

class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // outlets
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    // actions
    @IBAction func pressCreate(_ sender: Any) {
        let vc = GroupCreateViewController(nibName: "GroupCreateViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func pressRejoin(_ sender: Any) {
        let vc = GroupArchiveViewController(nibName: "GroupArchiveViewController", bundle: nil)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func handleRefresh() {
        // get groups
        Group.getAll(){ result in
            switch result{
            case .success(let groups):
                self.groups = groups
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            case .failure(_):
                print("File: \(#file)")
                print("Line: \(#line)")
                print("Failed to get groups")
                self.refreshControl.endRefreshing()
            }
        }
    }

    // vars
    var groups: [Group] = [] // SimpleData.Groups
    var emojiList: [String] = Smile.list()
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handleRefresh()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make orange
        self.navigationBar.makeOrange()
        
        // add refresh contorl
        self.tableView.addSubview(self.refreshControl)
        
        // add create group button
        self.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(pressCreate))
        
        // add rejoin group button
        self.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(pressRejoin))
        
        // setup tableView
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
    }
    
    // tableview stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return self.pendingRequests.count
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
        
        // go to group
        let vc = GroupViewController(nibName: "GroupViewController", bundle: nil)
        vc.group = self.groups[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }

}
