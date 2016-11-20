//
//  AppventureMakerCell.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//


import UIKit
//import Parse

class AppventureMakerCell: UITableViewCell {
    
    var appventure: Appventure? { didSet { updateUI()  }}
    
    @IBOutlet weak var appventureImage: UIImageView! //dont block main thread
    @IBOutlet weak var appventureTitle: UILabel!
    @IBOutlet weak var stausLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    
    //    @IBOutlet weak var ratingDisplay: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBOutlet weak var startingLocation: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func loadImage(image :UIImage) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.appventureImage.image = image
            self.appventure?.image = image
        }
    }
    
    func updateUI() {
        self.locationLabel.text = appventure?.startingLocationName
        self.stausLabel.text = " \((appventure?.liveStatus.label)!) "
        self.appventureTitle.text = appventure?.title
        if let status = appventure?.liveStatus {
            switch status {
            case LiveStatus.inDevelopment :
                self.stausLabel.backgroundColor = Colours.myRed
            case LiveStatus.local :
                self.stausLabel.backgroundColor = Colours.myBlue
            case LiveStatus.waitingForApproval :
                self.stausLabel.backgroundColor = Colours.myYellow
            case LiveStatus.live :
                self.stausLabel.backgroundColor = Colours.myGreen
            }
        }

        
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) { () -> Void in
//            if self.appventure?.image == nil {
//                if let isFile = self.appventure?.pfFile as PFFile! {
////                    ParseFunc.loadParseImage(isFile, getParseImage: self.loadImage)
//                }
//            } else {
//                self.appventureImage.image = self.appventure?.image
//            }
        }
    }

    
    //MARK: Load Image
    
    func loadImage() {
        
//        if let pfImageFile = appventure!.pfFile as PFFile! {
//            pfImageFile.getDataInBackgroundWithBlock {
//                (imageData: NSData?, error: NSError?) -> Void in
//                if error == nil {
//                    if let imageData = imageData {
//                        self.appventure!.image = UIImage(data:imageData)
//                        self.appventureImage.image = UIImage(data:imageData)
//                    } else {
//                        let errorString = error!.userInfo["error"] as? NSString
//                        print(errorString)
//                    }
//                }
//            }
//        }
        
    }
    
    
}


