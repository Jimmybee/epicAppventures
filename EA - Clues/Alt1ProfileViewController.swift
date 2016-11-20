//
//  Alt1ProfileViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 05/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
//import Parse
import FBSDKCoreKit
import FBSDKLoginKit
//import ParseFacebookUtilsV4

class Alt1ProfileViewController: UserSummaryViewController {

    @IBOutlet weak var blueImage: UIImageView!
    @IBOutlet weak var circleImage: UIImageView!

    let user = User()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func updateImages() {
        circleImage.image = user.profilePicture
        HelperFunctions.circle(circleImage)
        blueImage.image = user.blurPicture
        self.imageLoadSpinner.stopAnimating()
//        let tryImage = HelperFunctions.resizeImage(user.profilePicture!, newWidth: 600)
//        blueImage.image = blurImage(tryImage, radius: 8, forRect: blueImage.frame)

    }

    override  func saveLocalData () {
//        user.saveLocalData(blueImage)
    }
    
    override func fbGraphLoaded () {
        self.updateUI()
    }
    
    
    override func updateUI() {
        userName.text = "\(user.firstName) \(user.lastName)"
    }
//    
//    override func handleQueryResults(objects: [PFObject]?, handlerCase: String?) {
//        if let isPFArray = objects as [PFObject]! {
//            for object in isPFArray {
//                let appventure = Appventure(object: object)
//                ParseFunc.loadImage(appventure)
//                self.ownedAppventures.append(appventure)
//            }
//        }
//        //        tableView.reloadData()
//        //        tableLoadSpinner.stopAnimating()
//    }
    

}

 


