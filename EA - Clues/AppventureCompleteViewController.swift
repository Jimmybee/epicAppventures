//
//  AppventureCompleteViewController.swift
//  EpicAppventures
//
//  Created by James Birtwell on 29/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
//import Parse
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    //MARK: IB actions
    
    @IBAction func appventureDone(_ sender: UIButton) {
        saveCompletedAppventure()
        self.dismiss(animated: true, completion: nil)
    }

    
    func saveCompletedAppventure() {
        let teamName = teamNameField.text
        let completedAppventure = CompletedAppventure(userFKID: userFKID, teamName: teamName!, appventureFKID: appventure.pFObjectID!, date: Date(), time: completeTime)
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
            content.contentURL = URL(string: "http://epicappventure.com/")
            content.contentTitle = "Appventure Completed"
            content.contentDescription = "I have just completed \(appventure.title!) in \(formatTime!)"
            if let imageURL = appventure.pfFile?.url {
                content.imageURL = URL(string: String(describing: imageURL))
            }
            shareButton.shareContent = content
        }
    }

}

//MARK: Extensions

extension AppventureCompleteViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension AppventureStartViewController : FBSDKSharingDelegate {
    /*!
     @abstract Sent to the delegate when the sharer encounters an error.
     @param sharer The FBSDKSharing that completed.
     @param error The error.
     */
    public func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        
        print(error)


    }

    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable: Any]!) {
        print("Share Complete")

    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {}
    
}


