//
//  RateViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/04/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class RateViewController: UIViewController {
    
    //Model
    var appventureID: String!
    var appventureRating: AppventureRating?
    
    //Views
    @IBOutlet weak var ratingControl: RatingControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func saveRating () {
        if ratingControl.rating != 0 {
            
        }
    }

    @IBAction func submitRating(sender: AnyObject) {
        
        if let currentUser = User.user {
            if  let appventureID = Appventure.currentAppventureID() {
                let newRating = AppventureRating(userFKID: currentUser.pfObject, appventureFKID: appventureID, rating: ratingControl.rating)
                newRating.save()
            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
