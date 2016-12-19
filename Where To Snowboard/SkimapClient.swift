//
//  SkimapClient.swift
//  Where To Snowboard
//
//  Created by Edo on 30/11/2016.
//  Copyright © 2016 eduard.mecair. All rights reserved.
//

import Foundation

class SkimapClient: NSObject{
    
    
    class func sharedInstance() -> SkimapClient {
        struct Singleton {
            static var sharedInstance = SkimapClient()
        }
        return Singleton.sharedInstance
    }
    
    func getRegions(regionId: String ,completitionHandler:@escaping (_ XMLData: Data?, _ errorString: String?)->Void) {
        
        // create session and request
        let session = URLSession.shared
        let request = NSURLRequest(url: (skimapURLFromParameters(apiPath: SkimapConstants.Skimap.APIRegionsPathWithId(regionId: regionId)) as NSURL) as URL)
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(error: String) {
                print(error)
                completitionHandler(nil,error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completitionHandler(nil,"There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your request returned a status code other than 2xx!")
                completitionHandler(nil,"Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                completitionHandler(nil,"No data was returned by the request!")
                return
            }
            completitionHandler(data,nil)
            
            
        }
        
        // start the task!
        task.resume()
        
    }
    
    func getSkiArea(skiAreaId: Int32 ,completitionHandler:@escaping (_ JSONResult: NSDictionary?, _ errorString: String?)->Void){
        // create session and request
        let session = URLSession.shared
        guard let skiAreaIdString = String(skiAreaId) as? String else{
            completitionHandler(nil,"Unable to convert SkiAreaId into the string")
            return
        }
        
        let request = NSURLRequest(url: (skimapURLFromParameters(apiPath: SkimapConstants.Skimap.APISkiAreaPathWithId(skiAreaId: skiAreaIdString)) as NSURL) as URL)
        
        // create network request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // if an error occurs, print it and re-enable the UI
            func displayError(error: String) {
                completitionHandler(nil,error)
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completitionHandler(nil,"There was an error with your request: \(error)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completitionHandler(nil,"Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                completitionHandler(nil,"No data was returned by the request!")
                return
            }
            
            // parse the data
            let parsedResult: AnyObject!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
                
                /* GUARD: Is "id" key in our result? */
                guard let id = parsedResult[SkimapConstants.SkimapResponseKeys.Id] as? String else {
                    //checking only for id, API is not perfect and some SkiResorts don't have information which I need.
                    completitionHandler(nil,"Cannot find key '\(SkimapConstants.SkimapResponseKeys.Id)' in \(parsedResult)")
                    return
                }
                
                completitionHandler(parsedResult as! NSDictionary?,nil)
                
            } catch {
                completitionHandler(nil,"Could not parse the data as JSON: '\(data)'")
                return
            }
            
        }
        
        // start the task!
        task.resume()
    }
    
    private func skimapURLFromParameters(apiPath: String) -> NSURL {
        
        let components = NSURLComponents()
        components.scheme = SkimapConstants.Skimap.APIScheme
        components.host = SkimapConstants.Skimap.APIHost
        components.path = apiPath
        components.queryItems = [NSURLQueryItem]() as [URLQueryItem]?
        print(components.url!)
        return components.url! as NSURL
    }
}
