//
//  ProfileTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
//import Parse
//import FBSDKShareKit
//import FBSDKCoreKit

class ProfileTableViewController: UITableViewController {
    
    let UserAppventures = "UserAppventure"
    
    
    struct Constants {
        static let CellName = "Cell"
        static let segueCreateNewAppventure = "Create New Appventure"
        static let segueEditAppventure = "Edit Appventure"
        static let segueSettings = "Settings"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if CoreUser.checkLogin(false, vc: self) {
            if CoreUser.user!.ownedAppventures?.count == 0 {
//                loadUserAppventures()
            }
        }
        
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(ProfileTableViewController.loadUserAppventures), name: NSNotification.Name(rawValue: User.userInitCompleteNotification), object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if CoreUser.checkLogin(false, vc: self) {
            tableView.reloadData()
            print("owned adevntures: \(CoreUser.user?.ownedAppventures?.count)")
        } else {
            let alert = UIAlertController(title: "Log In Required", message: "Log In to allow access to adventure maker.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { action in
            self.tabBarController?.selectedIndex = 1
        }))
        }
        
        HelperFunctions.unhideTabBar(self)
    }
    
    
//    func loadUserAppventures(){
//        User.user?.ownedAppventures.removeAll()
//        self.tableView.reloadData()
//        Appventure.loadAppventuresFromCoreData { (downloadedAppventures) in
//            for appventure in downloadedAppventures {
//                print(appventure.liveStatus)
//                if appventure.userID == User.user?.pfObject {
//                    User.user?.ownedAppventures.append(appventure)
//                }
//            }
//            DispatchQueue.main.async(execute: {
//                })
//        }
//    }
    
    @IBAction func refeshTable(_ sender: UIRefreshControl) {
        sender.endRefreshing()
    }

    //MARK: Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cavc = segue.destination as? CreateAppventureViewController {
            if segue.identifier == Constants.segueEditAppventure {
                if let tbCell = sender as? UITableViewCell {
                    if let row = tableView.indexPath(for: tbCell)!.row as Int! {
                        cavc.newAppventure = Array(CoreUser.user!.ownedAppventures!)[row]
                        cavc.appventureIndexRow = row
                    }
                }
            }
            cavc.delegate = self
        }
    }

    //MARK: Table functions
    
    var tableMessage = ""
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if CoreUser.user != nil {
            if CoreUser.user!.ownedAppventures!.count > 0 {
                self.tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
                self.tableView.backgroundView = UIView()
                return 1
            } else {
                let message = tableMessage
                HelperFunctions.noTableDataMessage(tableView, message: message)
            }
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreUser.user!.ownedAppventures!.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

         let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellName) as! AppventureMakerCell
        
        let row = indexPath.row
        let appventureArray = Array(CoreUser.user!.ownedAppventures!)
        cell.appventure = appventureArray[row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
          confirmDeletePopup(indexPath)
        }
    }
    
    func confirmDeletePopup (_ indexPath: IndexPath) {
        let alert = UIAlertController(title: "Delete Appventure?", message: "Appventure data will be lost!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.destructive, handler: { action in
            self.deleteAppventureFromDB(indexPath)
            self.tableView.reloadData()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteAppventureFromDB (_ indexPath: IndexPath) {
        let appventure = User.user!.ownedAppventures[indexPath.row]
        appventure.deleteAppventure()
        User.user!.ownedAppventures.remove(at: indexPath.row)

    }
    
}


extension ProfileTableViewController : CreateAppventureViewControllerDelegate {
    func appendNewAppventure(_ appventure: Appventure, indexRow: Int?) {
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
    func handleQueryResults(_ objects: [AnyObject]?, handlerCase: String?) {
//        if let isPFArray = objects as [PFObject]! {
//            for object in isPFArray {
//                let appventure = Appventure(object: object)
//                ParseFunc.loadImage(appventure)
//                User.user!.ownedAppventures.append(appventure)
//            }
//        }
        tableMessage = "You have not created any adventures"
        tableView.reloadData()
    }
}
