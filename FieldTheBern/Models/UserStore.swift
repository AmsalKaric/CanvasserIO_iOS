//
//  UserStore.swift
//  FieldTheBern
//
//  Created by Amsal Karic on 5/30/16.
//  Copyright © 2016 Josh Smith. All rights reserved.
//

import Foundation
import SwiftyJSON

class UserStore {
    
    var user: User? = nil
    let userArchiveURL: NSURL = {
        let documentsDirectories =
            NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory,
                                                            inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.URLByAppendingPathComponent("user.archive")
    }()
    
    init() {
        if let archivedUser =
            NSKeyedUnarchiver.unarchiveObjectWithFile(userArchiveURL.path!) as? User {
            user = archivedUser
        }
    }
    
    func createUser(userJSON: JSON) -> User {
        let newUser = User(json: userJSON)
        user = newUser
        return newUser
    }
    
    /*func saveChanges() -> Bool {
        print("Saving items to: \(userArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(user, toFile: userArchiveURL.path!)
    }*/
}