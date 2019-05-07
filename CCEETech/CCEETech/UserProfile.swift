//
//  UserProfile.swift
//  CCEEtest
//
//  Created by mcaim on 2/26/19.
//

import Foundation
import UIKit

var globalImage: UIImage?
var globalUsername: String?

class UserProfile {
    var uid:String
    var username:String
    var photoURL:URL
    var score:Int
    
    init(uid:String, username:String,photoURL:URL,score:Int) {
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
        self.score = score
    }
    
    func setScore(int:Int) -> Void {
        score += int
    }
    
    func setUsername(name:String) -> Void {
        username = name
    }
}
