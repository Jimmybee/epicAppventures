//
//  User.swift
//  EpicAppventures
//
//  Created by James Birtwell on 28/12/2015.
//  Copyright © 2015 James Birtwell. All rights reserved.
//

import Foundation
import Parse
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4





protocol UserDataHandler : NSObjectProtocol {
    
    func userFuncComplete(funcKey: String)
}

class User: NSObject {
    
    static let LoginViewController = "Login View Controller"
    static let userInitCompleteNotification = "userInitCompleteNotification"
    static let userLoggedOutNotification = "userLoggedOutNotification"
    static let failedParseSignup = "failedParseSignup"

    
    struct funcKeys {
        static let fbGraphLoaded = "fbGraphLoaded"
        static let fbImageLoaded = "fbImageLoaded"
        static let parseLoggedIn = "parseLoggedIn"
        static let localDataLoaded = "localDataLoaded"
        
    }
    
    struct parseCol {
        static let Class = "User"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let email = "email"
        static let mobileContact = "mobileContact"
        static let facebookId = "facebookId"

        static let authData = "authData"
        static let password = "password"


    }
    
    struct localSave {
        static let userImage = ""
    }
    
    
    static var user: User?

    var pfObject = ""
    //     var image: String?
    var firstName = ""
    var lastName = ""
    var email = ""
    var facebookId = ""
    var pictureURL: String?
    var profilePicture: UIImage?
    var blurPicture: UIImage?
    var ownedAppventures = [Appventure]()
    var friendsAppventures = [Appventure]()
    var facebookConnected = false
    var completedAdventures = 0
    var createdAventures = 0
    var facebookFriends = [UserFriend]()
    
    override init() {
        
    }
    
    init(pfUser: PFUser) {
        super.init()
        self.pfObject = pfUser.objectId!

        if let firstName = pfUser.objectForKey(parseCol.firstName) as? String {
            self.firstName = firstName
        }
        if let lastName = pfUser.objectForKey(parseCol.lastName)  as? String {
            self.lastName = lastName
        }
        if let facebookId = pfUser.objectForKey(parseCol.facebookId)  as? String {
            self.facebookId = facebookId
        }
//        self.email = pfUser.objectForKey(parseCol.email) as! String
        
        if PFFacebookUtils.isLinkedWithUser(pfUser){
            self.facebookConnected = true
            if !loadLocalData() { self.loadFBData() }
            self.getFriends()
        }
    }
    
