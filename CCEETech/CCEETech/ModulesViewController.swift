//
//  ModulesViewController.swift
//  CCEETech
//
//  Class for customizing Modules ViewController
//
//
//  Created by mcaim on 2/27/19.
//

import Foundation
import UIKit

class ModulesViewController:UIViewController {
    
    // top left profile info outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var level_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
    }
    
    // initialize score and progress vars
    var score = 0;
    var currentProgress = 0;
    
    // each time view loads refresh profile data
    override func viewDidAppear(_ animated: Bool) {
        guard let userProfile = UserService.currentUserProfile else { return }
        let username = userProfile.username
        self.username.text = username
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
        progressBar.setProgress(Float(Double(currentProgress)/(Double(currentlevel)*1000.0)), animated: false)
        
        self.xpLabel.text = String(score) + " / " + String(currentlevel*1000) + " xp"
        self.level_label.text = "Level " + String(currentlevel)
        ImageService.getImage(withURL: (UserService.currentUserProfile?.photoURL)!) { image, url in
            self.profileImage.image = image
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.height / 2
            self.profileImage.clipsToBounds = true
        }
    }
}
