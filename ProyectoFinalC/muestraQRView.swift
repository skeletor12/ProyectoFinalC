//
//  muestraQRView.swift
//  ProyectoFinalC
//
//  Created by Luis Rodriguez on 28/08/16.
//  Copyright © 2016 Luis Rodriguez. All rights reserved.
//

import UIKit

class muestraQRView: UIViewController {
    
    
    @IBOutlet weak var direccion: UILabel!
    @IBOutlet weak var web: UIWebView!
    var urls : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        direccion?.text = urls!
        let url = NSURL(string: urls!)
        let peticion = NSURLRequest(URL: url!)
        web.loadRequest(peticion)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}