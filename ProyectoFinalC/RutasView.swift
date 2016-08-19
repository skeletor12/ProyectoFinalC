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

class RutasView: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    var origen : MKMapItem!
    var destino : MKMapItem!
    var unomas : MKMapItem!
    
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

    let manejador = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        manejador.delegate = self
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
            
            
            
        })
    }
    
    func muestraRuta(respuesta: MKDirectionsResponse){
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
    }
    
}
