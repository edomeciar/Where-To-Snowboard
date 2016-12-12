//
//  SkiArea+CoreDataProperties.swift
//  Where To Snowboard
//
//  Created by Edo on 09/12/2016.
//  Copyright © 2016 eduard.mecair. All rights reserved.
//

import Foundation
import CoreData


extension SkiArea {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SkiArea> {
        return NSFetchRequest<SkiArea>(entityName: "SkiArea");
    }

    @NSManaged public var geo_lat: Double
    @NSManaged public var geo_lng: Double
    @NSManaged public var geo_zoom: Double
    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var officialWebsite: String?
    @NSManaged public var operatingStatus: String?
    @NSManaged public var region: Region?

}
