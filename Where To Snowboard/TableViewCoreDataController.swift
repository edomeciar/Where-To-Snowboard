//
//  TableViewCoreDataController.swift
//  Where To Snowboard
//
//  Created by Edo on 15/12/2016.
//  Copyright © 2016 eduard.mecair. All rights reserved.
//

import UIKit
import CoreData

class TableViewCoreDataController: CoreDataTableViewController{
    
    @IBOutlet weak var changeRegionButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the title
        title = "SkiAreas"
        
        // Get the stack
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        // Create a fetchrequest
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "SkiArea")
        fr.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        // Create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    @IBAction func changeRegionButtonAction(_ sender: Any) {
        print("change region")
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // This method must be implemented by our subclass. There's no way
        // CoreDataTableViewController can know what type of cell we want to
        // use.
        
        // Find the right notebook for this indexpath
        let sa = fetchedResultsController!.object(at: indexPath) as! SkiArea
        
        // Create the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "SkiAreaCell", for: indexPath)
        
        // Sync notebook -> cell
        cell.textLabel?.text = sa.name
        cell.detailTextLabel?.text = sa.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let context = fetchedResultsController?.managedObjectContext, let skiArea = fetchedResultsController?.object(at: indexPath) as? SkiArea, editingStyle == .delete {
            context.delete(skiArea)
        }
    }
    
}
