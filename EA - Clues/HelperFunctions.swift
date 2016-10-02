//
//  HelperFunctions.swift
//  EpicAppventures
//
//  Created by James Birtwell on 06/01/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

extension NSLayoutConstraint {
    
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}


import Foundation
import Parse


struct  Colours {
    static let myRed = UIColor(red: 255/255, green: 58/255, blue: 33/255, alpha: 1.0)
    static let myYellow = UIColor(red: 255/255, green: 209/255, blue: 43/255, alpha: 1.0)
    static let myBlue = UIColor(red: 76/255, green: 115/255, blue: 255/255, alpha: 1.0)
    static let myGreen = UIColor(red: 23/255, green: 183/255, blue: 45/255, alpha: 1.0)
}

struct RTFs {
    static let privacyPolicy = "Appventure Privacy Policy"
    static let howToPlay = "How to Play"
    static let choosingAdventure = "Choosing Adventure"
    static let makingAnAdventure = "Making An Adventure"
}

let dataLoadedNotification = "dataLoadedNotification"
let skipLoginNotification = "skipLoginNotification"
let fbGraphLoadNotification = "fbGraphLoadNotification"
let fbImageLoadNotification = "fbImageLoadNotification"
let fbLoginParameters = ["public_profile", "email", "user_friends"]

let tutorialSeenNSDefault = "seenTutorial"

struct Storyboards {
    static let LaunchAppventure = "LaunchAppventure"
}


protocol ImagePicker: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
}

class HelperFunctions {
    
    class func openMaps( var query: String, vc: UIViewController, mapType: String = "Google") {
        
//        let address = "American Tourister, Abids Road, Bogulkunta, Hyderabad, Andhra Pradesh, India"
//        let escapedAddress = address.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
//        let urlpath = NSString(format: "http://maps.googleapis.com/maps/api/geocode/json?address=\(escapedAddress)")
//        print(urlpath)
        query = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        if let targetURLGoogle = NSURL(string:"comgooglemaps://?q=\(query)") {
            if UIApplication.sharedApplication().canOpenURL(targetURLGoogle) {
                UIApplication.sharedApplication().openURL(targetURLGoogle)
            } else if let targetURLApple = NSURL(string: "http://maps.apple.com/?q=\(query)")  {
            if UIApplication.sharedApplication().canOpenURL(targetURLApple) {
                UIApplication.sharedApplication().openURL(targetURLApple)
            }
        }
        else {
            let alert = UIAlertController(title: "Open Maps", message: "No directions available", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Cancel, handler: nil))
            
            vc.presentViewController(alert, animated: true, completion: nil)
            }
        }

    }
    
    class func formatTime(ms: Double, nano: Bool) -> String? {
        let formatter = NSDateComponentsFormatter()
        formatter.allowedUnits.insert(NSCalendarUnit.Hour)
        formatter.allowedUnits.insert(NSCalendarUnit.Minute)
        formatter.allowedUnits.insert(NSCalendarUnit.Second)
        if nano == true {
        formatter.allowedUnits.insert(NSCalendarUnit.Nanosecond)
        }
        formatter.zeroFormattingBehavior.insert(NSDateComponentsFormatterZeroFormattingBehavior.Pad)
        return formatter.stringFromTimeInterval(ms)
    }

    class func formatDistance(distance: Double) -> String {
        if distance > 9500 {
            let formattedDistance = "\(Int(distance)/1000) Km"
            return formattedDistance
        } else {
            let formattedDistance = "\(Int(distance)) m"
            return formattedDistance
            
        }
        
    }
    
    class func convertImage (image: UIImage) -> PFFile {
        let imageData = UIImagePNGRepresentation(image) as NSData!
        let imageFile = PFFile(name:"image.png", data:imageData)
        return imageFile!
    }

    class func loadAllData (appventure: Appventure) {
        for step in appventure.appventureSteps {
            if let soundFile = step.soundPFFile as PFFile! {
                soundFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if error == nil {
                        step.sound = data
                    }
                })
            }
            if let imageFile = step.imagePFFile as PFFile! {
                imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if error == nil {
                        if let dataFound = data {
                            step.image = UIImage(data: dataFound)
                        }
                    }
                })
            }
            
        }
    }
    
    class func loadAppventureSetup(object: PFObject) -> Appventure {
        let appventureName = object.objectForKey(Appventure.pfAppventure.pfTitle) as! String
        let appventureLocate = object.objectForKey(Appventure.pfAppventure.pfCoordinate) as! PFGeoPoint
        let appventurePFID = object.objectId!
        let appventure = Appventure(PFObjectID: appventurePFID, name: appventureName, geoPoint: appventureLocate)
        appventure.subtitle = object.objectForKey(Appventure.pfAppventure.pfSubtitle) as? String
        appventure.pfFile = object[Appventure.pfAppventure.pfAppventureImage] as? PFFile
        appventure.totalDistance = object[Appventure.pfAppventure.pfTotalDistance] as? Double
        return appventure
    }
    
