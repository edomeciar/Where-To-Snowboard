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
