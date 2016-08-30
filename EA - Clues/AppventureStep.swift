//
//  AppventureStep.swift
//  MapPlay
//
//  Created by James Birtwell on 08/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import Foundation
import MapKit
import Parse



 class AppventureStep: NSObject {
    
     static let appventureStepsHc = "appventureStepsHc"
    
     struct setup {
        static let textClue = "textClue"
        static let pictureClue = "pictureClue"
        static let soundClue = "soundClue"
        static let checkIn = "checkIn"
        static let isLocation = "isLocation"
        static let locationShown = "locationShown"
        static let compassShown = "compassShown"
        static let distanceShown = "distanceShown"
    }
    
     struct pfStep {
        static let pfClass = "AppventureStep"
        static let pfStepNumber = "stepNumber"
        static let pfNameOrLocation = "nameOrLocation"
        static let pfCheckInProximity = "checkInProximity"
        static let pfLocationSubtitle = "locationSubtitle"
        static let pfGeoPoint = "coordinate"
        static let pfInitialText = "intialText"
        static let pfAnswerText = "answerTextArray"
        static let pfAppventureIDKey = "appventureID"
        static let pfAnswerHintText = "answerHintArray"
        static let pfAnswerFormatText = "answerFormat"
        static let pfCompletionText = "completionText"
        static let pfStepImage = "stepImage"
        static let pfStepSound = "stepSound"
        static let pfFreeHints = "freeHints"
        static let pfHintPenalty = "hintPenalty"
        static let pfSetup = "Setup"
        
    }

     var PFObjectID: String? = ""//Given at point of save/load
     var AppventurePFObjectID: String?  = "" //Given at point of save/load
    
     //Required for valid save
     var stepNumber: Int? // Given on creation
     var nameOrLocation = "set location"
     var locationSubtitle = "set location"
     var initialText = ""
     var image: UIImage?
     var imagePFFile: PFFile?
     var sound: NSData?
     var soundPFFile: PFFile?
    
     var coordinate = kCLLocationCoordinate2DInvalid
     //var placemark: MKPlacemark?
    
     var answerText = [String]()
     var answerHint = [String]()
     var freeHints: Int = 0
     var hintPenalty: Int = 0
     var answerFormatHint = "" 
     var completionText = ""
 
     var locationHidden = true
     var checkInProximity = 0
    
     var saved = false
    
     var setup: [String:Bool] = [
        AppventureStep.setup.textClue : Bool(),
        AppventureStep.setup.pictureClue : Bool(),
        AppventureStep.setup.soundClue : Bool(),
        AppventureStep.setup.checkIn : Bool(),
        AppventureStep.setup.isLocation : Bool(),
        AppventureStep.setup.locationShown : Bool(),
        AppventureStep.setup.compassShown : Bool(),
        AppventureStep.setup.distanceShown : Bool(),
    ]
    
    override init() {
        
    }

    init(object: PFObject) {
        super.init()
        self.PFObjectID = object.objectId as String!
        self.AppventurePFObjectID = object.objectForKey(pfStep.pfAppventureIDKey) as? String
        self.nameOrLocation = object.objectForKey(pfStep.pfNameOrLocation) as! String
        self.checkInProximity = object.objectForKey(pfStep.pfCheckInProximity) as! Int
        self.locationSubtitle = object.objectForKey(pfStep.pfLocationSubtitle) as! String
        self.initialText = object.objectForKey(pfStep.pfInitialText) as! String
        if let answerArray = object.objectForKey(pfStep.pfAnswerText) as? [String] {
            self.answerText = answerArray
        }
        if let hintArray = object.objectForKey(pfStep.pfAnswerHintText) as? [String] {
            self.answerHint = hintArray
        }
        self.answerFormatHint = object.objectForKey(pfStep.pfAnswerFormatText) as! String
        self.completionText = object.objectForKey(pfStep.pfCompletionText) as! String
        self.stepNumber = object.objectForKey(pfStep.pfStepNumber) as? Int
        self.freeHints = object.objectForKey(pfStep.pfFreeHints) as! Int
        if let penalty = object.objectForKey(pfStep.pfHintPenalty) as? Int {
            self.hintPenalty = penalty
        }
        self.saved = true
        self.imagePFFile = object[pfStep.pfStepImage] as? PFFile
        self.soundPFFile = object[pfStep.pfStepSound] as? PFFile
        let setupString = object[pfStep.pfSetup] as! String
        self.setup = AppventureStep.convertStringToDictionary(setupString)!
        if let point = object.objectForKey(pfStep.pfGeoPoint) as? PFGeoPoint {
            self.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude)
        } else {
            self.coordinate = CLLocationCoordinate2D()
        }
    }
    
    func save(){
        if self.PFObjectID == "" {
            let saveObj = PFObject(className: pfStep.pfClass)
            saveObject(saveObj)
        } else {
            ParseFunc.getParseObject(self.PFObjectID!, pfClass:  pfStep.pfClass, objFunc: saveObject)
        }
    }
    
    private func saveObject(save: PFObject) {
        if let jsonString = convertDictToJson(self.setup) {
            save[pfStep.pfSetup] = jsonString
            print(jsonString)
        }
        if let isImage = self.image as UIImage! {
            save[pfStep.pfStepImage] = HelperFunctions.convertImage(isImage)
        }
        if let isSound = self.sound as NSData! {
            save[pfStep.pfStepSound] = PFFile(name: "sound.caf", data: isSound)
        }
        save[pfStep.pfAppventureIDKey] = self.AppventurePFObjectID
        save[pfStep.pfNameOrLocation] = self.nameOrLocation
        save[pfStep.pfLocationSubtitle] = self.locationSubtitle
        save[pfStep.pfInitialText] = self.initialText
        save[pfStep.pfAnswerText] = self.answerText
        save[pfStep.pfAnswerHintText] = self.answerHint
        save[pfStep.pfAnswerFormatText] = self.answerFormatHint
        save[pfStep.pfStepNumber] = self.stepNumber!
        save[pfStep.pfCompletionText] = self.completionText
        save[pfStep.pfCheckInProximity] = self.checkInProximity
        save[pfStep.pfFreeHints] = self.freeHints
        save[pfStep.pfHintPenalty] = self.hintPenalty
        save[pfStep.pfGeoPoint] = PFGeoPoint(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
        save.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
            } else {
                self.PFObjectID = save.objectId!
                print("savedStep")
            }
        }
    }

    
    class func loadSteps(appventure: Appventure, vc: ParseQueryHandler) {
        let query = PFQuery(className: pfStep.pfClass)
        query.whereKey(pfStep.pfAppventureIDKey, equalTo: appventure.PFObjectID!)
        query.limit = 20
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                appventure.appventureSteps.removeAll() //TODO: check if load really neccessary
                for object in objects! {
                    let step = AppventureStep(object: object)
                    appventure.appventureSteps.append(step)
                }
                vc.handleQueryResults(nil, handlerCase: appventureStepsHc)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    
     class func convertStringToDictionary(text: String) -> [String:Bool]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String:AnyObject]
                if let dict = json as! [String: Bool]! {
                    return dict
                }
            } catch {
                print("failedToLoadDict")
            }
            
        }
        
        return nil
        
    }
    
     func convertDictToJson(dict: [String: Bool]) -> String? {
        do {
            let theJSONData = try NSJSONSerialization.dataWithJSONObject(dict , options: NSJSONWritingOptions(rawValue: 0))
            let theJSONText = NSString(data: theJSONData, encoding: NSASCIIStringEncoding) as! String
            return String(theJSONText)
            
        } catch {
            print("failedToCreateString")
            return nil
        }
    }


}

//copy init
extension AppventureStep {
    
    convenience init(step: AppventureStep) {
        self.init()
        self.PFObjectID = step.PFObjectID
        self.AppventurePFObjectID = step.AppventurePFObjectID
        self.nameOrLocation = step.nameOrLocation
        self.locationSubtitle = step.locationSubtitle
        self.initialText = step.initialText
        self.answerText = step.answerText
        self.answerHint = step.answerHint
        self.answerFormatHint = step.answerFormatHint
        self.completionText = step.completionText
        self.stepNumber = step.stepNumber
        self.freeHints = step.freeHints
        self.hintPenalty = step.hintPenalty
        self.saved =  step.saved
        self.image = step.image
        self.imagePFFile = step.imagePFFile
        self.soundPFFile = step.soundPFFile
        self.sound = step.sound
        self.setup = step.setup
        self.coordinate = step.coordinate
        self.checkInProximity = step.checkInProximity
    }
    
}
