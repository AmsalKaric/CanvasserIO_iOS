
//
//  APIURL.swift
//  FieldTheBern
//
//  Created by Josh Smith on 10/3/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

struct APIURL {
    
    #if Local
        static let url = "https://api.canvasser.io/api/v1"
    #endif

    #if Staging
        static let url = "http://api.groundgameapp-staging.com"
    #endif
    
    #if Production
        static let url = "https://api.fieldthebern.com"
    #endif
}