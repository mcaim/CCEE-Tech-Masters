//
//  UserService.swift
//  CCEEtest
//
//  Created by mcaim on 2/26/19.
//
import Foundation
import Firebase


class UserService {
    
    static var currentUserProfile:UserProfile?
    
    static func observeUserProfile(_ uid:String, completion: @escaping((_ userProfile:UserProfile?)->())) {
        let ref = Database.database().reference().child("users/profile/\(uid)")
        
        ref.observe(.value, with: {snapshot in
            var userProfile:UserProfile?
            
            print("snapshot: ",snapshot)
            
            
            if let dict = snapshot.value as? [String:Any],
                let username = dict["username"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string:photoURL),
                let score = dict["score"] as? Int {
                
                print(username)
                print(photoURL)
                userProfile = UserProfile(uid: snapshot.key, username: username, photoURL: url,score:score)
            }
            
//            DispatchQueue.main.async {
//                completion(userProfile)
//            }
            
            completion(userProfile)
        })
    }
    
    
}
