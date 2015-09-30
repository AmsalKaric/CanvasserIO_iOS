//
//  API.swift
//  GroundGame
//
//  Created by Josh Smith on 9/29/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation

class API {
    private let http = HTTP()
    private let baseURL = "http://api.lvh.me:3000"
    
    func get(endpoint: String, ids: [Int]?) {
//        if let ids = ids {
            let url = baseURL + "/" + endpoint
//        }
        http.authorizedRequest(.GET, url, parameters: nil) { response in
            switch response.result {
            case .Success:
                print(response.data!)
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func post(endpoint: String, parameters: [String: AnyObject]?, callback: (NSData?, Bool) -> Void) {

        let url = baseURL + "/" + endpoint
        
        if let parameters = parameters {
            http.authorizedRequest(.POST, url, parameters: ["data": ["attributes": parameters]]) { response in
                switch response.result {
                case .Success:
                    callback(response.data, true)
                case .Failure(let error):
                    callback(nil, false)
                }
            }
        }
    }
    
    func unauthorizedPost(endpoint: String, parameters: [String: AnyObject]?, callback: (NSData?, Bool) -> Void) {
        
        let url = baseURL + "/" + endpoint
        
        if let parameters = parameters {
            http.unauthorizedRequest(.POST, url, parameters: ["data": ["attributes": parameters]]) { response in
                switch response.result {
                case .Success:
                    callback(response.data, true)
                case .Failure(let error):
                    callback(nil, false)
                }
            }
        }
    }
}