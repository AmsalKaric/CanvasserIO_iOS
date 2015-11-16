//
//  Person.swift
//  GroundGame
//
//  Created by Josh Smith on 10/9/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON
import UIKit

public struct Person {
    let id: String?
    var firstName: String?
    var lastName: String?

    var partyAffiliation: PartyAffiliation = .Unknown
    var canvass_: CanvassResponse = .Unknown
    var atHomeStatus: Bool = false
    var askedToLeave: Bool = true
    
    // Only set; never displayed in app
    var phone: String?
    var email: String?
    var preferredContactMethod: String?
    var previouslyParticipatedInCaucusOrPrimary: Bool?
    
    var name: String? {
        get {
            if let first = firstName, last = lastName {
                return "\(first) \(last)"
            } else {
                return firstName
            }
        }
    }
    
    var canvass_String: String {
        get {
            return canvass_.description()
        }
    }
    
    var partyAffiliationString: String {
        get {
            return partyAffiliation.title()
        }
    }
    
    var partyAffiliationImage: UIImage? {
        get {
            return partyAffiliation.image()
        }
    }
    
    init() {
        self.id = nil
        firstName = nil
        lastName = nil
        partyAffiliation = .Unknown
        canvass_ = .Unknown
        email = nil
        phone = nil
        preferredContactMethod = nil
    }
    
    init(json: JSON) {
        self.id = json["id"].string
        let attributes = json["attributes"]
        firstName = attributes["first_name"].string
        lastName = attributes["last_name"].string
        
        if let partyAffiliationString = attributes["party_affiliation"].string {
            partyAffiliation = PartyAffiliation.fromJSONString(partyAffiliationString)
        }
        
        if let response = attributes["canvass_response"].string {
            canvass_ = CanvassResponse.fromJSONString(response)
        }

    }
    
    init(firstName: String?, lastName: String?, partyAffiliation: String?, canvass_: CanvassResponse) {
        self.id = nil
        self.firstName = firstName
        self.lastName = lastName
        
        if let partyAffiliationString = partyAffiliation {
            setPartyAffiliation(partyAffiliationString)
        }
        
        self.canvass_ = canvass_
    }
    
    private mutating func setPartyAffiliation(partyAffiliationString: String) {
        self.partyAffiliation = PartyAffiliation.fromString(partyAffiliationString)
    }
}