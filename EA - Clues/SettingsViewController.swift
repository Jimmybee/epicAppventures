//
//  SettingsViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 28/07/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation


import UIKit
import Parse
import FBSDKShareKit
import FBSDKCoreKit

class SettingsTableViewController: UITableViewController {
    
    let rtfDisplay = "rtfDisplay"
    
    var myTable = UITableView()
    
    @IBOutlet weak var howToPlayCell: UITableViewCell!
    @IBOutlet weak var logOutCell: UITableViewCell!
    @IBOutlet weak var choosingAdventureCell: UITableViewCell!
    @IBOutlet weak var makingAdventureCell: UITableViewCell!
    @IBOutlet weak var licencesCell: UITableViewCell!
    @IBOutlet weak var privacyCell: UITableViewCell!
    
    @IBOutlet weak var createdAdventuresCount: UILabel!
    @IBOutlet weak var completedAdventuresCount: UILabel!
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileHeaderContainer: UIView!
    @IBOutlet weak var nonFacebookHeader: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nsCenter = NSNotificationCenter.defaultCenter()
        nsCenter.addObserver(self, selector:  Selector("setupHeaderView"), name: fbImageLoadNotification, object: nil)
        
        updateUI()

    }
    
    //MARK: Get container view controllers & Navigation
    var embeddedProfileHeader: ProfileHeaderViewController!
    var embeddedNonFacebookHeader: NonFacebookHeaderViewController!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ProfileHeaderViewController {
            self.embeddedProfileHeader = vc
        }
        if let vc = segue.destinationViewController as? NonFacebookHeaderViewController {
            self.embeddedNonFacebookHeader = vc
        }
        
        if segue.identifier == rtfDisplay {
            if let rdvc = segue.destinationViewController as? RTFDisplayViewController {
                if let rtfName = sender as? String  {
                    rdvc.rtfName = rtfName
                }
            }
        }
    }
    
    func updateUI() {
        if let user = User.user {
            self.completedAdventuresCount.text = String(User.user!.completedAdventures)
            CompletedAppventure.countCompleted(self)
            Appventure.loadUserAppventure(User.user!.pfObject, handler: self, handlerCase: "")
            user.facebookConnected ? (self.setupHeaderView()) : self.parseUserHeader()
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    //MARK: table methods
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            switch cell {
            case logOutCell:
                logoutPopup()
            case howToPlayCell:
                self.performSegueWithIdentifier(rtfDisplay, sender: RTFs.howToPlay)
            case choosingAdventureCell:
                self.performSegueWithIdentifier(rtfDisplay, sender: RTFs.choosingAdventure)
            case makingAdventureCell:
                self.performSegueWithIdentifier(rtfDisplay, sender: RTFs.makingAnAdventure)
            case privacyCell:
                self.performSegueWithIdentifier(rtfDisplay, sender: RTFs.privacyPolicy)
            case licencesCell:
                self.performSegueWithIdentifier(rtfDisplay, sender: nil)
            default:
                break
            }
            
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

    }
    
    
    func logoutPopup() {
        let alert = UIAlertController(title: "Log out user", message: "Log out user", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Destructive, handler: { action in
            User.user!.logout()
            if let pwvc = self.parentViewController as? ProfileWrapperViewController  {
                pwvc.showForSignIn()
            }
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    @IBAction func dismissVC(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: HeaderView
    
    @objc func setupHeaderView () {
        
        profileHeaderContainer.alpha = 1
        nonFacebookHeader.alpha = 0
        
        if let circ = User.user!.profilePicture {
            embeddedProfileHeader.circledImageView.image = circ
            embeddedProfileHeader.updateCircleImage()
            if let blur = User.user!.blurPicture {
                embeddedProfileHeader.blurredImageView.image = blur
            } else {
                let frame = embeddedProfileHeader.blurredImageView.frame
                let blurImageSized = HelperFunctions.resizeImage(User.user!.profilePicture!, newWidth: 600)
                if let blurImage = HelperFunctions.blurImage(blurImageSized, radius: 8, forRect: frame) {
                    embeddedProfileHeader.blurredImageView.image = blurImage
                    User.user?.blurPicture = blurImage
                    User.user?.saveLocalData()
                }
            }
        } else {
            User.user?.getFBImage()
        }
        
        
        
    }

    func parseUserHeader() {
        profileHeaderContainer.alpha = 0
        nonFacebookHeader.alpha = 1
        embeddedNonFacebookHeader.headerLabel.text = "User1"
    }

}


extension SettingsTableViewController : UserDataHandler {
    func userFuncComplete(funcKey: String) {
        switch funcKey{
        case User.funcKeys.fbGraphLoaded:
            print("fbGraphloaded")
//            profileHeaderView.nameLabel.text = "\(User.user!.firstName) \(User.user!.lastName)"
        case User.funcKeys.fbImageLoaded:
            print("fbGraphloaded")

//            self.setupHeaderView()
//            self.saveLocalData()
        case User.funcKeys.localDataLoaded:
            print("fbGraphloaded")

//            self.setupHeaderView()
        default: break
        }
    }
}

extension  SettingsTableViewController : ParseQueryHandler {
    func handleQueryResults(objects: [PFObject]?, handlerCase: String?) {
        if let counted = objects?.count {
                User.user?.createdAventures = counted
                self.createdAdventuresCount.text = String(counted)
        }
    }
}

extension SettingsTableViewController : AppventureCompletedDelegate {
    func countCompleted() {
        self.completedAdventuresCount.text = String(User.user!.completedAdventures)
    }
}