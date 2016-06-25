//
//  AddressJSON.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/14/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct AddressJSON {
    
    let attributes: [String: AnyObject]
    let include: [String: AnyObject]
    
    let id: AnyObject
    let latitude: AnyObject
    let longitude: AnyObject
    let address1: AnyObject
    let street: AnyObject
    let city: AnyObject
    let stateCode: AnyObject
    let zipCode: AnyObject
    let bestCanvassResponseString: AnyObject
    
    init(address: Address) {
        id = address.id ?? NSNull()
        latitude = address.latitude ?? NSNull()
        longitude = address.longitude ?? NSNull()
        address1 = address.address ?? NSNull()
        street = address.street ?? NSNull()
        city = address.city ?? NSNull()
        stateCode = address.stateCode ?? NSNull()
        zipCode = address.zipCode ?? NSNull()
        bestCanvassResponseString = address.bestCanvassResponseString ?? NSNull()
        
        attributes = [
            "latitude": latitude,
            "longitude": longitude,
            "address": address1,
            "street": street,
            "city": city,
            "state_code": stateCode,
            "zip_code": zipCode,
            "best_canvass_response": bestCanvassResponseString
        ]

        include = [
            "type": "addresses",
            "id": id,
            "attributes": self.attributes
        ]
    }
}