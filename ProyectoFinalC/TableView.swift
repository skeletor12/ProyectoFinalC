//
//  TableView.swift
//  ProyectoFinalC
//
//  Created by Luis Rodriguez on 16/08/16.
//  Copyright © 2016 Luis Rodriguez. All rights reserved.
//

import UIKit
import CoreData

var punteria : [Rutas] = []
var arrseleccion : [Puntos] = []

class TableView: UITableViewController, NSFetchedResultsControllerDelegate  {
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var contexto : NSManagedObjectContext? = nil
    var ultimoCodigo : Int = 0
    let punto = Rutas()
    
    func busqueda() -> Int {
    self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let seccionEntidad = NSEntityDescription.entityForName("Rutas", inManagedObjectContext: self.contexto!)
    
    let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("busqueda")
    do{
    let  seccionesEntidad = try self.contexto?.executeFetchRequest(peticion!)
    
    for seccionEntidad2 in seccionesEntidad! {
        
        let isbnreq = seccionEntidad2.valueForKey("nombre") as! String
        let tituloreq = seccionEntidad2.valueForKey("codigo") as! Int
        punto.codigo = tituloreq
        punto.nombre = isbnreq
        punteria.append(punto)
        //let nombreRuta = seccionEntidad2.valueForKey("nombre") as! String
    //let codigoRuta = seccionEntidad2.valueForKey("codigo") as! Int
    //punto.codigo = codigoRuta + 1
    //punto.nombre = nombreRuta
    //let ultimoCodigo = seccionEntidad2.valueForKey("codigo") as! Int
       //punto.codigo = ultimoCodigo
    }
        
    }
        catch _ {
            
        } 
   
        return punto.codigo
        
       
    }
    
    @IBOutlet weak var ruta: UITextField!
    @IBAction func ruta(sender: AnyObject) {
        busqueda()
        
        if punto.codigo == 0 {
            punto.codigo =  1
        } else {
            punto.codigo = punto.codigo +  1
        }
        
    let nuevaSeccionEntidad = NSEntityDescription.insertNewObjectForEntityForName("Rutas", inManagedObjectContext: self.contexto!)
    
        do {
        let Ruta=String(self.ruta.text!)
        nuevaSeccionEntidad.setValue(Ruta, forKey: "nombre")
        nuevaSeccionEntidad.setValue(punto.codigo, forKey: "codigo")
        try self.contexto?.save()
            
            }
    
    catch _ {
    
    }
    

    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        punteria.removeAll()
        self.title = "RUTAS PREVIAS"
        
        let punto = Rutas()
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        let seccionEntidad = NSEntityDescription.entityForName("Rutas", inManagedObjectContext: self.contexto!)
        
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("busqueda")
        do{
            let  seccionesEntidad = try self.contexto?.executeFetchRequest(peticion!)
            
            for seccionEntidad2 in seccionesEntidad! {
                
                let isbnreq = seccionEntidad2.valueForKey("nombre") as! String
                let tituloreq = seccionEntidad2.valueForKey("codigo") as! Int
                punto.codigo = tituloreq
                punto.nombre = isbnreq
                punteria.append(punto)
                print(punto.nombre)
                print(punto.codigo)
                dump(punteria)
              
                
            }
            

            
        }
        catch _ {
            
        }
       
        // Uncomment the following line to preserve selection between presentations
       // self.clearsSelectionOnViewWillAppear = true
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
  

    override func viewWillAppear(animated: Bool) {
    //self.tableView.endUpdates()
    //tableView.reloadData()
    super.viewWillAppear(animated) }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // ---------------------------MARK: - Table view data source
    
 /*   override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of row
        
        return punteria.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)
        
        // Configure the cell...
        
        cell.textLabel!.text = punteria[indexPath.row].nombre
        
        
        return cell
    
        
    }*/
    
    
    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        let itemToMove = punteria[fromIndexPath.row]
        punteria.removeAtIndex(fromIndexPath.row)
        punteria.insert(itemToMove, atIndex: toIndexPath.row)
        
    }
 
    
    
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
    
    
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Celda", forIndexPath: indexPath)
        let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
        self.configureCell(cell, withObject: object)
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let context = self.fetchedResultsController.managedObjectContext
            context.deleteObject(self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject)
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                //print("Unresolved error \(error), \(error.userInfo)")
                
                abort()
            }
        }
    }
    
    func configureCell(cell: UITableViewCell, withObject object: NSManagedObject) {
        cell.textLabel!.text = object.valueForKey("nombre")!.description
    }
    
    // MARK: - Fetched results controller
    
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Rutas", inManagedObjectContext: self.contexto!)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "codigo", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.contexto!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, withObject: anObject as! NSManagedObject)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
    
            /*if segue.identifier == "Trazando" {
                  let indexPath = self.tableView.indexPathForSelectedRow
                    let object = self.fetchedResultsController.objectAtIndexPath(indexPath!)
                    let controller = segue.destinationViewController as! RutasView
                    controller.codigoRuta = punteria[object.row].codigo
                }*/
        
        /*
        let buscados = segue.destinationViewController as! ViewBuscado
        let ip = self.tableView.indexPathForSelectedRow
        buscados.ISBN = libreria[ip!.row].isbn
 */
        
        
        /*if segue.identifier == "Trazando" {
                    //envio = object.valueForKey("nombre")!.description
                        let envio = busqueda()
                    print(punto.codigo)
                        let sigVista=segue.destinationViewController as! RutasView
                        sigVista.codigoRuta = punto.codigo
        }*/
        
        
            if segue.identifier == "Trazando" {
                let indexPath = self.tableView.indexPathForSelectedRow
                    let object = self.fetchedResultsController.objectAtIndexPath(indexPath!)
                    let controller = segue.destinationViewController as! RutasView
                    controller.detailItem = object
                controller.selector = 1
                    
                
            
        }
        
        
}
}

    

        


