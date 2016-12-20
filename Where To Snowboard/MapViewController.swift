//
//  MapViewController.swift
//  Where To Snowboard
//
//  Created by Edo on 14/12/2016.
//  Copyright © 2016 eduard.mecair. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    var skireagionsWithGeo = [SkiArea]()
    
    var fetchedResultController: NSFetchedResultsController<SkiArea>!
    
    var sharedContext: NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        return stack.context
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
        getSkiAreas()
    }
    
    func displayError(_ errorString: String?) {
        guard let errorString = errorString else {
            return
        }
        let myAlert = UIAlertController(title: errorString, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        myAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(myAlert, animated: true, completion: nil)
    }
    
    func getSkiAreas(){
        let skiAreaRequest = NSFetchRequest<SkiArea>(entityName: "SkiArea")
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        skiAreaRequest.sortDescriptors = [idSort]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: skiAreaRequest, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        do{
            try fetchedResultController.performFetch()
            if let skiAreas = fetchedResultController.fetchedObjects as [SkiArea]? {
                print("Fetched SkiAreas")
                for skiArea in skiAreas {
                    if (skiArea.geo_lat > 0 || skiArea.geo_lat < 0) && (skiArea.geo_lng > 0 || skiArea.geo_lng < 0){
                        print("SkiArea lat: \(skiArea.geo_lat), SkiArea long: \(skiArea.geo_lng)")
                        mapView.addAnnotation(skiArea)
                        skireagionsWithGeo.append(skiArea)
                    }
                }
                if skireagionsWithGeo.count > 0{
                    mapView.showAnnotations(skireagionsWithGeo, animated: true)
                }else{
                    displayError("No skiAreas saved with Location")
                }
            }
            
        }catch{
            fatalError("Fail to init FetchRequestPinController \(error)")
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("pin selected")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let skiArea = view.annotation as! SkiArea
            print("pin detail selected")
            performSegue(withIdentifier: "ShowDetailViewFromMapSegue", sender: skiArea)
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("prepare for segue in map view")
        if segue.identifier == "ShowDetailViewFromMapSegue"{
            let skiArea = sender as! SkiArea
            let detailSkiAreaView = segue.destination as! DetailSkiAreaViewController
            detailSkiAreaView.skiArea = skiArea
        }
    }
    
}
