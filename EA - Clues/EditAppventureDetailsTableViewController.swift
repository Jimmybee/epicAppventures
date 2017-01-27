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
    @IBOutlet weak var durationPicker: UIDatePicker!
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var restrictionsPicker: UIDatePicker!
    
    
    let imageViewIndex = IndexPath(row: 0, section: 1)
    let duationLabelIndex = IndexPath(row: 0, section: 4)
    let durationPickerIndex = IndexPath(row: 1, section: 4)
    let startTimeIndex = IndexPath(row:0, section: 6)
    let endTimeIndex = IndexPath(row: 1, section: 6)
    let restrictionTimePickerIndex = IndexPath(row: 2, section: 6)

    //MARK: Flags
    var edittingDuration = false
    var edittingStartTime = false
    var edittingEndTime = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if appventure == nil {
            self.setupForNewAppventure()
        } else {
            self.updateUI()
        }

    }
    
    func setupViews() {
        restrictionsPicker.isHidden = true
        restrictionsPicker.alpha = 0
        restrictionsPicker.setDate(Date(), animated: false)
        restrictionsPicker.locale = Locale(identifier: "en_GB")
        durationPicker.isHidden = true
        durationPicker.alpha = 0
        durationPicker.setDate(Date(), animated: false)
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
    
    @IBAction func durationPickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH hr m minutes"
        durationLabel.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func restrictionsPickerChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH : mm"
        if edittingStartTime { startTimeLabel.text = dateFormatter.string(from: sender.date)}
        if edittingEndTime { endTimeLabel.text = dateFormatter.string(from: sender.date)}
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


// MARK: Table Functions
extension EditAppventureDetailsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        switch indexPath {
        case duationLabelIndex:
            edittingDuration = !edittingDuration
        case startTimeIndex:
            edittingStartTime = !edittingStartTime
            edittingEndTime = false
        case endTimeIndex:
            edittingEndTime = !edittingEndTime
            edittingStartTime = false
        default:
            break
        }

        animation()

        tableView.beginUpdates()
        tableView.endUpdates()
        
        if self.edittingStartTime || self.edittingEndTime {
            self.tableView.scrollToRow(at: self.restrictionTimePickerIndex, at: .bottom, animated: true)
        }
        
        if indexPath.section == 1 {
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
                self.navigationController?.view.layoutIfNeeded()
            })
            
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 44
        
        switch indexPath {
        case imageViewIndex:
            height = 218
        case durationPickerIndex:
            height = edittingDuration ? 218 : 0
        case restrictionTimePickerIndex:
            if edittingStartTime || edittingEndTime { height = 218 } else { height = 0}
        default:
            height = UITableViewAutomaticDimension
        }
        
        return height
    }
    
    func animation() {
        restrictionsPicker.isHidden = edittingStartTime || edittingEndTime ? false : true
        durationPicker.isHidden = edittingDuration ?  false : true
        UIView.animate(withDuration: 1.2, animations: {
            self.durationPicker.alpha = self.edittingDuration ? 1 : 0
            self.restrictionsPicker.alpha = self.edittingStartTime || self.edittingEndTime ? 1 : 0
        }) { (complete) in
        
        }
        
        durationLabel.textColor = edittingDuration ? UIColor.blue : UIColor.black
        startTimeLabel.textColor = edittingStartTime ? UIColor.blue : UIColor.black
        endTimeLabel.textColor = edittingEndTime ? UIColor.blue : UIColor.black

    }
    
    
}



