//
//  mapa.swift
//  ProyectoFinalC
//
//  Created by Luis Rodriguez on 16/08/16.
//  Copyright © 2016 Luis Rodriguez. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

var localizados : [Puntos] = []
var ruta : [Rutas] = []


class mapaView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    
    var codigoRuta : Int = 0
    let puntoDatos = Puntos()
    let envioRuta = Rutas()
    
    
    @IBOutlet weak var nombrePunto: UITextField!
    
    @IBOutlet weak var zoom: UISlider!
    
    @IBOutlet weak var botones: UISegmentedControl!
    
    @IBAction func botones(sender: AnyObject) {
        
        if(botones.selectedSegmentIndex==0){
            mapa.mapType = MKMapType.Standard }
        if(botones.selectedSegmentIndex==1){
            mapa.mapType = MKMapType.Satellite }
        if(botones.selectedSegmentIndex==2){
            mapa.mapType = MKMapType.Hybrid }
    }
    
    
    
    @IBOutlet weak var mapa: MKMapView!
    
    let manejador = CLLocationManager()
    
    
    var contexto : NSManagedObjectContext? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let punto = Puntos()
        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let seccionEntidad = NSEntityDescription.entityForName("Rutas", inManagedObjectContext: self.contexto!)
        
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("busqueda")
        do{
            let  seccionesEntidad = try self.contexto?.executeFetchRequest(peticion!)
            
            for seccionEntidad2 in seccionesEntidad! {
                
                let isbnreq = seccionEntidad2.valueForKey("nombre") as! String
                let tituloreq = seccionEntidad2.valueForKey("codigo") as! Int
                punto.codigo = tituloreq
                punto.nombrePunto = isbnreq
                //localizados.append(punto)
            }
            
        }
        catch _ {
            
        }*/
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.desiredAccuracy = kCLLocationAccuracyKilometer;
        manejador.requestWhenInUseAuthorization()
        manejador.startMonitoringSignificantLocationChanges()
    }
    
    @IBAction func nombrePunto(sender: AnyObject) {
        
        puntoDatos.nombrePunto = String(self.nombrePunto.text!)
        
        var punto = CLLocationCoordinate2D()
        punto.latitude = (manejador.location?.coordinate.latitude)!
        punto.longitude = (manejador.location?.coordinate.longitude)!
        
        let pin = MKPointAnnotation()
        pin.title = String(self.nombrePunto.text!)
        pin.subtitle = "Lat. \(String(format:"%4.4f", punto.latitude)), Long. \(String(format:"%4.4f",punto.longitude))"
        pin.coordinate = punto
        mapa.addAnnotation(pin)
        

        
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let seccionEntidad = NSEntityDescription.entityForName("Rutas", inManagedObjectContext: self.contexto!)
        
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("busqueda")
        do{
            let  seccionesEntidad = try self.contexto?.executeFetchRequest(peticion!)
            
            for seccionEntidad2 in seccionesEntidad! {
                
                let nombreRuta = seccionEntidad2.valueForKey("nombre") as! String
                let ultimoCodigo = seccionEntidad2.valueForKey("codigo") as! Int
                /*if ultimoCodigo != 0 {
                    puntoDatos.codigo = ultimoCodigo + 1
                } else {
                puntoDatos.codigo = 1
                }*/
                
                puntoDatos.codigo = ultimoCodigo
                envioRuta.nombre = nombreRuta
               
               
            }
        }
        catch _ {
            
        }
        
        let nuevaSeccionEntidad = NSEntityDescription.insertNewObjectForEntityForName("Puntos", inManagedObjectContext: self.contexto!)
        
        do {
           
            nuevaSeccionEntidad.setValue(puntoDatos.nombrePunto, forKey: "nombrepunto")
            nuevaSeccionEntidad.setValue(puntoDatos.codigo, forKey: "codigo")
            nuevaSeccionEntidad.setValue(punto.latitude, forKey: "latitud")
            nuevaSeccionEntidad.setValue(punto.longitude, forKey: "longitud")
            try self.contexto?.save()
        }
            
        catch _ {
            
        }
        
        
        /*puntoDatos.nombrePunto = String(self.nombrePunto.text!)
        puntoDatos.latitud = (manejador.location?.coordinate.latitude)!
        puntoDatos.longitud = (manejador.location?.coordinate.longitude)!
        
        localizados.append(puntoDatos)
        print(puntoDatos.codigo)
        dump(localizados)*/
        
    }
   
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        } else {
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let center = CLLocationCoordinate2D(latitude: manager.location!.coordinate.latitude, longitude: manager.location!.coordinate.longitude)
        
        let zoomx = Double(zoom.value)
        let zoomin = zoomx * 0.005
        
        
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpanMake(zoomin, zoomin))
        self.mapa.setRegion(region, animated: true)
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error porque = \(error.localizedFailureReason)")
    }
    
    
    @IBAction func trazar(sender: AnyObject) {
  
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "Trazando" {
            let ruta = envioRuta
            let controller = segue.destinationViewController as! RutasView
            controller.textoi = ruta.nombre
            controller.selector = 2
        }
        
        if segue.identifier == "Realidad" {
            let ruta = envioRuta
            let controller = segue.destinationViewController as! realidadAumentadaView
            controller.textoi = ruta.nombre
        }
        
        
    }
    
}
