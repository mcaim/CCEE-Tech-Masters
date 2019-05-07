//
//  HomeViewController.swift
//  CCEEtest
//
//  Created by mcaim on 2/14/19
//

import Foundation
import UIKit
import Firebase

class HomeViewController:UIViewController {
    
    // outlet vars
    @IBOutlet weak var welcomeuser: UILabel! // not used
    @IBOutlet weak var profileImage: UIImageView! // for setting profile img
    @IBOutlet weak var usernameLabel: UILabel! // for setting username
    @IBOutlet weak var level: UILabel! // for setting level
    @IBOutlet weak var xpLabel: UILabel! // for setting xp label
    @IBOutlet weak var progressBar: UIProgressView! // for setting progressbar
    var score = 0;
    var currentProgress = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        print("HERE IN MY GARAGE")
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        self.usernameLabel.text = globalUsername
        if globalImage != nil {
            self.profileImage.image = globalImage
        }
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.height / 2
        self.profileImage.clipsToBounds = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        //progressBar.setProgress(Float(currentProgress/1000), animated: false)
        guard let userProfile = UserService.currentUserProfile else { return }
        let username = userProfile.username
        self.usernameLabel.text = username
        score = userProfile.score;
        
        var currentlevel = 0;
        if score == 0 {
            currentlevel = 1
        } else {
            currentlevel = Int(ceil(Double(score)/1000.0))
        }
        currentProgress = 0;
        if score == 0 {
            currentProgress = 0;
        } else {
            currentProgress = currentlevel*1000 - (currentlevel*1000-score); //
        }
        print(Float(Double(currentProgress)/1000.0))
        progressBar.setProgress(Float(Double(currentProgress)/(Double(currentlevel)*1000.0)), animated: false)        //progressBar.progress = Float(0.5)
        
        self.xpLabel.text = String(score) + " / " + String(currentlevel*1000) + " xp"
        self.level.text = "Level " + String(currentlevel)
        
        if Auth.auth().currentUser == nil {
            print("not signed in")
        }
        ImageService.getImage(withURL: (UserService.currentUserProfile?.photoURL)!) { image, url in
            self.profileImage.image = image
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.height / 2
            self.profileImage.clipsToBounds = true
        }
        if score == 0 {
            performSegue(withIdentifier: "initialIntro", sender: self)
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    @IBAction func handleLogout(_ sender:Any) {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        try! Auth.auth().signOut()
    }
}
