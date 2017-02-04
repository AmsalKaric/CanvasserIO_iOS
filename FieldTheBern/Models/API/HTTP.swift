//
//  HTTP.swift
//  FieldTheBern
//
//  Created by Josh Smith on 9/29/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
//åimport p2_OAuth2
//import Alamofire
//import SwiftyJSON

typealias HTTPCallback = (Response<AnyObject, NSError>) -> Void

class HTTP {
    
    private let session: Session = Session.sharedInstance
    private let appVersionProvider = AppVersionProvider()
    
    func authorizedRequest(method: Alamofire.Method, _ url: String, parameters: [String: AnyObject]?, encoding: ParameterEncoding = .URL, callback: HTTPCallback) {
        
        // Hack- Removed authorization
        //session.authorize(.Reauthorization) { (success) -> Void in
        //    if success {
                //if let accessToken = self.session.oauth2?.accessToken {
                //let accessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbiI6IjEiLCJleHAiOjE0Njc3NTA2NjksImZiaWQiOiIxMDIwOTkxMjM1NDQ2NDY0NCIsImlhdCI6MTQ2NzY2NDI2OSwidXNlcklkIjoiMzIzNjUwIn0.StqsiiSy6SuU9ytXfbPyfa0JZkObwTo5mzF4vQEFSyk"
                    let accessToken = Canvasser.sharedCanvasser.jwtToken
                    let headers = [
                        //"User-Agent": self.appVersionProvider.versionString(),
                        //"Authorization": "Bearer \(accessToken)"
                        "authorization": "\(accessToken)"
                    ]
                    Alamofire.request(method, url, parameters: parameters, encoding: encoding, headers: headers)
                        .validate()
                        .responseJSON { response in
                            //print(response.request)  // original URL request
                            //print(response.response) // URL response
                            //print(response.data)     // server data
                            //print(response.result)   // result of response serialization
                            callback(response)
                    }
                //}
        //    }
        //}
    }
    
    func unauthorizedRequest(method: Alamofire.Method, _ url: String, parameters: [String: AnyObject]?, encoding: ParameterEncoding = .URL, callback: HTTPCallback) {

        let headers = ["User-Agent": self.appVersionProvider.versionString()]
        Alamofire.request(method, url, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseJSON { response in
                callback(response)
        }
    }
}
