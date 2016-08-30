//
//  Filter.swift
//  EA - Clues
//
//  Created by James Birtwell on 02/02/2016.
//  Copyright © 2016 James Birtwell. All rights reserved.
//

import Foundation

//*******Class Filter

class Filter: NSObject {
    
    
    enum sortTyping: Int {
        case Rating = 0
        case A2Z = 1
        case Distance = 2
    }
    
    enum interactivityTypes: Int {
        case All = 0
        case Static = 1
        case Interactive = 2
    }
    
    
    var sortType = sortTyping.Rating
    var interactivity = interactivityTypes.All
    var tags = [String]()
    
}