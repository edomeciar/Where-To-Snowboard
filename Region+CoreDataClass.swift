//
//  Region+CoreDataClass.swift
//  Where To Snowboard
//
//  Created by Edo on 08/12/2016.
//  Copyright © 2016 eduard.mecair. All rights reserved.
//

import Foundation
import CoreData

@objc(Region)
public class Region: NSManagedObject {
    
    convenience init(id: Int32, name: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Region", in: context){
            self.init(entity: ent,insertInto: context)
            self.id = id
            self.name = name
        }else{
            fatalError("Unable to find entity Region")
        }
    }

}
