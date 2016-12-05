//
//  SkimapConstants.swift
//  Where To Snowboard
//
//  Created by Edo on 30/11/2016.
//  Copyright © 2016 eduard.mecair. All rights reserved.
//

import Foundation

//all ski resorts
//https://skimap.org/SkiAreas/index.json
//begining of regions
//https://skimap.org/Regions/view.xml

struct SkimapConstants {
    
    struct Skimap {
        static let APIScheme = "https"
        static let APIHost = "skimap.org"
        static let APIRegionsPath = "/Regions/view.xml"
        
        static func APIRegionsPathWithId(regionId: String) -> String{
            return "/Regions/view/"+regionId+".xml"
        }
    }

    struct SkimapParameterKeys {
        
    }
    
    struct SkimapParameterValues {
       
    }
    
}
