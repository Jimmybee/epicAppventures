//
//  LocalAppventureTableViewCell.swift
//  EpicAppventures
//
//  Created by James Birtwell on 29/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import UIKit
import Alamofire

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
        appventureImage.image = nil
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
    
    func loadImageFor(appventure: Appventure?) {
        guard let objectId = appventure?.backendlessId else { return }
        let url = "https://api.backendless.com/\(AppDelegate.APP_ID)/\(AppDelegate.VERSION_NUM)/files/myfiles/\(objectId)/appventure.jpg"
        Alamofire.request(url).response { response in
            guard let data = response.data else {return}
            guard let image = UIImage(data: data) else { return }
            appventure?.image = image
            self.appventureImage.image = image
            self.setNeedsDisplay()
        }
    }
    
    func updateUI() {
        startingLocation.text = appventure?.startingLocationName
        duration.text = appventure?.duration
        appventureTitle.text = appventure?.title
        ratingDisplay.rating = (appventure?.rating)!
        if let image = appventure?.image {
            appventureImage.image = image
        } else {
            loadImageFor(appventure: appventure)
        }
    }


}
