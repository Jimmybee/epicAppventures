//
//  WriteReviewViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/04/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class WriteReviewViewController: UIViewController {
    
    struct Constants {
        static let reviewTextViewDefaults = "write a review..."
    }
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTextView.textColor = UIColor.grayColor()
        reviewTextView.text = Constants.reviewTextViewDefaults
        
        reviewTextView.layer.borderWidth = 1.5
        reviewTextView.layer.cornerRadius = 12
        reviewTextView.clipsToBounds = true
        reviewTextView.layer.borderColor = UIColor.blackColor().CGColor
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func submit(sender: UIBarButtonItem) {
        if let currentUser = User.user {
            let reviewObject = AppventureReviews(userFKID: currentUser.pfObject, review: reviewTextView.text, appventureFKID: Appventure.currentAppventureID()!, date: NSDate())
            reviewObject.save()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}


extension WriteReviewViewController : UITextViewDelegate {
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        if textView.text == Constants.reviewTextViewDefaults {
            textView.textColor = UIColor.blackColor()
            textView.text = ""
        }
        return true
    }
    
    //    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    //        if(text == "\n") {
    //            textView.resignFirstResponder()
    //            return false
    //        }
    //        return true
    //    }
    
}
