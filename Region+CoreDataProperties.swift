//
//  Region+CoreDataProperties.swift
//  Where To Snowboard
//
//  Created by Edo on 06/12/2016.
//  Copyright © 2016 eduard.mecair. All rights reserved.
//

import Foundation
import CoreData


extension Region {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Region> {
        return NSFetchRequest<Region>(entityName: "Region");
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var level: Int16
    @NSManaged public var type: String?
    @NSManaged public var geo_lat: Double
    @NSManaged public var geo_lng: Double
    @NSManaged public var geo_zoom: Double
    @NSManaged public var parent: Region?
    @NSManaged public var skiarea: NSSet?

}

// MARK: Generated accessors for skiarea
extension Region {

    @objc(addSkiareaObject:)
    @NSManaged public func addToSkiarea(_ value: SkiArea)

    @objc(removeSkiareaObject:)
    @NSManaged public func removeFromSkiarea(_ value: SkiArea)

    @objc(addSkiarea:)
    @NSManaged public func addToSkiarea(_ values: NSSet)

    @objc(removeSkiarea:)
    @NSManaged public func removeFromSkiarea(_ values: NSSet)

}
