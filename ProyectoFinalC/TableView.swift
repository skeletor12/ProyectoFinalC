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

class TableView: UITableViewController {
    
var contexto : NSManagedObjectContext? = nil
    
    
    @IBOutlet weak var ruta: UITextField!
    @IBAction func ruta(sender: AnyObject) {
        
        let punto = Rutas()
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let seccionEntidad = NSEntityDescription.entityForName("Rutas", inManagedObjectContext: self.contexto!)
        
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("busqueda")
        do{
            let  seccionesEntidad = try self.contexto?.executeFetchRequest(peticion!)
            
            for seccionEntidad2 in seccionesEntidad! {
                
                let nombreRuta = seccionEntidad2.valueForKey("nombre") as! String
                let codigoRuta = seccionEntidad2.valueForKey("codigo") as! Int
                punto.codigo = codigoRuta + 1
                punto.nombre = nombreRuta
            }
            }
        catch _ {
            
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
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
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
    
        
    }
    
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        
     // Return false if you do not want the specified item to be editable.
     return true
     }
    
    
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
   /* override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "buscados"{
            
            let buscados = segue.destinationViewController as! ViewBuscado
            let ip = self.tableView.indexPathForSelectedRow
            buscados.ISBN = libreria[ip!.row].isbn
        }
        
        if segue.identifier == "buscar"{
            segue.destinationViewController as! ViewBuscar
        }
        
        
    }*/
    
    
    
    
    
}
