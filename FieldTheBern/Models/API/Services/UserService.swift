//
//  UserService.swift
//  FieldTheBern
//
//  Created by Josh Smith on 9/29/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

struct UserService {
    
    typealias UserResponse = (User?, Bool, APIError?) -> Void
    
    let api = API()

    func createUser(email email: String, password: String, firstName: String, lastName: String, photoString: String?, callback: UserResponse) {
        let json = UserJSON(firstName: firstName, lastName: lastName, email: email, password: password, facebookId: nil, facebookAccessToken: nil, base64PhotoData: photoString).json

        api.unauthorizedPost("users", parameters: json.object as? [String : AnyObject]) { (data, success, error) in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func createUser(email email: String, password: String, firstName: String, lastName: String, facebookAccessToken: String?, facebookId: String?, photoString: String?, callback: UserResponse) {
        let json = UserJSON(firstName: firstName, lastName: lastName, email: email, password: password, facebookId: facebookId, facebookAccessToken: facebookAccessToken, base64PhotoData: photoString).json
        
        api.unauthorizedPost("users", parameters: json.object as? [String : AnyObject]) { (data, success, error) in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func get(id: String, callback: UserResponse) {
        api.get("users", parameters: ["id": id]) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func me(callback: UserResponse) {
        /*var obj: NSData? = nil
        let jsonObject: [String:AnyObject] = [
            "id": "abc",
            "first_name": "Ricky",
            "last_name": "Tan",
            "email": "rickyt@triads.com",
            "total_points": 1337,
            "visits_count": 69
        ]
        
        do {
            obj = try NSJSONSerialization.dataWithJSONObject(jsonObject, options: .PrettyPrinted)
        } catch let error {
            print(error)
        }*/
        
        api.get("me", parameters: nil) { (data, success, error) -> Void in
            self.handleUserResponse(data, true, error, callback: callback)
        }
    }
    
    func editMe(json: UserJSON, callback: UserResponse) {
        api.put("me", parameters: json.json.object as? [String : AnyObject]) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func updateMyDevice(deviceToken: String, callback: UserResponse) {
        let parameters = DeviceJSON(deviceToken: deviceToken).json

        api.post("devices", parameters: parameters.object as? [String : AnyObject]) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func editMePhoto(photoString: String, callback: UserResponse) {
        let parameters = UserJSON(base64PhotoData: photoString).json
        
        api.put("users/me", parameters: parameters.object as? [String : AnyObject]) { (data, success, error) -> Void in
            self.handleUserResponse(data, success, error, callback: callback)
        }
    }
    
    func checkUserWithFacebookIdExists(facebookId: String, callback: (userExists: Bool, apiSuccess: Bool, APIError?) -> Void) {
        /*let parameters: JSON = [
            "data": [
                "attributes": [
                    "facebook_id": facebookId
                ]
            ]
        ]*/
        
        //Hack - prevent user check.
        callback(userExists: true, apiSuccess: true, nil)
        return
        
        /*api.unauthorizedGet("users/lookup", parameters: parameters.object as? [String : AnyObject]) { (data, success, error) -> Void in
            if success {
                if let data = data {
                    let json = JSON(data: data)
                    
                    if json["data"].count > 0 {
                        callback(userExists: true, apiSuccess: success, error)
                    } else {
                        callback(userExists: false, apiSuccess: success, error)
                    }

                } else {
                    callback(userExists: false, apiSuccess: success, error)
                }
            } else {
                callback(userExists: false, apiSuccess: success, error)
            }
        }*/
    }
    
    //Hack- Added
    func getUsersForAddress(address: Address?, callback: (([Person]?, Bool, APIError?) -> Void)) {
        
        api.get("voters?aid=\(address!.id!)", parameters: [:]) { (data, success, error) in
            
            if success {
                if let data = data {
                    
                    let json = JSON(data: data)
                    //print("$$got back: \(json)")
                    var personsArray: [Person] = []
                    
                    for (_, included) in json {
                        let newPerson = Person(firstName: included["first_name"].string,
                                               lastName: included["last_name"].string,
                                               partyAffiliation: nil,
                                               canvassResponse: CanvassResponse.Unknown)
                        personsArray.append(newPerson)
                    }
                    callback(personsArray, success, nil)
                }
                
            } else {
                callback(nil, success, error)
            }
        }
    }
    
    func handleUserResponse(data: NSData?, _ success: Bool, _ error: APIError?, callback: UserResponse) {
        if success {
            // Extract our user into a model
            if let data = data {
                
                let json = JSON(data: data)
                //print(json)
                
                let user = User(json: json[0])
                
                callback(user, success, nil)
            }
        } else {
            print(error)
            callback(nil, success, error)
        }
    }
}