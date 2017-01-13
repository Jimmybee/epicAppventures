//
//  UserFriendList.swift
//  EA - Clues
//
//  Created by James Birtwell on 24/08/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation

class UserFriend: NSObject {
    
    let firstName: String
    let lastName: String
    let pictureURL: URL
    let id: String
    let profilePicture: UIImage? = nil
    
    
    init(id: String, firstName: String, lastName: String,  url: URL) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.pictureURL = url
        
    }
    
}
