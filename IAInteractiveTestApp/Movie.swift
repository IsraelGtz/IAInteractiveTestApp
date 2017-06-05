//
//  Movie.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 04/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import Foundation

class Movie {     //: NSObject, NSCoding {
    
    var id: String! = nil
    var title: String! = nil
    var originalTitle: String! = nil
    var genre: String! = nil
    var clasification: String! = nil
    var duration: String! = nil
    var director: String! = nil
    var actors: String! = nil
    var synopsis: String! = nil
    var imageName: String! = nil
    var imagesNameForMultimedia: [String]! = nil
    var videoNameForMultimedia: [String]! = nil
    var schedule: [String: Array<String>]! = nil

  
    
//    init(newId: String, newIdCity: String, newAddress: String, newPhone: String, newLatitude: String, newLongitude: String, newName: String, newUrl: String) {
//        
//        self.id = newId
//        self.idCity = newIdCity
//        self.phone = newPhone
//        self.address = newAddress
//        self.latitude = newLatitude
//        self.longitude = newLongitude
//        self.name = newName
//        self.url = newUrl
//        
//    }
//    
//    required convenience init(coder aDecoder: NSCoder) {
//        
//        let id = aDecoder.decodeObject(forKey: "id") as! String
//        let idCity = aDecoder.decodeObject(forKey: "idCity") as! String
//        let phone = aDecoder.decodeObject(forKey: "phone") as! String
//        let latitude = aDecoder.decodeObject(forKey: "latitude") as! String
//        let longitude = aDecoder.decodeObject(forKey: "longitude") as! String
//        let name = aDecoder.decodeObject(forKey: "name") as! String
//        let address = aDecoder.decodeObject(forKey: "address") as! String
//        let url = aDecoder.decodeObject(forKey: "url") as! String
//        
//        self.init(newId: id, newIdCity: idCity, newAddress: address, newPhone: phone, newLatitude: latitude, newLongitude: longitude, newName: name, newUrl: url)
//        
//    }
//    
//    func encode(with aCoder: NSCoder) {
//        
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(idCity, forKey: "idCity")
//        aCoder.encode(phone, forKey: "phone")
//        aCoder.encode(latitude, forKey: "latitude")
//        aCoder.encode(longitude, forKey: "longitude")
//        aCoder.encode(name, forKey: "name")
//        aCoder.encode(address, forKey: "address")
//        aCoder.encode(url, forKey: "url")
//        
//    }
    
}
