//
//  ImageChooserViewController.swift
//  EA - Clues
//
//  Created by James Birtwell on 10/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class ImageChooserViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var step = AppventureStep()
    
    @IBOutlet weak var selectImageLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if step.image != nil {
            selectImageLabel.alpha = 0
            imageView.image = step.image
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: IB Actions
    
    @IBAction func changeImageTap(sender: AnyObject) {
        print("tapped")
        self.changeImage()
        
    }
    @IBAction func changeImage() {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Take Picture", style: UIAlertActionStyle.Default, handler: { action in
            self.getImage(true)
        }))
        alert.addAction(UIAlertAction(title: "Choose From Library", style: UIAlertActionStyle.Default, handler: { action in
            self.getImage(false)

        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    //MARK: ImagePicker
    
    func getImage(useCamera: Bool) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        if useCamera {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            let savedImage = HelperFunctions.resizeImage(pickedImage, newWidth: 300)
            imageView.image = savedImage
            step.image = savedImage
            
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    

}
