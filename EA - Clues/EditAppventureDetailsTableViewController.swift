//
//  EditAppventureDetailsTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 03/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

protocol EditAppventureDetailsTableViewControllerDelegate : NSObjectProtocol {
    func completedEdit(appventure: Appventure)
}

class EditAppventureDetailsTableViewController: UITableViewController {
    
    var appventure: Appventure?
        
    @IBOutlet weak var selectImageLabel: UILabel!
    //MARK: Outlets
    //TextView
    @IBOutlet weak var appventureDescription: UITextView!
    //TextField
    @IBOutlet weak var appventureNameField: UITextField!
    @IBOutlet weak var appventureDuration: UITextField!
    @IBOutlet weak var startingLocation: UITextField!
    //Views
    @IBOutlet weak var restrictionsField: UITextField!
    @IBOutlet weak var keyFeatures: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saveBtt: UIBarButtonItem!


    override func viewDidLoad() {
        super.viewDidLoad()
        if appventure == nil {
            self.setupForNewAppventure()
        } else {
            self.updateUI()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupForNewAppventure() {
        
    }
    
    func updateUI(){
        if appventure?.image != nil {
            imageView.image = appventure!.image
            selectImageLabel.alpha = 0
        }
        appventureNameField.text =  appventure!.title
        appventureDescription.text = appventure!.subtitle
        appventureDuration.text = appventure!.duration
        startingLocation.text = appventure!.startingLocationName
        restrictionsField.text = appventure!.restrictions.joinWithSeparator(",")
        keyFeatures.text = appventure!.keyFeatures.joinWithSeparator(",")
        self.saveBtt.enabled = false
    }
    
    func checkSave() {
        
        self.saveBtt.enabled = true

    }

    
    //MARK: IBActions 
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: AnyObject) {
        updateAppventure()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateAppventure() {
        appventure!.title = appventureNameField.text
        appventure!.subtitle = appventureDescription.text
        appventure!.duration = appventureDuration.text!
        appventure!.startingLocationName = startingLocation.text!
        appventure!.restrictions = restrictionsField.text!.splitStringToArray()
        appventure!.keyFeatures = keyFeatures.text!.splitStringToArray()
        appventure!.image = imageView.image
        appventure?.saveToParse()
    }
    
    //MARK: Tableview Delegate 
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Take Image", style: UIAlertActionStyle.Default, handler: { action in
            HelperFunctions.getImage(true, delegate: self, presenter: self)
            
        }))
        alert.addAction(UIAlertAction(title: "Pick From Library", style: UIAlertActionStyle.Default, handler: { action in
            HelperFunctions.getImage(false, delegate: self, presenter: self)
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)

    }
}

//MARK: UIImagePickerControllerDelegate
extension EditAppventureDetailsTableViewController : ImagePicker {
  
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            let savedImage = HelperFunctions.resizeImage(pickedImage, newWidth: 300)
            imageView.image = savedImage
        }
        
        checkSave()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

//MARK: UITextViewDelegate
extension EditAppventureDetailsTableViewController : UITextViewDelegate {
    
        func textViewDidEndEditing(textView: UITextView) {
            if textView == appventureDescription {
                checkSave()
            }
        }
    
        func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    
}

//MARK: UITextFieldDelegate
extension EditAppventureDetailsTableViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkSave()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}


