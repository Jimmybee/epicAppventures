//
//  WriteReviewViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/04/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class EditTextClueViewController: UIViewController {
    
    var step = AppventureStep()
    
    @IBOutlet weak var reviewTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reviewTextView.delegate = self
        reviewTextView.text = step.initialText
        reviewTextView.layer.borderWidth = 1.5
        reviewTextView.layer.cornerRadius = 12
        reviewTextView.clipsToBounds = true
        reviewTextView.layer.borderColor = UIColor.blackColor().CGColor

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func submit(sender: UIBarButtonItem) {
        step.initialText = reviewTextView.text
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
  
}


extension EditTextClueViewController : UITextViewDelegate {
    
//    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
//        if textView.text == Constants.reviewTextViewDefaults {
//            textView.textColor = UIColor.blackColor()
//            textView.text = ""
//        }
//        return true
//    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
}
