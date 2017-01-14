//
//  CoreUser+CoreDataProperties.swift
//  EA - Clues
//
//  Created by James Birtwell on 14/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension CoreUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreUser> {
        return NSFetchRequest<CoreUser>(entityName: "CoreUser");
    }

    @NSManaged public var name: String?
    @NSManaged public var ownedAppventures: NSSet?
    //

}

// MARK: Generated accessors for ownedAppventures
extension CoreUser {

    @objc(addOwnedAppventuresObject:)
    @NSManaged public func addToOwnedAppventures(_ value: Appventure)

    @objc(removeOwnedAppventuresObject:)
    @NSManaged public func removeFromOwnedAppventures(_ value: Appventure)

    @objc(addOwnedAppventures:)
    @NSManaged public func addToOwnedAppventures(_ values: NSSet)

    @objc(removeOwnedAppventures:)
    @NSManaged public func removeFromOwnedAppventures(_ values: NSSet)

}
