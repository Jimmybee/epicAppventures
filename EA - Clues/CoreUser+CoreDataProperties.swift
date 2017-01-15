//
//  CoreUser+CoreDataProperties.swift
//  EA - Clues
//
//  Created by James Birtwell on 15/01/2017.
//  Copyright © 2017 James Birtwell. All rights reserved.
//

import Foundation
import CoreData


extension CoreUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CoreUser> {
        return NSFetchRequest<CoreUser>(entityName: "CoreUser");
    }

    @NSManaged public var facebookId: String?
    @NSManaged public var loggedIn: Bool
    @NSManaged public var name: String?
    @NSManaged public var userTypeInt: Int16
    @NSManaged public var ownedAppventures: Set<Appventure>?
    @NSManaged public var facebookPicture: UIImage?
    @NSManaged public var pictureUrl: String?


}

// MARK: Generated accessors for ownedAppventures
extension CoreUser {

    @objc(insertObject:inOwnedAppventuresAtIndex:)
    @NSManaged public func insertIntoOwnedAppventures(_ value: Appventure, at idx: Int)

    @objc(removeObjectFromOwnedAppventuresAtIndex:)
    @NSManaged public func removeFromOwnedAppventures(at idx: Int)

    @objc(insertOwnedAppventures:atIndexes:)
    @NSManaged public func insertIntoOwnedAppventures(_ values: [Appventure], at indexes: NSIndexSet)

    @objc(removeOwnedAppventuresAtIndexes:)
    @NSManaged public func removeFromOwnedAppventures(at indexes: NSIndexSet)

    @objc(replaceObjectInOwnedAppventuresAtIndex:withObject:)
    @NSManaged public func replaceOwnedAppventures(at idx: Int, with value: Appventure)

    @objc(replaceOwnedAppventuresAtIndexes:withOwnedAppventures:)
    @NSManaged public func replaceOwnedAppventures(at indexes: NSIndexSet, with values: [Appventure])

    @objc(addOwnedAppventuresObject:)
    @NSManaged public func addToOwnedAppventures(_ value: Appventure)

    @objc(removeOwnedAppventuresObject:)
    @NSManaged public func removeFromOwnedAppventures(_ value: Appventure)

    @objc(addOwnedAppventures:)
    @NSManaged public func addToOwnedAppventures(_ values: NSOrderedSet)

    @objc(removeOwnedAppventures:)
    @NSManaged public func removeFromOwnedAppventures(_ values: NSOrderedSet)

}
