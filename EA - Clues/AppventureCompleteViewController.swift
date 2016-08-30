//
//  AppventureCompleteViewController.swift
//  EpicAppventures
//
//  Created by James Birtwell on 29/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
import Parse
import FBSDKShareKit
import FBSDKCoreKit

class AppventureCompleteViewController: UIViewController {
    
    struct Constants {
        static let segueToReview = ""
        static let segueToRate = ""
    }
    
    lazy var appventure = Appventure()
    lazy var completedAppventures = [CompletedAppventure]()
    lazy var completeTime = 0.0
    
    var userFKID = ""

    //MARK: Outlets
    @IBOutlet weak var congratulationsText: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var shareButton: FBSDKShareButton!
    
    @IBOutlet weak var appventureImage: UIImageView!
    @IBOutlet weak var teamNameField: UITextField!
    
    //MARK: Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        

        if User.checkLogin(false, vc: self)     {
            userFKID = (User.user?.pfObject)!
        }
        
        fbShareButton()
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //MARK: IB actions
    
    @IBAction func appventureDone(sender: UIButton) {
        saveCompletedAppventure()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func saveCompletedAppventure() {
        let teamName = teamNameField.text
        let completedAppventure = CompletedAppventure(userFKID: userFKID, teamName: teamName!, appventureFKID: appventure.PFObjectID!, date: NSDate(), time: completeTime)
        completedAppventure.save()
    }
    
    
    //MARK: UI Functions
    
    func updateUI() {
        let formatTime = HelperFunctions.formatTime(completeTime, nano: false)
        timeLabel.text  = "Completed in \(formatTime!)s."
        appventureImage.image = self.appventure.image
    }
    
    
    func fbShareButton () {
        
        if User.user?.facebookConnected == false {
            //try to connect to facebook
        } else {
            let formatTime = HelperFunctions.formatTime(completeTime, nano: false)
            let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentURL = NSURL(string: "http://epicappventure.com/")
            content.contentTitle = "Appventure Completed"
            content.contentDescription = "I have just completed \(appventure.title!) in \(formatTime!)"
            if let imageURL = appventure.pfFile?.url {
                content.imageURL = NSURL(string: imageURL)
            }
            shareButton.shareContent = content
        }
    }

}

//MARK: Extensions

extension AppventureCompleteViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension AppventureStartViewController : FBSDKSharingDelegate {
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("Share Complete")
    }
    
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        print(error)
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {}
    
}


