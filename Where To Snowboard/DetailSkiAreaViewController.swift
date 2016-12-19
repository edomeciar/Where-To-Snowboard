//
//  DetailSkiAreaViewController.swift
//  Where To Snowboard
//
//  Created by Edo on 17/12/2016.
//  Copyright © 2016 eduard.mecair. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreData

class DetailSkiAreaViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate{
    
    var skiArea: SkiArea!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var skiAreaNameLabel: UILabel!
    @IBOutlet weak var skiAreaOperatingStatusLabel: UILabel!
    @IBOutlet weak var webButton: UIButton!
    @IBOutlet weak var directionButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SkiArea ID:\(skiArea.id)")
        getSkiAreadata()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func displayError(_ errorString: String?) {
        guard let errorString = errorString else {
            return
        }
        let myAlert = UIAlertController(title: errorString, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    var sharedContext: NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        return stack.context
    }
    
    private func saveContext(){
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.stack.save()
        print("context saved ")
        
    }
    
    func addMapPin(){
        if skiArea.geo_lat > 0.0 && skiArea.geo_lng > 0.0{
            mapView.addAnnotation(skiArea)
            self.activityStatus.isHidden = true
            print("lan:\(self.skiArea.geo_lat) long:\(self.skiArea.geo_lng)")
            let span = MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
            let region = MKCoordinateRegion(center: skiArea.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            directionButton.isEnabled = true
        }else{
            displayError("No Loacation information for SkiArea<")
        }
        
    }
    
    func getSkiAreadata(){
        self.activityIndicator.startAnimating()
        self.activityStatus.text = "Updating..."
        self.activityStatus.isHidden = false
        SkimapClient.sharedInstance().getSkiArea(skiAreaId: skiArea.id, completitionHandler: { (skiAreaData, errorString) in
            
            //print("jsonSkiAreaData: \(skiAreaData)")
            if let errorString = errorString{
                print(errorString)
                print("Showing data from CoreData")
                DispatchQueue.main.async {
                    self.updateView()
                }
                
            }else{
                if let id = skiAreaData?[SkimapConstants.SkimapResponseKeys.Id] as? String{
                    print("Id from API: \(id)")
                }
                if let name = skiAreaData?[SkimapConstants.SkimapResponseKeys.Name] as? String{
                    print("Name from API: \(name)")
                }
                if let web = skiAreaData?[SkimapConstants.SkimapResponseKeys.OfficialWebsite] as? String{
                    print("Web page from API: \(web)")
                    self.skiArea.officialWebsite = web
                }
                if let operatingStatus = skiAreaData?[SkimapConstants.SkimapResponseKeys.OperatingStatus] as? String{
                    print("Operating Status from API: \(operatingStatus)")
                    self.skiArea.operatingStatus = operatingStatus
                }
                if let lat = skiAreaData?[SkimapConstants.SkimapResponseKeys.Latitude] as? Double{
                    print("Latitude from API: \(lat)")
                    self.skiArea.geo_lat = lat
                }
                if let lon = skiAreaData?[SkimapConstants.SkimapResponseKeys.Longitude] as? Double{
                    print("Longitude from API: \(lon)")
                    self.skiArea.geo_lng = lon
                }
                self.saveContext()
                DispatchQueue.main.async {
                    self.updateView()
                }
                
            }
            
        })
    }
    
    @IBAction func webButtonTouch(_ sender: Any) {
        if let web = skiArea.officialWebsite{
            UIApplication.shared.openURL(URL(string: web)!)
        }
    }
    @IBAction func getDirectiongTouch(_ sender: Any) {
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = skiArea.coordinate
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = "\(skiArea.name)"
        mapItem.openInMaps(launchOptions: options)
    }
    func updateView(){
        if let name = skiArea.name{
            self.skiAreaNameLabel.text = name
        }
        if let status = skiArea.operatingStatus {
            self.skiAreaOperatingStatusLabel.text = status
        }
        if let web = skiArea.officialWebsite{
            webButton.isEnabled = true
        }
        addMapPin()
        self.activityStatus.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
}
