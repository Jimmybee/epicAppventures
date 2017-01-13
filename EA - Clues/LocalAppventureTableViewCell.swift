//
//  LocalAppventureTableViewCell.swift
//  EpicAppventures
//
//  Created by James Birtwell on 29/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
//import Parse

class LocalAppventureTableViewCell: UITableViewCell {

    var appventure: Appventure? {
        didSet {
            updateUI()
        }
    }
    @IBOutlet weak var appventureImage: UIImageView! //dont block main thread
    @IBOutlet weak var appventureTitle: UILabel!
    @IBOutlet weak var ratingDisplay: RatingControlOrangeDisplay!
    
//    @IBOutlet weak var ratingDisplay: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBOutlet weak var startingLocation: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: Load Image
    
    func loadImage() {
//        if let pfImageFile = appventure!.pfFile as PFFile! {
//            pfImageFile.getDataInBackgroundWithBlock {
//                (imageData: NSData?, error: NSError?) -> Void in
//                if error == nil {
//                    if let imageData = imageData {
//                        self.appventure!.image = UIImage(data:imageData)
//                        dispatch_async(dispatch_get_main_queue()) { () -> Void in
//                            self.appventureImage.image = UIImage(data:imageData)
//                        }
//                    } else {
//                        let errorString = error!.userInfo["error"] as? NSString
//                        print(errorString)
//                    }
//                }
//            }
//        }
        
    }
    
//    func loadImage(image :UIImage) -> () {
//        dispatch_async(dispatch_get_main_queue()) { () -> Void in
//            self.appventureImage.image = image
//            self.appventure?.image = image
//        }
//    }

    
    func updateUI() {
        startingLocation.text = appventure?.startingLocationName
        duration.text = appventure?.duration
        appventureTitle.text = appventure?.title
        ratingDisplay.rating = (appventure?.rating)!
        if appventure?.image == nil {
            DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async { () -> Void in
                if self.appventure?.pfFile != nil {
                    self.loadImage()
                    self.ratingDisplay.layoutSubviews()
                }
            }
        } else {
            appventureImage.image = appventure?.image
        }
    }


}