//    MARK: ImageFunctions
    class func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let oldData = UIImageJPEGRepresentation(image, 1)
        print(oldData?.length)
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(newImage, 0.8)
        print(imageData?.length)
        let finalImage = UIImage(data: imageData!)
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    class func getImage(useCamera: Bool, delegate: ImagePicker, presenter: UIViewController) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = delegate
        
        if useCamera {
            imagePicker.sourceType = .Camera
        } else {
            imagePicker.sourceType = .PhotoLibrary
        }
        presenter.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
    class func circle(image: UIImageView) {
        image.layer.cornerRadius = image.frame.size.width / 2
        image.clipsToBounds = true
        image.layer.borderWidth = 3.0
        image.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    class func blurImage(image:UIImage, radius: Double, forRect rect: CGRect) -> UIImage?
    {
        let context = CIContext(options: nil)
        let inputImage = CIImage(CGImage: image.CGImage!)
        
        
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue((radius), forKey: kCIInputRadiusKey)
        let outputImage = filter?.outputImage
        
        var cgImage:CGImageRef?
        
        if let asd = outputImage
        {
            cgImage = context.createCGImage(asd, fromRect: rect)
        }
        
        if let cgImageA = cgImage
        {
            return UIImage(CGImage: cgImageA)
        }
        
        return nil
    }

    
    //MARK: tableFunctions
    
    class func noTableDataMessage (tableView: UITableView, message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height ))
        messageLabel.text = message
        messageLabel.textColor = UIColor.blackColor()
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.font = UIFont(name: "Palatino", size: 20)
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    //MARK: Tab functions
    
    class func unhideTabBar(vc: UIViewController){
        if let mtvc = vc.tabBarController as? MainTabBarController {
            if mtvc.stdFrame != nil {
                if mtvc.tabBar.frame != mtvc.stdFrame {
                    mtvc.tabBar.hidden = false

                    UIView.animateWithDuration(0.3, animations: {
                        mtvc.tabBar.frame = CGRectOffset(mtvc.stdFrame!, 0, 0)

                        }, completion: { (complete) in
                    })

                }
            }
        }
    }
    
    class func hideTabBar(vc: UIViewController){
        if let mtvc = vc.tabBarController as? MainTabBarController {
            if mtvc.stdFrame != nil {
                if mtvc.tabBar.frame == mtvc.stdFrame {
                    let height = mtvc.stdFrame?.size.height
                    UIView.animateWithDuration(0.3, animations: {
                        mtvc.tabBar.frame = CGRectOffset(mtvc.stdFrame!, 0, height!)
                        mtvc.tabBar.hidden = true

                        }, completion: { (complete) in
                            
                    })
                }
            }
        }
    }

    
}

extension String {
    func splitStringToArray() -> [String] {
        return self.characters.split{$0 == ","}.map(String.init)
    }
    
}


//MARK: View extensions
//ImageRotation.swift
import UIKit

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {

        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

}

//UIImage from view

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }
}

//ScrollHolderClass


class clickParentScroll : UIView {
    
    var myScroll = UIScrollView()
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        return self.pointInside(point, withEvent: event) ? myScroll : nil
    }
    
    
}