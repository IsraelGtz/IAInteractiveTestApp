//
//  ServerManager.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 03/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import Foundation
import Alamofire
class ServerManager: NSObject {
    
    static let sharedInstance = ServerManager()
    
    static let developmentServer = ""
    static let productionServer  = "http://api.cinepolis.com.mx"
    let typeOfServer = productionServer
    
    func getAllTheCitiesCinepolis(actionsToMakeWhenSucceeded: @escaping (_ arrayOfComplexCities: Array<ComplexCity>) -> Void, actionsToMakeWhenFailed: @escaping () -> Void) {
        
        let urlToRequest = "\(typeOfServer)/Consumo.svc/json/ObtenerCiudades"
        
        var requestConnection = URLRequest.init(url: NSURL.init(string: urlToRequest)! as URL)
        requestConnection.httpMethod = "GET"

            
        Alamofire.request(requestConnection)
            .validate(statusCode: 200..<400)
            .responseJSON{ response in
                if response.response?.statusCode == 200 {
                        
                    let json = try! JSONSerialization.jsonObject(with: response.data!, options: [])
                    
                    var arrayOfComplex: Array<ComplexCity> = Array<ComplexCity>()
                    
                    let arrayOfRawComplex = (json as? Array<[String: AnyObject]> != nil ? json as! Array<[String: AnyObject]> : Array<[String: AnyObject]>())
                    
                    for complex in arrayOfRawComplex {
                        
                        let newState = complex["Estado"] as? String != nil ? complex["Estado"] as! String : ""
                        let newId = complex["Id"] as? Int != nil ? String(complex["Id"] as! Int) : ""
                        let newIdState = complex["IdEstado"] as? Int != nil ? String(complex["IdEstado"] as! Int) : ""
                        let newIdCountry = complex["IdPais"] as? Int != nil ? String(complex["IdPais"] as! Int) : ""
                        let newLatitude = complex["Latitud"] as? Double != nil ? String(complex["Latitud"] as! Double) : ""
                        let newLongitude = complex["Longitud"] as? Double != nil ? String(complex["Longitud"] as! Double) : ""
                        let newName = complex["Nombre"] as? String != nil ? complex["Nombre"] as! String : ""
                        let newCountry = complex["Pais"] as? String != nil ? complex["Pais"] as! String : ""
                        let newUris = complex["Uris"] as? String != nil ? complex["Uris"] as! String : ""
                        
                        let newComplexCity = ComplexCity.init(newId: newId, newState: newState, newIdState: newIdState, newIdCountry: newIdCountry, newLatitude: newLatitude, newLongitude: newLongitude, newName: newName, newCountryName: newCountry, newUris: newUris)
                        
                        arrayOfComplex.append(newComplexCity)
                        
                    }
                        
                    actionsToMakeWhenSucceeded(arrayOfComplex)
                        
                } else {
                        
                    print("\(response.response?.statusCode)")
                        
                    if response.response?.statusCode == 400 {
                            
                        do {
                                
                            let json = try JSONSerialization.jsonObject(with: response.data!, options: [])
                                
                            if json as? NSDictionary != nil {
                                    
                                let message = (json as! NSDictionary)["status"] as? String != nil ? (json as! NSDictionary)["status"] as! String : ""
                                    
                                if message == "Some message to check" {
                                        
                                    actionsToMakeWhenFailed()
                                    
                                }
                                    
                                    
                            }
                                
                        } catch(_) {
                                
                            let alertController = UIAlertController(title: "ERROR",
                                                                        message: "Connection error with server. Try again later.",
                                                                        preferredStyle: UIAlertControllerStyle.alert)
                                
                            let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                                    
                                actionsToMakeWhenFailed()
                                    
                            }
                            alertController.addAction(cancelAction)
                                
                            let actualController = UtilityManager.sharedInstance.currentViewController()
                            actualController.present(alertController, animated: true, completion: nil)
                                
                        }
                            
                    }
                        
                    actionsToMakeWhenFailed()
                        
                }
        }
        
    }
    
    
    func requestToGetSqliteOfComplex(complexId: String, actionsToDoWhenSucceded: @escaping (_ destinationURL: URL?)->Void, actionsToDoWhenFailed: @escaping ()->Void ) {
        
        let urlToRequest = "\(typeOfServer)/sqlite.aspx?idCiudad=\(complexId)"
        
        var requestConnection = URLRequest.init(url: NSURL.init(string: urlToRequest)! as URL)
        requestConnection.httpMethod = "GET"
        requestConnection.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let keyForFile = "complex_\(complexId).sqlite"
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(keyForFile)
            
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        
        Alamofire.download(requestConnection, to: destination).response { response in
            
            if response.response?.statusCode == 200 {
                
                UserDefaults.standard.set(response.destinationURL, forKey: keyForFile)
                actionsToDoWhenSucceded(response.destinationURL)
                
            } else {
                
                let alertController = UIAlertController(title: "ERROR",
                                                        message: "Error de conexión con el servidor. Se buscara base de datos en dispositivo",
                                                        preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                    
                    let urlForFile = UserDefaults.standard.value(forKey: keyForFile) as? URL
                    
                    if urlForFile != nil {
                      
                        actionsToDoWhenSucceded(urlForFile)
                        
                    } else {
                        
                        let alertController = UIAlertController(title: "ERROR",
                                                                message: "No hay base de datos en dispositivo. Se requiere conexion al servidor",
                                                                preferredStyle: UIAlertControllerStyle.alert)
                        
                        let cancelAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
      
                            actionsToDoWhenFailed()
                            
                        }
                        
                        alertController.addAction(cancelAction)
                        
                        let actualController = UtilityManager.sharedInstance.currentViewController()
                        actualController.present(alertController, animated: true, completion: nil)
                    
                    }
                    
                }
                alertController.addAction(cancelAction)
                
                let actualController = UtilityManager.sharedInstance.currentViewController()
                actualController.present(alertController, animated: true, completion: nil)
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}


