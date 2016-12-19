//
//  SkimapConstants.swift
//  Where To Snowboard
//
//  Created by Edo on 30/11/2016.
//  Copyright © 2016 eduard.mecair. All rights reserved.
//

import Foundation

//Skimap API
//https://skimap.org/pages/Developers

struct SkimapConstants {
    
    struct Skimap {
        static let APIScheme = "https"
        static let APIHost = "skimap.org"
        static let APIRegionsPath = "/Regions/view.xml"
        
        static func APIRegionsPathWithId(regionId: String) -> String{
            return "/Regions/view/"+regionId+".xml"
        }
        
        static func APISkiAreaPathWithId(skiAreaId: String) -> String{
            return "/SkiAreas/view/"+skiAreaId+".json"
        }
    }
    
    struct SkimapResponseKeys {
        static let Id = "id"
        static let Name = "name"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let OfficialWebsite = "official_website"
        static let OperatingStatus = "operating_status"
    }
    
    struct SkimapResponseValues {
        static let OKStatus = "ok"
    }
    
}
