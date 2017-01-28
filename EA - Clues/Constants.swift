//
//  Constants.swift
//  EA - Clues
//
//  Created by James Birtwell on 28/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation

struct Colors {
    
    static let purple = UIColor(red:0.54, green:0.25, blue:0.46, alpha:1.0)
    
}

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

struct Notifications {
    static let reloadCatalogue = "reloadCatalogue"
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

struct ViewControllerIds {
    static let Step = "StepViewController"
}
