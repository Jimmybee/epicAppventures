//
//  FriendsTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 24/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class FriendsTableViewController: UITableViewController {
    
    var appventure: Appventure?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = User.user!.facebookFriends[indexPath.row].firstName + " " + User.user!.facebookFriends[indexPath.row].lastName
        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if User.user?.facebookFriends.count > 0 {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
            self.tableView.backgroundView = UIView()
            return 1
        } else {
            let message = "No friends are using this app"
            HelperFunctions.noTableDataMessage(tableView, message: message)
        }
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (User.user?.facebookFriends.count)!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let row = indexPath.row
        let friendID = User.user!.facebookFriends[row].id
        
        let alert = UIAlertController(title: "Share", message: "Share with friend?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { action in
            FriendsAdventures.saveObject(self.appventure!.pFObjectID!, fbUserID: friendID, delegate: self)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
 


}

extension FriendsTableViewController : FriendsAdventuresDelegate {
    
    func shareComplete(succes: Bool) {
        var message : String = ""
        succes ?  (message = "Adventure shared!") :  (message = "Adventure not shared!")
        let alert = UIAlertController(title: "Share", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        

        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}