//
//  Extensions.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 04/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
        
    }
    
}

extension UIImageView {
    
    public func imageFromUrl(urlString: String) {
        
        let destinationPath = UtilityManager.sharedInstance.kCache + urlString
        
        if FileManager.default.fileExists(atPath: destinationPath){
            
            DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                
                if urlString != "" {
                    
                    let image: UIImage = UIImage(contentsOfFile: destinationPath)!
                    
                    DispatchQueue.main.async {
                        
                        self.image = image
                        
                    }
                    
                }
                
            }
            
        }
            
        else {
            
            getImage(path: urlString, destinationPath: destinationPath)
            
        }
        
    }
    
    func getImage (path: String, destinationPath: String){
        
        let imageURL = NSURL(string:path)
        let request: NSURLRequest = NSURLRequest(url: imageURL! as URL)
        
        let downloadSession = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error == nil {
                // Convert the downloaded data into a UIImage object
                let finalImage = UIImage(data: data!)
                if finalImage != nil {
                    
                    do {
                        try FileManager.default.createDirectory(atPath: (destinationPath as NSString).deletingLastPathComponent, withIntermediateDirectories: true, attributes: nil)
                    } catch _ {}
                    
                    let finalURL = NSURL.init(string: destinationPath)
                    
                    do {
                        
                        try UIImagePNGRepresentation(finalImage!)?.write(to: finalURL as! URL, options: NSData.WritingOptions.atomic)
                        
                    }catch _ {
                        
                        print("Error al guardar imagen")
                        
                    }
                    
                    DispatchQueue.main.async(execute: {
                        
                        self.image = finalImage
                        
                    })
                    
                }
                
            }
            else {
                
                print( "Error: \(error!.localizedDescription)")
                
            }
            
        }
        
        downloadSession.resume()
        
    }
    
}

