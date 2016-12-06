//
//  Region+CoreDataClass.swift
//  Where To Snowboard
//
//  Created by Edo on 06/12/2016.
//  Copyright © 2016 eduard.mecair. All rights reserved.
//

import Foundation
import CoreData


public class Region: NSManagedObject {
    
    convenience init(name : String, context : NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Region", in: context){
            self.init(entity: ent,insertInto: context)
            self.name = name
        }else{
            fatalError("Unable to find entity Region")
        }
    }

}
