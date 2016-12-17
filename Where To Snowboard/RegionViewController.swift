//
//  RegionViewController.swift
//  Where To Snowboard
//
//  Created by Edo on 30/11/2016.
//  Copyright © 2016 eduard.mecair. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class RegionViewController: UIViewController, XMLParserDelegate, NSFetchedResultsControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var parser = XMLParser()
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var regionLvl0PickerView: UIPickerView!
    @IBOutlet weak var regionLvl1PickerView: UIPickerView!
    @IBOutlet weak var regionLvl2PickerView: UIPickerView!
    
    var regionLvl0 = [Region]()
    var regionLvl1 = [Region]()
    var regionLvl2 = [Region]()
    var selectedLvl0: Int!
    var selectedLvl1: Int!
    var selectedLvl2: Int!
    var parsingRegionLevel: Int = 0
    //helper variable, which represent if parser in in tag Regions
    var inRegions = false
    //tmpRegion
    var tmpRegionId: Int32?
    
    var skiAreas = [SkiArea]()
    var tmpSkiAreaId: Int32?
    
    var foundCharacters = "";
    
    var regionFetchedResultController: NSFetchedResultsController<Region>!
    var skiAreaFetchedResultController: NSFetchedResultsController<SkiArea>!
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.isEnabled = false
        
        regionLvl0PickerView.tag = 0
        regionLvl1PickerView.tag = 1
        regionLvl2PickerView.tag = 2
        
        print("get test xml")
        
        //test if regions exist in CoreData
        getRegions()
        getSkiAreas()
        if skiAreas.count > 0{
            prepareToLoadSkiAreas()
        }
        if(regionLvl0.count == 0){
            loadRegions(regionId: "")
        }
    
    }
    
    func getRegions(){
        let regionRequest = NSFetchRequest<Region>(entityName: "Region")
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        regionRequest.sortDescriptors = [idSort]
        
        regionFetchedResultController = NSFetchedResultsController(fetchRequest: regionRequest, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        regionFetchedResultController.delegate = self
        do{
            try regionFetchedResultController.performFetch()
            if let regions = regionFetchedResultController.fetchedObjects as [Region]?{
                for region in regions{
                    if region.level == 0{
                        regionLvl0.append(region)
                    }else if region.level == 1{
                        regionLvl1.append(region)
                    }else if region.level == 2{
                        regionLvl2.append(region)
                    }
                }
                DispatchQueue.main.async {
                    self.regionLvl0PickerView.reloadAllComponents()
                    self.regionLvl1PickerView.reloadAllComponents()
                    self.regionLvl2PickerView.reloadAllComponents()
                    self.setSelectedRegion(regionsArray: self.regionLvl0, regionsPickerView: self.regionLvl0PickerView)
                    self.setSelectedRegion(regionsArray: self.regionLvl1, regionsPickerView: self.regionLvl1PickerView)
                    self.setSelectedRegion(regionsArray: self.regionLvl2, regionsPickerView: self.regionLvl2PickerView)
                    
                }
            }
        }catch{
            fatalError("Fail to init regionFetchedResultController \(error)")
        }
    }
    
    func getSkiAreas(){
        let skiAraRequest = NSFetchRequest<SkiArea>(entityName: "SkiArea")
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        skiAraRequest.sortDescriptors = [idSort]
        
        skiAreaFetchedResultController = NSFetchedResultsController(fetchRequest: skiAraRequest, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        skiAreaFetchedResultController.delegate = self
        do{
            try skiAreaFetchedResultController.performFetch()
            if let skiAreas = skiAreaFetchedResultController.fetchedObjects as [SkiArea]?{
                self.skiAreas = skiAreas
                print("SkiAreas fetched from core data with count: \(skiAreas.count)")
            }
        }catch{
            fatalError("Fail to init regionFetchedResultController \(error)")
        }
    }
    
    func loadRegions(regionId: String){
        SkimapClient.sharedInstance().getRegions(regionId: regionId, completitionHandler: { (xmlData, errorString) in
            
            print("xmlString: \(xmlData)")
            if let errorString = errorString{
                print(errorString)
            }else{
                self.parser = XMLParser(data: xmlData!)
                self.parser.delegate = self
                self.parser.parse()
            }
            
        })
    }
    
    func addRegion(newRegion: Region){
        if parsingRegionLevel == 0{
            newRegion.level = 0
            regionLvl0.append(newRegion)
        }else if parsingRegionLevel == 1{
            newRegion.level = 1
            regionLvl1.append(newRegion)
        }else if parsingRegionLevel == 2{
            newRegion.level = 2
            regionLvl2.append(newRegion)
        }
    }
    
    func setSelectedRegion(regionsArray: [Region], regionsPickerView: UIPickerView){
        if regionsArray.count > 0{
            for row in 0...regionsArray.count-1 {
                if regionsArray[row].selected{
                    regionsPickerView.selectRow(row, inComponent: 0, animated: true)
                }
            }
        }else{
            print("no regions in array")
        }
        
    }
    
    func deleteAllRegions(regions: [Region]){
        for region in regions{
            sharedContext.delete(region)
        }
    }
    
    func deleteAllSkiAreas(skiAreas: [SkiArea]){
        for skiArea in skiAreas{
            sharedContext.delete(skiArea)
        }
    }
    
    func prepareToLoadSkiAreas(){
        if skiAreas.count > 0{
            infoLabel.text = "\(skiAreas.count) found in selected Region"
            searchButton.isEnabled = true
        }
        
        
        print("count of SkiAreas \(skiAreas.count)")
    }
    
    @IBAction func showSkiAreasTouchUpAction(_ sender: Any) {
        performSegue(withIdentifier: "showTabBarContollerSegue", sender: self)
        
    }
    //Picker View 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return regionLvl0.count
        } else if pickerView.tag == 1 {
            return regionLvl1.count
        } else if pickerView.tag == 2 {
            return  regionLvl2.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            if let name = regionLvl0[row].name{
                return name
            }
        } else if pickerView.tag == 1 {
            return regionLvl1[row].name
        } else if pickerView.tag == 2 {
            return regionLvl2[row].name
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.deleteAllSkiAreas(skiAreas: skiAreas)
        skiAreas.removeAll()
        if pickerView.tag == 0 {
            print("selected in lvl0 \(regionLvl0[row].name)")
            self.selectRegion(regionArray: regionLvl0, selectedRow: row)
            selectedLvl0 = row
            parsingRegionLevel = 1
            self.deleteAllRegions(regions: regionLvl1)
            regionLvl1.removeAll()
            regionLvl1PickerView.reloadAllComponents()
            loadRegions(regionId: String(regionLvl0[row].id))
            
        } else if pickerView.tag == 1 {
            print("selected in lvl0 \(regionLvl1[row].name)")
            self.selectRegion(regionArray: regionLvl1, selectedRow: row)
            selectedLvl0 = row
            parsingRegionLevel = 2
            self.deleteAllRegions(regions: regionLvl2)
            regionLvl2.removeAll()
            regionLvl2PickerView.reloadAllComponents()
            loadRegions(regionId: String(regionLvl1[row].id))
            
        } else if pickerView.tag == 2 {
            print("tag 2 skiareas count\(skiAreas.count)")
            self.selectRegion(regionArray: regionLvl2, selectedRow: row)
            prepareToLoadSkiAreas()
        }
    }
    
    
    
    func selectRegion(regionArray: [Region], selectedRow: Int){
        for region in regionArray{
            if region == regionArray[selectedRow]{
                region.selected = true
            }else{
                region.selected = false
            }
        }
        self.saveContext()
    }
    
    
    //parser delegata
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.foundCharacters = ""
        if(elementName == "regions"){
            inRegions = true
        }
        if(elementName == "region"){
            if let id = Int32(attributeDict["id"]!){
                tmpRegionId = id
            }
            
        }
        if(elementName == "skiArea"){
            if let id = Int32(attributeDict["id"]!){
                tmpSkiAreaId = id
            }
        }
        //var region = Region()
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "region" && inRegions){
            print(self.foundCharacters)
            if let id = tmpRegionId{
                let newRegion = Region(id: id, name: self.foundCharacters, context: self.sharedContext)
                addRegion(newRegion: newRegion)
            }
        }
        if(elementName == "regions"){
            inRegions = false
        }
        if(elementName == "skiArea"){
            if let id = tmpSkiAreaId{
                let newSkiArea = SkiArea(id: id, name: self.foundCharacters, context: self.sharedContext)
                skiAreas.append(newSkiArea)
            }
        }
        self.foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            if self.skiAreas.count > 0{
                self.prepareToLoadSkiAreas()
            }else{
                if self.parsingRegionLevel == 0{
                    self.regionLvl0PickerView.reloadAllComponents()
                    self.regionLvl1PickerView.isHidden = true
                    self.regionLvl2PickerView.isHidden = true
                }else if self.parsingRegionLevel == 1{
                    self.regionLvl1PickerView.reloadAllComponents()
                    self.regionLvl1PickerView.isHidden = false
                    self.regionLvl2PickerView.isHidden = true
                }else if self.parsingRegionLevel == 2{
                    self.regionLvl2PickerView.reloadAllComponents()
                    self.regionLvl2PickerView.isHidden = false
                }
            }
            self.prepareToLoadSkiAreas()
            self.saveContext()
        }
    }
    
}

