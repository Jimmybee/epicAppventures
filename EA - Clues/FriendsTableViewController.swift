//
//  FriendsTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 24/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class FriendsTableViewController: UITableViewController {
    
    var appventure: Appventure?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismiss(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = User.user!.facebookFriends[indexPath.row].firstName + " " + User.user!.facebookFriends[indexPath.row].lastName
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        if User.user?.facebookFriends.count > 0 {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
            self.tableView.backgroundView = UIView()
            return 1
        } else {
            let message = "No friends are using this app"
            HelperFunctions.noTableDataMessage(tableView, message: message)
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (User.user?.facebookFriends.count)!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let friendID = User.user!.facebookFriends[row].id
        
        let alert = UIAlertController(title: "Share", message: "Share with friend?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { action in
            FriendsAdventures.saveObject(self.appventure!.backendlessId!, fbUserID: friendID, delegate: self)
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
 


}

extension FriendsTableViewController : FriendsAdventuresDelegate {
    
    func shareComplete(_ succes: Bool) {
        var message : String = ""
        succes ?  (message = "Adventure shared!") :  (message = "Adventure not shared!")
        let alert = UIAlertController(title: "Share", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        

        
        self.present(alert, animated: true, completion: nil)
    }
    
}
