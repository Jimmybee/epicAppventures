//
//  EditAppventureDetailsTableViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 03/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit
import PureLayout

class EditAppventureDetailsTableViewController: UITableViewController {
    
    var appventure: Appventure?
    
    private(set) lazy var timePickerView: TimePicker = {
        let bundle = Bundle(for: TimePicker.self)
        let nib = bundle.loadNibNamed("TimePicker", owner: self, options: nil)
        let view = nib?.first as? TimePicker
        view?.delegate = self
        return view!
    }()
    
    
    var aboveBottom: NSLayoutConstraint!
    var belowBottom: NSLayoutConstraint!
    
    //MARK: Outlets
    //TextView
    @IBOutlet weak var appventureDescription: UITextView!
    //TextField
    @IBOutlet weak var appventureNameField: UITextField!
    @IBOutlet weak var startingLocation: UITextField!
    //Views
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var saveBtt: UIBarButtonItem!

    @IBOutlet weak var durationLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if appventure == nil {
            self.setupForNewAppventure()
        } else {
            self.updateUI()
        }
    
        setupConstraints()
        
    }


    
    func setupConstraints(){
        guard let navView = self.navigationController?.view else { return }
        navView.addSubview(timePickerView)
        timePickerView.autoMatch(.height, to: .height, of: navView)
        timePickerView.autoMatch(.width, to: .width, of: navView)
        timePickerView.autoAlignAxis(.vertical, toSameAxisOf: navView)
        
        aboveBottom = timePickerView.autoPinEdge(.bottom, to: .bottom, of: navView)
        aboveBottom.isActive = false
        belowBottom = timePickerView.autoPinEdge(.top, to: .bottom, of: navView)
        belowBottom.isActive = true
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
        }
        appventureNameField.text =  appventure!.title
        appventureDescription.text = appventure!.subtitle
        durationLabel.text = appventure!.duration
        startingLocation.text = appventure!.startingLocationName
//        restrictionsField.text = appventure!.restrictions?.joined(separator: ",")
//        keyFeatures.text = appventure!.keyFeatures?.joined(separator: ",")
        self.saveBtt.isEnabled = false
    }
    
    func checkSave() {
        
        self.saveBtt.isEnabled = true

    }

    
    //MARK: IBActions 
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        AppDelegate.coreDataStack.rollbackContext()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: AnyObject) {
        updateAppventure()
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateAppventure() {
        appventure!.title = appventureNameField.text
        appventure!.subtitle = appventureDescription.text
        appventure!.duration = durationLabel.text
        appventure!.startingLocationName = startingLocation.text
//        appventure!.restrictions = restrictionsField.text!.splitStringToArray()
//        appventure!.keyFeatures = keyFeatures.text!.splitStringToArray()
        appventure!.image = imageView.image
        AppDelegate.coreDataStack.saveContext(completion: nil)
    }
    
    
    //MARK: Tableview Delegate 
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Take Image", style: UIAlertActionStyle.default, handler: { action in
                HelperFunctions.getImage(true, delegate: self, presenter: self)
                
            }))
            alert.addAction(UIAlertAction(title: "Pick From Library", style: UIAlertActionStyle.default, handler: { action in
                HelperFunctions.getImage(false, delegate: self, presenter: self)
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            UIView.animate(withDuration: 0.6, animations: {
                self.belowBottom.isActive = false
                self.aboveBottom.isActive = true
                self.navigationController?.view.layoutIfNeeded()
            })

        }
    }
}

//MARK: UIImagePickerControllerDelegate
extension EditAppventureDetailsTableViewController : ImagePicker {
  
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            let savedImage = HelperFunctions.resizeImage(pickedImage, newWidth: 300)
            imageView.image = savedImage
        }
        
        checkSave()
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: UITextViewDelegate
extension EditAppventureDetailsTableViewController : UITextViewDelegate {
    
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView == appventureDescription {
                checkSave()
            }
        }
    
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    
}

//MARK: UITextFieldDelegate
extension EditAppventureDetailsTableViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkSave()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

extension EditAppventureDetailsTableViewController: TimePickerDelegate {
    func dismissPressed() {
        UIView.animate(withDuration: 0.6, animations: {
            self.aboveBottom.isActive = false
            self.belowBottom.isActive = true
            self.navigationController?.view.layoutIfNeeded()
        })
    }
    
    func donePressed() {
        
    }
}

