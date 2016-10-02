//
//  AnswerHintViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 10/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class AnswerHintViewController: UIViewController {
    
    lazy var answers = [String]()
    lazy var answerHint = [String]()
    lazy var answerTest = [String]()

    var hintsRecieved = 0
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var remainingLetterLabel: UILabel!
    
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var hintButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        submitButton.layer.borderWidth = 2.0
//        submitButton.layer.borderColor = UIColor.whiteColor().CGColor
//        hintButton.layer.borderWidth = 2.0
//        hintButton.layer.borderColor = UIColor.whiteColor().CGColor
        answerTextField.addTarget(self, action: Selector("textDidChange"), forControlEvents: UIControlEvents.EditingChanged)

//        answerTextField.addTarget(self, action: #selector(AnswerHintViewController.textDidChange), forControlEvents: UIControlEvents.EditingChanged)
    }
    
    func setup() {
        warningLabel.text = ""
        remainingLetterLabel.alpha = 0
        answerTest = answers.map {$0.stringByReplacingOccurrencesOfString(" ", withString: "").lowercaseString}

//        remainingLetterLabel.text = String(answers[0].characters.count)
        hintsRecieved = 0
    }

    @IBAction func submit(_: AnyObject?) {
//        print("submitted")
        var submission = answerTextField.text!
        submission = submission.stringByReplacingOccurrencesOfString(" ", withString: "").lowercaseString
        
        if answerTest.contains(submission) {
            if let pvc = self.parentViewController as? StepViewController{
                pvc.stepComplete()
                self.answerTextField.text = ""
            }
        } else {
            answerTextField.resignFirstResponder()
            answerTextField.textColor = UIColor.redColor()
            warningLabel.text = "Incorrect. Please try again"
            
        }
    }
    
    @IBAction func giveHint(sender: AnyObject) {
        if self.answerHint.count == self.hintsRecieved {
            let alert = UIAlertController(title: "No Hints", message: "There are no hints remaining.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Get Hint", message: "Getting a hint may incur a time penalty. There are \( self.answerHint.count - self.hintsRecieved) hints remaining.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: { action in
                if let pvc = self.parentViewController as? StepViewController{
                    pvc.updateHintText(self.answerHint[self.hintsRecieved], hintsRecieved: self.hintsRecieved)
                    self.hintsRecieved += 1
                }
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func textDidChange () {
        let iLetters = answers[0].characters.count - (answerTextField.text?.characters.count)!
        remainingLetterLabel.text = String(iLetters)
    }
}



extension AnswerHintViewController : UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == answerTextField {
            textField.text = ""
            textField.textColor = UIColor.blackColor()
        }
        return true
    }
    
//    func textFieldDidEndEditing(textField: UITextField) {
//        if textField == answerTextField {
//            submit(self)
//        }
//    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    

}
