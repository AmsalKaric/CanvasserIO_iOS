//
//  Session.swift
//  FieldTheBern
//
//  Created by Josh Smith on 9/29/15.
//  Copyright © 2015 Josh Smith. All rights reserved.
//

import Foundation
import p2_OAuth2
import KeychainAccess
import FBSDKLoginKit
import Parse
import SwiftyJSON

enum SessionType {
    case Email, Facebook, Keychain, Reauthorization
}

class Session {
    
    typealias SuccessResponse = (Bool) -> Void
    typealias OAuth2Response = (wasFailure: Bool, error: NSError?) -> Void
    
    static let sharedInstance = Session()
    
    private init() {}

    var oauth2: OAuth2PasswordGrant?
    
    private let keychain = Keychain(service: "io.canvasser")
    
    func authorize(type: SessionType, email: String? = nil, password: String? = nil, facebookToken: FBSDKAccessToken? = nil, callback: SuccessResponse) {
        switch type {
        case .Email:
            guard let email = email else { callback(false); break }
            guard let password = password else { callback(false); break }
            self.oauthAuthorize(email, password: password, callback: callback)
        case .Facebook:
            print("Trying to authorize...")
            guard let token = facebookToken else { print("Nope"); callback(false); break }
            print("Authorized!!")
            print(token.userID)
            let fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: nil);
            fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                if error == nil {
                    print("User Info : \(result)")
                } else {
                    print("Error Getting Info \(error)");
                }
            }
            // Hack-
            self.authorizeWithFacebook(token: token, callback: callback)
            //callback(true)
        case .Keychain:
            self.attemptAuthorizationFromKeychain(callback)
        case .Reauthorization:
            self.reauthorize(callback)
        }
    }
    
    func logout() {
        self.oauth2?.forgetTokens()
        
        // Reset everything in the keychain
        keychain["email"] = nil
        keychain["password"] = nil
        keychain["facebookId"] = nil
        keychain["facebookAccessToken"] = nil
        keychain["lastAuthentication"] = nil
        
        FBSDKLoginManager().logOut()
    }
    
    private func reauthorize(callback: SuccessResponse) {
        self.internalAuthorize(self.oauth2) { (wasFailure, error) -> Void in
            callback(!wasFailure)
        }
    }
    
    private func authorizeWithFacebook(token token: FBSDKAccessToken, callback: SuccessResponse) {
        print(#function)
        
        // Reset other login information if this is a different facebook user
        if let facebookId = keychain["facebookId"] {
            if token.userID != facebookId {
                keychain["email"] = nil
                keychain["password"] = nil
            }
        }
        print("setting keychain...")

        keychain["facebookId"] = token.userID
        keychain["facebookAccessToken"] = token.tokenString
        keychain["lastAuthentication"] = "facebook"
        
        print("keychain facebookId: \(keychain["facebookId"])")
        
        self.attemptAuthorizationFromKeychain(callback)

        //Hack- commented out
        //self.oauthAuthorize("facebook", password: token.tokenString, callback: callback)
    }
    
    private func oauthAuthorize(email: String, password: String, callback: SuccessResponse) {
        print(#function)
        
        let settings = [
            "client_id": OAuth.ClientId,
            "client_secret": OAuth.ClientSecret,
            "authorize_uri": OAuth.AuthorizeURI,
            "token_uri": OAuth.TokenURI,
            "scope": "",
            "redirect_uris": ["myapp://oauth/callback"],   // don't forget to register this scheme
            "keychain": true,
            "username": email,
            "password": password
            ] as OAuth2JSON
        
        oauth2?.forgetTokens() // We must explicitly call this to avoid data hanging around
        
        self.oauth2 = OAuth2PasswordGrant(settings: settings)
        
        if email != "facebook" {
            keychain["email"] = email
            keychain["password"] = password
            keychain["lastAuthentication"] = "email"
        }
        
        self.internalAuthorize(self.oauth2) { (wasFailure, error) -> Void in
            if !wasFailure {
                // Update device token for push notifications
                if let token = PFInstallation.currentInstallation().deviceToken {
                    UserService().updateMyDevice(token, callback: { (success) -> Void in
                        // Do nothing
                    })
                }
            }
            
            callback(!wasFailure)
        }
    }
        
    private func authorizeWithFacebook(tokenString tokenString: String, callback: SuccessResponse) {
        print(#function)
        
        let api = API()
        
        let parameters: [String: AnyObject] = [
            "UserToken": tokenString
        ]
        //Make request to auth endpoint.
        api.post("auth/facebook", parameters: parameters, encoding: .JSON) { (data, success, error) in
            if success {
                // Extract our visit into a model
                if let data = data {
                    
                    let json = JSON(data: data)
                    let saveToken = json["token"]
                    print("Got saveToken: '\(saveToken)'")
                    callback(success)
                }
            } else {
                callback(success)
            }
        }
        
        //Grab token and store it for future use.
        
        //Give the callback true.
        
        
        keychain["lastAuthentication"] = "facebook"

        //Hack- Commented out
        //self.oauthAuthorize("facebook", password: tokenString, callback: callback)
    }
    
    private func attemptAuthorizationFromKeychain(callback: SuccessResponse) {
        print(#function)
        
        let reachability = Reachability.reachabilityForInternetConnection()
        
        if reachability?.isReachable() == true {
            if let lastAuthentication = keychain["lastAuthentication"] {
                if lastAuthentication == "email" {
                    if let email = keychain["email"], let password = keychain["password"] {
                        self.oauthAuthorize(email, password: password, callback: { (success) -> Void in
                            callback(success)
                        })
                    }
                } else if lastAuthentication == "facebook" {
                    print("Yes, this was last authorization")
                    if let accessToken = keychain["facebookAccessToken"] {
                        self.authorizeWithFacebook(tokenString: accessToken, callback: { (success) -> Void in
                            callback(success)
                        })
                    }
                }
            } else {
                print("no lastAuthentication in keychain")
                callback(false)
            }
        } else {
            print("Not reachable")
            callback(false)
        }
    }
    
    private func internalAuthorize(oauth2: OAuth2PasswordGrant?, callback: OAuth2Response) {
        print(#function)

        if let oauth2 = self.oauth2 {
            
            oauth2.afterAuthorizeOrFailure = callback
            
            oauth2.authorize(params: nil, autoDismiss: true)
        } else {
            callback(wasFailure: true, error: nil)
        }
    }
}