    func loadLocalData() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("localSave") {
            let normalPath = setFullPath("/profilePicture.png")
            if let image = UIImage(contentsOfFile: normalPath) {
                self.profilePicture = image
            } else {
                return false
            }
            let blurPath = setFullPath("/blurImage.png")
            if let image = UIImage(contentsOfFile: blurPath) {
                self.blurPicture = image
            } else {
                return false
            }
            return true
        }
        return false
    }
    
    
    func logout() {
        //Spinner
        PFUser.logOutInBackgroundWithBlock { (error) in
            if error == nil {
                User.user = nil
                NSNotificationCenter.defaultCenter().postNotificationName(User.userLoggedOutNotification, object: self)
            } else {
                //Handle Error
            }

        }
        
    }
    
    func updateUser() { //Save function
        if let currentUser = PFUser.currentUser() as PFUser! {
            currentUser[parseCol.firstName] = self.firstName
            currentUser[parseCol.lastName] = self.lastName
            currentUser[parseCol.email] = self.email
            currentUser[parseCol.facebookId] = self.facebookId

            currentUser.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if let error = error {
                    let errorString = error.userInfo["error"] as? NSString
                    print(errorString)
                } else {
                    print("savedUser")
                }
            }
        }
    }
    
    //MARK: Load FB Data
    
    func loadFBData() {
        let fbGraph = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "email, first_name, last_name, gender, picture.type(large)"]) //
        fbGraph.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if error != nil {
                print("Error: \(error)")
            }
            else {
                //                self.facebookID = result.valueForKey("id") as! String
                self.firstName = result.valueForKey("first_name") as! String
                self.lastName = result.valueForKey("last_name") as! String
                print(self.lastName)
                self.email = result.valueForKey("email") as! String
                self.pictureURL = result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String
                self.facebookId = result.valueForKey("id") as! String
                self.pfObject = (PFUser.currentUser()?.objectId)!
                self.updateUser()
            }
        })
    }
    
    func getFriends() {
        self.facebookFriends.removeAll()
         let fbGraph = FBSDKGraphRequest.init(graphPath: "me/friends", parameters: ["fields": "first_name, last_name, picture.type(small)"])
        fbGraph.startWithCompletionHandler({ (connection, result, error) -> Void in
            if error != nil {
                print("Error: \(error)")
            }
            else {
                if let friendArray = result.objectForKey("data") as? NSArray {
                    for friend in friendArray {
                        if let pictureURL = friend.valueForKeyPath("picture.data.url") as? String {
                            let friendFirstName = friend.valueForKey("first_name") as! String
                            let friendLastName = friend.valueForKey("last_name") as! String
                            let id = friend.valueForKey("id") as! String
                            let url = NSURL(string: pictureURL)
                            let userFriend = UserFriend(id: id, firstName: friendFirstName, lastName: friendLastName, url: url!)
                            self.facebookFriends.append(userFriend)
                        }
                    }
                }
                
            }
        })
    }
    
    func getFBImage() {
        if let url = self.pictureURL as String! {
            if let getURL = NSURL(string: url) {
                if let data = NSData(contentsOfURL: getURL){
                    self.profilePicture = UIImage(data: data)
                    NSNotificationCenter.defaultCenter().postNotificationName(fbImageLoadNotification, object: self)
                }
            }
        }
    }
    
    func setFullPath(filename: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let docs: String = paths[0] as String!
        return docs.stringByAppendingString(filename)
    }
    
    
    func saveLocalData() {
        if let isImage = self.profilePicture as UIImage! {
            if let data = UIImagePNGRepresentation(isImage) {
                let fullPath = setFullPath("/profilePicture.png")
                 data.writeToFile(fullPath, atomically: true)
            }
        }
        
        if let blurImage = self.blurPicture {
            if let data = UIImagePNGRepresentation(blurImage) {
                let fullPath = setFullPath("/blurImage.png")
                data.writeToFile(fullPath, atomically: true)
            }
        }

        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "localSave")
    }


    
    //MARK: Class functions
    
    static func singUpLogIn(email: String, password: String, restore: ()) {
        
        let defaultCenter = NSNotificationCenter.defaultCenter()
        let pfUser = PFUser.currentUser()
        pfUser?.username = email
        pfUser?.email = email
        pfUser?.password = password
        pfUser?.signUpInBackgroundWithBlock({ (success, error) in
            if error != nil {
                print(error)
                if error?.code == 202 {
                    PFUser.logInWithUsernameInBackground(email, password: password, block: { (user, error) in
                        if error != nil {
                            defaultCenter.postNotificationName(failedParseSignup, object: nil)
                        }
                        if user != nil {
                            User.user = User(pfUser: PFUser.currentUser()!)
                            defaultCenter.postNotificationName(userInitCompleteNotification, object: nil)
                            restore
                        }
                    })
                } else {
                    defaultCenter.postNotificationName(failedParseSignup, object: nil)
                    restore
                }
            }
            if success {
                if let user = PFUser.currentUser() {
                    User.user = User(pfUser: user)
                    defaultCenter.postNotificationName(userInitCompleteNotification, object: nil)
                    restore
                }
            }
            
        })
    }
    
    static func checkLogin(required: Bool, vc: UIViewController?) -> Bool {
        if User.user == nil  {
            if PFUser.currentUser()?.objectId == nil {
                return false
            } else {
                User.user = User(pfUser: PFUser.currentUser()!)
                return true
            }
        } else {
            return true
        }
    }
    
    
}