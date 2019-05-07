//
//  Challenge1QuizViewController.swift
//  CCEEtest
//
//  Created by mcaim on 5/5/19.
//

import Foundation
import Firebase

class Challenge1QuizViewController:UIViewController {
    
    var score = 0
    let currentUser = Auth.auth().currentUser;
    let ref = Database.database().reference().child("users/profile/")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func awardXP(_ sender: Any) {
        if score < 501 {
            ref.child("\(currentUser!.uid)/score").setValue(1000)
        }
    }
    
    
}
