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
    
    @IBOutlet weak var regionLvl0PickerView: UIPickerView!
    @IBOutlet weak var regionLvl1PickerView: UIPickerView!
    @IBOutlet weak var regionLvl2PickerView: UIPickerView!
    
    var regionLvl0 = [Region]()
    var regionLvl1 = [Region]()
    var regionLvl2 = [Region]()
    
    var foundCharacters = "";
    
    var sharedContext: NSManagedObjectContext{
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        return stack.context
    }
    
    private func saveContext(){
        do{
            let delegate = UIApplication.shared.delegate as! AppDelegate
            try delegate.stack.save()
            print("context saved ")
        }catch let error as NSError {
            print("context NOT saved \(error)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        regionLvl0PickerView.tag = 0
        regionLvl1PickerView.tag = 1
        regionLvl2PickerView.tag = 2
        
        print("get test xml")
        
        //test if regions exist in CoreData
        if(false){
            //Regions exist in CoreData
        }else{
            loadRegions()
        }
    
    }
    
    func loadRegions(){
        SkimapClient.sharedInstance().getRegions(regionId: "", completitionHandler: { (xmlData, errorString) in
            
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
    
    //Picker View 
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if regionLvl0PickerView.tag == 0 {
            return regionLvl0.count
        } else if regionLvl1PickerView.tag == 1 {
            return regionLvl1.count
        } else if regionLvl2PickerView.tag == 2 {
            return  regionLvl2.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if regionLvl0PickerView.tag == 0 {
            if let name = regionLvl0[row].name{
                return name
            }else{
                return "B"
            }
        } else if regionLvl1PickerView.tag == 1 {
            return regionLvl1[row].name
        } else if regionLvl2PickerView.tag == 2 {
            return regionLvl2[row].name
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if regionLvl0PickerView.tag == 0 {
            print("selected in lvl0 \(regionLvl0[row].name)")
        } else if regionLvl1PickerView.tag == 1 {
            print("selected in lvl0 \(regionLvl1[row].name)")
        } else if regionLvl2PickerView.tag == 2 {
            print("selected in lvl0 \(regionLvl2[row].name)")
        }
    }
    
    
    
    //parser delegata
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.foundCharacters = ""
        if(elementName == "region"){
            
        }
        //var region = Region()
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if(elementName == "region"){
            print(self.foundCharacters)
            let tmpRegion = Region(name: self.foundCharacters, context: self.sharedContext)
            regionLvl0.append(tmpRegion)
            //print(self.foundCharacters)
        }
        self.foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.foundCharacters += string
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.regionLvl0PickerView.reloadAllComponents()
            print(self.regionLvl0)
        }
        
    }
    
}

