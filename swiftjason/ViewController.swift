//
//  ViewController.swift
//  swiftjason
//
//  Created by Julio Lazcano on 28/04/16.
//  Copyright © 2016 Julio Lazcano. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var CapturaTexto: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let blueColor = UIColor(red: 255/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1.0)
        view.backgroundColor = blueColor
    }

    @IBAction func IniciarWebserviceCall(sender: UIButton) {
   // print(CapturaTexto.text)
        LlamarWs()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func removeDuplicates(array: [String]) -> [String] {
        var encountered = Set<String>()
        var result: [String] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        print(result)
        return result
    }
    
    func LlamarWs(){
        let urlstring = "http://www.liverpool.com.mx/tienda?s=\(CapturaTexto.text! as String)&format=json"
        let url = NSURL(string: urlstring)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler:{data, response, error -> Void in
            
            if(error != nil){
                print(error?.localizedDescription)
            }
            
            do {
                let jsonData : AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions.MutableContainers ) as! NSDictionary
            
                let jsonData2 = jsonData["contents"]
                if let jsonArray = jsonData2 as? NSArray{
                    jsonArray.enumerateObjectsUsingBlock({ model, index, stop in
                        let clima = model["mainContent"]
                        //print(clima)
                        if let jsonArray2 = clima as? NSArray{
                            jsonArray2.enumerateObjectsUsingBlock({ model, index, stop in
                                let clima2 = model["contents"]
                                //print(clima2)
                                if let ValorMinimo = clima2 as? NSArray{
                                    ValorMinimo.enumerateObjectsUsingBlock({ model, index, stop in
                                        let minVal = model["firstRecNum"] as! NSNumber
                                        //print(minVal)
                                    });
                                }
                                if let ValorMaximo = clima2 as? NSArray{
                                    ValorMaximo.enumerateObjectsUsingBlock({ model, index, stop in
                                        let maxVal = model["lastRecNum"] as! NSNumber
                                        //print(maxVal)
                                        
                                        if let Records = clima2 as? NSArray{
                                            Records.enumerateObjectsUsingBlock({ model, index, stop in
                                                let RecordsValues = model["records"]
                                                //print(RecordsValues)//records
                                    
                                                
                                                if let Atributos = RecordsValues as? NSArray{
                                                    Atributos.enumerateObjectsUsingBlock({ model, index, stop in
        
                                                        let AtributosValues = model["attributes"] as! NSDictionary

                                                        //print(AtributosValues)//records
                                                        var i = 0
                                                    
                                                        
                                                        for employees in AtributosValues {

                                                           let Nombre = AtributosValues.valueForKey("product.displayName") as! NSArray
                                                            
                                                            let Imagen = AtributosValues.valueForKey("sku.largeImage") as! NSArray
                                                            
                                                            
                                                            print("\(i) - \(Nombre) - \(Imagen)")
                                                            i = i + 1
                                                        };
                                                        
                                                    });
                                                }
                                           });
                                        }
                                    });
                                            
                                }
                            });
                        }
                    });
                }
                
                


            } catch _ {
                // Error
            }
        })
        task.resume()
    }


}

