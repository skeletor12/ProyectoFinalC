//
//  realidadAumentadaView.swift
//  ProyectoFinalC
//
//  Created by Luis Rodriguez on 28/08/16.
//  Copyright © 2016 Luis Rodriguez. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class realidadAumentadaView: UIViewController, ARDataSource, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var texto: UILabel!
    
    var texto2 = ""
    var textoi = ""
    var codigoRuta : Int = 0
    var contador = 0

    
    var contexto : NSManagedObjectContext? = nil
    var contexto2 : NSManagedObjectContext? = nil
    
    let manejador = CLLocationManager()
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////Revisar el envio del valor textoi para poder seleccionar bien los puntos
    override func viewDidLoad() {
        codigoRuta=Int(codigoRuta)
        texto.text=String(textoi)
        texto2=String(textoi)
        print(textoi)
        //print(codigoRuta)
    
        iniciaRAG()
        super.viewDidLoad()
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            manejador.startUpdatingHeading()
        } else {
            manejador.stopUpdatingLocation()
            manejador.stopUpdatingHeading()
        }
        
    }
    
    
    func iniciaRAG(){
        
        let latitude = manejador.location!.coordinate.latitude
        let longitude = manejador.location!.coordinate.longitude
        let numeroElementos = contador
        
        let puntosDeInteres = obtenAnotaciones(latitud: latitude, longitud: longitude, numeroDeElementos: numeroElementos)
        
        let arViewController = ARViewController()
        arViewController.debugEnabled = true
        arViewController.dataSource = self
        arViewController.maxDistance = 0
        arViewController.maxVisibleAnnotations = 100
        arViewController.maxVerticalLevel = 5
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        
        arViewController.setAnnotations(puntosDeInteres)
        self.presentViewController(arViewController, animated: true, completion: nil)
        
    }
    
    private func obtenAnotaciones (latitud latitud: Double, longitud: Double, numeroDeElementos: Int)->Array<ARAnnotation>
    {
        var anotaciones:[ARAnnotation]=[]
        let seleccion = Puntos ()
        
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
        //let peticion = seccionEntidad?.managedObjectModel.fetchRequestTemplateForName("buscarPunto")
        
        let peticion = seccionEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("buscarPunto", substitutionVariables: ["codigo" : codigoRuta])
        
        do{
            let  seccionesEntidad = try self.contexto!.executeFetchRequest(peticion!)
            
            for seccionEntidad2 in seccionesEntidad {
                
                let nombrepunto = seccionEntidad2.valueForKey("nombrepunto") as! String
                let codigo = seccionEntidad2.valueForKey("codigo") as! Int
                let latitude = seccionEntidad2.valueForKey("latitud") as! Double
                let longitude = seccionEntidad2.valueForKey("longitud") as! Double
                contador = contador + 1
                
                seleccion.nombrePunto = nombrepunto
                seleccion.codigo = codigo
                seleccion.latitud = latitude
                seleccion.longitud = longitude
     
            let anotacion = ARAnnotation()
            anotacion.location = self.obtenerPosiciones(latitud:seleccion.latitud,longitud:seleccion.longitud)
            anotacion.title = seleccion.nombrePunto
            anotaciones.append(anotacion)
                
        }
            
        }
        
        catch _ {
            
        }
        
        return anotaciones
    }
    
    private func obtenerPosiciones(latitud latitud:Double, longitud:Double)->CLLocation
    {
        let lat = latitud
        let lon = longitud
     
        return CLLocation(latitude: lat, longitude: lon)
    }
    
    
    
    func ar(arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let vista = TestAnnotationView()
        vista.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        vista.frame = CGRect(x: 0, y: 0, width: 150, height: 60)
        return vista
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}