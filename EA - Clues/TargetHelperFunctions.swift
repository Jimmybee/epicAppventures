//
//  TargetHelperFunctions.swift
//  EpicAppventures
//
//  Created by James Birtwell on 22/01/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import UIKit

class TargetHelperFunctions {
    //MARK: Image Functions
    
    struct Constants {
        static let ImageFullscreenVC = "ImageFullscreenVC"
    }

    
    class func openLargeImage (image: UIImage, vc: UIViewController) {
        let storyBoard = UIStoryboard(name: "Interactive", bundle:nil)
        if let ifvc = storyBoard.instantiateViewControllerWithIdentifier(Constants.ImageFullscreenVC) as? ImageFullscreenViewController {
            ifvc.image = image
            vc.presentViewController(ifvc, animated: true, completion: nil)
        }
    }
    
    class func getImage(useCamera: Bool, delegate: UIViewController) {
        
        let imagePicker = UIImagePickerController()
        
//        if let  iavc = delegate as? ImageAssetViewController {
//            imagePicker.delegate = iavc
//        }
        
        
        if useCamera {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        imagePicker.allowsEditing = true
        
        delegate.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    
}
