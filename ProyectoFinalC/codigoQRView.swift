//
//  codigoQRView.swift
//  ProyectoFinalC
//
//  Created by Luis Rodriguez on 28/08/16.
//  Copyright © 2016 Luis Rodriguez. All rights reserved.
//

import UIKit
import AVFoundation

class codigoQRView: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    
    
    var sesion : AVCaptureSession?
    var capa : AVCaptureVideoPreviewLayer?
    var marcoQR : UIView?
    var urls : String?
    
    
    override func viewWillAppear(animated: Bool) {
        sesion?.startRunning()
        marcoQR?.frame = CGRectZero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "QR Principal"
        let dispositivo = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        do {
            let entrada = try AVCaptureDeviceInput(device: dispositivo)
            
            sesion = AVCaptureSession()
            sesion?.addInput(entrada)
            let metaDatos = AVCaptureMetadataOutput()
            sesion?.addOutput(metaDatos)
            metaDatos.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metaDatos.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            capa = AVCaptureVideoPreviewLayer(session: sesion!)
            capa?.videoGravity = AVLayerVideoGravityResizeAspectFill
            capa?.frame = view.layer.bounds
            view.layer.addSublayer(capa!)
            marcoQR = UIView()
            marcoQR?.layer.borderWidth = 3
            marcoQR?.layer.borderColor = UIColor.redColor().CGColor
            view.addSubview(marcoQR!)
            sesion?.startRunning()
            
            
        }
            
            
        catch _ {
            
        }
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

 
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        marcoQR?.frame = CGRectZero
        if (metadataObjects == nil || metadataObjects.count == 0 ){
            return
        }
        let objMetadato = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if(objMetadato.type == AVMetadataObjectTypeQRCode){
            let objBordes = capa?.transformedMetadataObjectForMetadataObject(objMetadato as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            marcoQR?.frame = objBordes.bounds
            if (objMetadato.stringValue != nil) {
                self.urls = objMetadato.stringValue
                
                //let navc = codigoQRView.self
                performSegueWithIdentifier("codigos", sender: self)
                
              ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////Revisar esta seccion 
                //let navc = codigoQRView.self 
            
            
        }
    }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     print(urls)
        let origen = sender as! codigoQRView
                 let vc = segue.destinationViewController as! muestraQRView
                 origen.sesion?.stopRunning()
                   vc.urls = origen.urls
    }
   
    
}