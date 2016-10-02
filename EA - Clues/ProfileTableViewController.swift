//
//  ProfileTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import Parse
import FBSDKShareKit
import FBSDKCoreKit

class ProfileTableViewController: UITableViewController {
    
    let UserAppventures = "UserAppventure"
    
    
    struct Constants {
        static let CellName = "Cell"
        static let segueCreateNewAppventure = "Create New Appventure"
        static let segueEditAppventure = "Edit Appventure"
        static let segueSettings = "Settings"
    }

    @IBOutlet weak var tableLoadSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if User.checkLogin(false, vc: self) {
            if User.user!.ownedAppventures.count == 0 {
                Appventure.loadUserAppventure(User.user!.pfObject, handler: self, handlerCase: UserAppventures)
            }
        }
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("loadUserAppventures"), name: User.userInitCompleteNotification, object: nil)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if User.checkLogin(false, vc: self) {
            tableView.reloadData()
            print("owned adevntures: \(User.user?.ownedAppventures.count)")
        } else {
            let alert = UIAlertController(title: "Log In Required", message: "Log In to allow access to adventure maker.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            self.tabBarController?.selectedIndex = 1
        }))
        }
        
        HelperFunctions.unhideTabBar(self)
    }
    
    
    func loadUserAppventures(){
        Appventure.loadUserAppventure(User.user!.pfObject, handler: self, handlerCase: UserAppventures)
    }
    
    @IBAction func refeshTable(sender: UIRefreshControl) {
        User.user?.ownedAppventures.removeAll()
        self.tableView.reloadData()
        Appventure.loadUserAppventure(User.user!.pfObject, handler: self, handlerCase: UserAppventures)
        sender.endRefreshing()
    }

    //MARK: Navigation

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let cavc = segue.destinationViewController as? CreateAppventureViewController {
            if segue.identifier == Constants.segueEditAppventure {
                if let tbCell = sender as? UITableViewCell {
                    if let row = tableView.indexPathForCell(tbCell)!.row as Int! {
                        cavc.newAppventure = User.user!.ownedAppventures[row]
                        cavc.appventureIndexRow = row
                    }
                }
            }
            cavc.delegate = self
        }
    }

    //MARK: Table functions
    
    var tableMessage = ""
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if User.user != nil {
            if User.user!.ownedAppventures.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
                self.tableView.backgroundView = UIView()
                return 1
            } else {
                let message = tableMessage
                HelperFunctions.noTableDataMessage(tableView, message: message)
            }
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.user!.ownedAppventures.count

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

         let cell = tableView.dequeueReusableCellWithIdentifier(Constants.CellName) as! AppventureMakerCell
        
        let row = indexPath.row
        cell.appventure = User.user!.ownedAppventures[row]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
          confirmDeletePopup(indexPath)
        }
    }
    
    func confirmDeletePopup (indexPath: NSIndexPath) {
        let alert = UIAlertController(title: "Delete Appventure?", message: "Appventure data will be lost!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Destructive, handler: { action in
            self.deleteAppventureFromDB(indexPath)
            self.tableView.reloadData()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func deleteAppventureFromDB (indexPath: NSIndexPath) {
        let appventure = User.user!.ownedAppventures[indexPath.row]
        appventure.deleteAppventure()
        User.user!.ownedAppventures.removeAtIndex(indexPath.row)

    }
    
}


extension ProfileTableViewController : CreateAppventureViewControllerDelegate {
    func appendNewAppventure(appventure: Appventure, indexRow: Int?) {
//        if let row = indexRow as Int! {
//            User.user!.ownedAppventures[row] = appventure
//        } else {
//            User.user!.ownedAppventures.append(appventure)
//        }
//        
//        tableView.reloadData()
        
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

extension ProfileTableViewController : ParseQueryHandler {
    func handleQueryResults(objects: [PFObject]?, handlerCase: String?) {
        if let isPFArray = objects as [PFObject]! {
            for object in isPFArray {
                let appventure = Appventure(object: object)
                ParseFunc.loadImage(appventure)
                User.user!.ownedAppventures.append(appventure)
            }
        }
        tableMessage = "You have not created any adventures"
        tableView.reloadData()
        tableLoadSpinner.stopAnimating()
    }
}