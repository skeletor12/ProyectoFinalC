//
//  RutasView.swift
//  ProyectoFinalC
//
//  Created by Luis Rodriguez on 16/08/16.
//  Copyright © 2016 Luis Rodriguez. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

var arrseleccion : [Puntos] = []

class RutasView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    @IBOutlet weak var texto: UILabel!
    var texto2 = ""
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() -> String {
        // Update the user interface or the detail item.
        if let detail = self.detailItem {
            if self.texto != nil {
                texto.text = detail.valueForKey("nombre")!.description
                let texto2 = detail.valueForKey("nombre")!.description
                return texto2
            }
        }
         return texto2
    }  
 
    
   
    var codigoRuta : Int = 0
    
    var origen : MKMapItem!
    var destino : MKMapItem!
    var unomas : MKMapItem!
    
    
    override func viewWillAppear(animated: Bool) {
        codigoRuta=Int(codigoRuta)
        //print(codigoRuta)
    }
   
    var contexto : NSManagedObjectContext? = nil
    var contexto2 : NSManagedObjectContext? = nil
    
    @IBOutlet weak var zoom: UISlider!
    @IBOutlet weak var mapa: MKMapView!
    
    
    @IBOutlet weak var botones: UISegmentedControl!
    @IBAction func botones(sender: AnyObject) {
        if(botones.selectedSegmentIndex==0){
            mapa.mapType = MKMapType.Standard }
        if(botones.selectedSegmentIndex==1){
            mapa.mapType = MKMapType.Satellite }
        if(botones.selectedSegmentIndex==2){
            mapa.mapType = MKMapType.Hybrid }
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
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error porque = \(error.localizedFailureReason)")
    }

    let manejador = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        let texto2 = configureView()
        
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.desiredAccuracy = kCLLocationAccuracyKilometer;
        manejador.requestWhenInUseAuthorization()
        manejador.startMonitoringSignificantLocationChanges()
        
        
        let seleccion = Puntos ()
        
        var punto = CLLocationCoordinate2D()
        
        
        self.contexto2 = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        let seccionEntidad4 = NSEntityDescription.entityForName("Rutas", inManagedObjectContext: self.contexto2!)
        
        let peticion2 = seccionEntidad4?.managedObjectModel.fetchRequestTemplateForName("busqueda")
        do{
            let  seccionesEntidad4 = try self.contexto2?.executeFetchRequest(peticion2!)
            
            for seccionEntidad4 in seccionesEntidad4! {
                
                let isbnreq = seccionEntidad4.valueForKey("nombre") as! String
                let tituloreq = seccionEntidad4.valueForKey("codigo") as! Int
                
                if isbnreq == texto2 {
                codigoRuta = tituloreq
                //print(codigoRuta)
                }
            }
        }
        catch _ {
            
        }
    
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let seccionEntidad = NSEntityDescription.entityForName("Puntos", inManagedObjectContext: self.contexto!)
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("buscarPunto")
        do{
            let  seccionesEntidad = try self.contexto!.executeFetchRequest(peticion!)
            
            for seccionEntidad2 in seccionesEntidad {
                
                let nombrepunto = seccionEntidad2.valueForKey("nombrepunto") as! String
                let codigo = seccionEntidad2.valueForKey("codigo") as! Int
                let latitude = seccionEntidad2.valueForKey("latitud") as! Double
                let longitude = seccionEntidad2.valueForKey("longitud") as! Double
                
                /*seleccion.nombrePunto = nombrepunto
                seleccion.codigo = codigo
                seleccion.latitud = latitude
                seleccion.longitud = longitude
                
                arrseleccion.append(seleccion)*/
                
                //codigoRuta2 = configureView()
                //print(codigo)
                //print(codigoRuta)
                if codigo == codigoRuta {
                    
                    seleccion.nombrePunto = nombrepunto
                    seleccion.codigo = codigo
                    seleccion.latitud = latitude
                    seleccion.longitud = longitude
                    
                    arrseleccion.append(seleccion)
                
                punto.latitude = latitude
                punto.longitude = longitude
                
                let pin = MKPointAnnotation()
                pin.title = String(nombrepunto)
                pin.subtitle = "Lat. \(String(format:"%4.4f", punto.latitude)), Long. \(String(format:"%4.4f",punto.longitude))"
                pin.coordinate = punto
                mapa.addAnnotation(pin)
                }
            }
            }
        catch _ {
            
        }
        
        dump(arrseleccion)
       /* manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.desiredAccuracy = kCLLocationAccuracyKilometer;
        manejador.requestWhenInUseAuthorization()
        manejador.startMonitoringSignificantLocationChanges()
        mapa.delegate = self
        
        var puntoCoor = CLLocationCoordinate2D(latitude: 19.359727, longitude: -99.257700)
        var puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        origen = MKMapItem(placemark: puntoLugar)
        origen.name = "TEcnolgico de Monterrey"
        
        puntoCoor = CLLocationCoordinate2D(latitude: 19.362896, longitude: -99.268856)
        puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        destino = MKMapItem(placemark: puntoLugar)
        destino.name = "centro comercial"
        
        puntoCoor = CLLocationCoordinate2D(latitude: 19.358543, longitude: -99.276304)
        puntoLugar = MKPlacemark(coordinate: puntoCoor, addressDictionary: nil)
        unomas = MKMapItem(placemark: puntoLugar)
        unomas.name = "Glorieta"
        
        self.anotaPunto(origen!)
        self.anotaPunto(destino!)
        self.anotaPunto(unomas!)
        
        self.obtenerRuta(self.origen!, destino:self.destino!)
        self.obtenerRuta(self.destino!, destino: self.unomas!)
    }
    
    func anotaPunto(punto: MKMapItem){
        let anota = MKPointAnnotation()
        anota.coordinate = punto.placemark.coordinate
        anota.title = punto.name
        mapa.addAnnotation(anota)
    }
    
    func obtenerRuta(origen: MKMapItem, destino: MKMapItem){
        let solicitud = MKDirectionsRequest()
        solicitud.source = origen
        solicitud.destination = destino
        solicitud.transportType = .Automobile
        let indicaciones = MKDirections(request: solicitud)
        indicaciones.calculateDirectionsWithCompletionHandler({(respuesta: MKDirectionsResponse?, error: NSError?) in
            if error != nil {
                print("ERROR AL OBTENER RUTA")
                
            } else {
                self.muestraRuta(respuesta!)
            }
            
            
            
        })*/
    }
    
   /* func muestraRuta(respuesta: MKDirectionsResponse){
        for ruta in respuesta.routes{
            mapa.addOverlay(ruta.polyline, level: MKOverlayLevel.AboveRoads)
            for paso in ruta.steps {
                print(paso.instructions)
            }
            
        }
        let centro = origen.placemark.coordinate
        let region = MKCoordinateRegionMakeWithDistance(centro, 3000, 3000)
        mapa.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay : MKOverlay) -> MKOverlayRenderer {
        let renderer  = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blueColor()
        renderer.lineWidth = 3.0
        return renderer
    }*/
}
