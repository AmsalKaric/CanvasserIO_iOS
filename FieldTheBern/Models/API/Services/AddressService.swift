//
//  AddressService.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/2/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import MapKit
import SwiftyJSON

struct AddressService {

    let api = API()
    
    func getAddress(address: Address, callback: ((Address?, [Person]?, Bool, APIError?) -> Void)) {
        let parameters = AddressJSON(address: address).attributes
        
        api.get("addresses", parameters: parameters) { (data, success, error) in
            
            if success {
            
                // Extract addresses and people into models
                if let data = data {
                    let json = JSON(data: data)
                    
                    var people: [Person] = []
                    
                    for (_, included) in json["included"] {
                        // Check for people only
                        let type = included["type"].string
                        
                        if type == "people" {
                            let newPerson = Person(json: included)
                            people.append(newPerson)
                        }
                    }
                    
                    let addressJSON = json["data"][0]
                    let address = Address(id: addressJSON["id"].string, addressJSON: addressJSON["attributes"])

                    callback(address, people, success, nil)
                }
            } else {
                if error?.statusCode == 404 {
                    callback(nil, nil, true, error)
                } else {
                    callback(nil, nil, success, error)
                }
            }
        }
    }
    
    func getAddresses(latitude: CLLocationDegrees, longitude: CLLocationDegrees, radius: Double, callback: (([Address]?, Bool, APIError?) -> Void)) {
        
        //api.get("addresses", parameters: ["lat": "44.9206935", "longitude": "-73.1290229", "radius": radius]) { (data, success, error) in
        api.get("addresses/\(latitude)/\(longitude)", parameters: [:]) { (data, success, error) in
            
            if success {
                // Extract our addresses into models
                if let data = data {
                    
                    let json = JSON(data: data)
                    //print(json)
                    
                    var addressesArray: [Address] = []
                    //Hack- Fixed API address fetching
                    var i=0
                    for (_, included) in json {
                        if i == 100 {
                            break
                        }
                        i+=1
                        
                        // Check for addresses only
                        //let type = included["type"].string
                        
                        //if type == "addresses" {
                            let newAddress = Address(id: String(included["aid"].intValue), addressJSON: included)
                            addressesArray.append(newAddress)
                        //}
                    }
                    
                    callback(addressesArray, success, nil)
                }
                
            } else {
                // API call failed with no addresses
                callback(nil, success, error)
            }
        }
    }

}