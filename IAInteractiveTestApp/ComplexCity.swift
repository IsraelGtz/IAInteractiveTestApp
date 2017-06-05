//
//  ComplexCity.swift
//  IAInteractiveTestApp
//
//  Created by Alejandro Aristi C on 04/06/17.
//  Copyright © 2017 Israel Gutierrez. All rights reserved.
//

import Foundation

class ComplexCity: NSObject, NSCoding {
    
    var state: String! = nil
    var id: String! = nil
    var idState: String! = nil
    var idCountry: String! = nil
    var latitude: String! = nil
    var longitude: String! = nil
    var name: String! = nil
    var countryName: String! = nil
    var uris: String! = nil
    
    init(newId: String, newState: String, newIdState: String, newIdCountry: String, newLatitude: String, newLongitude: String, newName: String, newCountryName: String, newUris: String) {
    
        self.id = newId
        self.state = newState
        self.idState = newIdState
        self.idCountry = newIdCountry
        self.latitude = newLatitude
        self.longitude = newLongitude
        self.name = newName
        self.countryName = newCountryName
        self.uris = newUris
        
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let state = aDecoder.decodeObject(forKey: "state") as! String
        let id = aDecoder.decodeObject(forKey: "id") as! String
        let idState = aDecoder.decodeObject(forKey: "idState") as! String
        let idCountry = aDecoder.decodeObject(forKey: "idCountry") as! String
        let latitude = aDecoder.decodeObject(forKey: "latitude") as! String
        let longitude = aDecoder.decodeObject(forKey: "longitude") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let countryName = aDecoder.decodeObject(forKey: "countryName") as! String
        let uris = aDecoder.decodeObject(forKey: "uris") as! String
        
        self.init(newId: id, newState: state, newIdState: idState, newIdCountry: idCountry, newLatitude: latitude, newLongitude: longitude, newName: name, newCountryName: countryName, newUris: uris)
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(state, forKey: "state")
        aCoder.encode(id, forKey: "id")
        aCoder.encode(idState, forKey: "idState")
        aCoder.encode(idCountry, forKey: "idCountry")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(countryName, forKey: "countryName")
        aCoder.encode(uris, forKey: "uris")
        
    }
    
}
