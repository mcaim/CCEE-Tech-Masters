//
//  LeaderboardViewController.swift
//  CCEEtest
//
//  Created by mcaim on 2/27/19.
//
import Foundation
import UIKit
import Firebase

class LeaderboardViewController:UIViewController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var level_label: UILabel!
    
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var firstavatar: UIImageView!
    
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var secondavatar: UIImageView!
    
    @IBOutlet weak var third: UILabel!
     @IBOutlet weak var thirdavatar: UIImageView!
    
    @IBOutlet weak var fourth: UILabel!
    @IBOutlet weak var fourthavatar: UIImageView!
    
    @IBOutlet weak var fifth: UILabel!
    @IBOutlet weak var fifthavatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
    }
    
    var score = 0;
    var currentProgress = 0;
    
    override func viewDidAppear(_ animated: Bool) {
        //print("leaderboard view appeared")
        
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
        print(Float(Double(currentProgress)/(Double(currentlevel)*1000.0)))
        progressBar.setProgress(Float(Double(currentProgress)/(Double(currentlevel)*1000.0)), animated: false)
        //progressBar.progress = Float(0.5)
        
        self.xpLabel.text = String(score) + " / " + String(currentlevel*1000) + " xp"
        self.level_label.text = "Level " + String(currentlevel)
        
        ImageService.getImage(withURL: (UserService.currentUserProfile?.photoURL)!) { image, url in
            self.profileImage.image = image
            //self.profileImage.layer.cornerRadius = 18.0;
            //self.profileImage.layer.borderWidth = 3.0;
            //self.profileImage.layer.borderColor = UIColor.white.cgColor;
            //self.profileImage.clipsToBounds = true;
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.height / 2
            self.profileImage.clipsToBounds = true
        }
        
        leaderboard()
    }
    
    func leaderboard() {
        var scores = [Int]()
        var levels = [Int]()
        var usernames = [String]()
        var avatars = [URL]()
        
        let leaderboardDB = Database.database().reference().child("users/profile")
        leaderboardDB.queryOrdered(byChild: "score").queryLimited(toLast: 5).observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.exists() {
                for child in snapshot.children {
                    //print("leaderboard func")
                    //print(child)
                    let profileSnap = child as! DataSnapshot
                    _ = profileSnap.key
                    let dict = profileSnap.value as! [String:AnyObject]
                    let username = dict["username"] as! String
                    let score = dict["score"] as! Int
                    let photoURL = dict["photoURL"] as! String
                    let url = URL(string:photoURL)
                    //print(username)
                    //print(score)
                    usernames.append(username)
                    scores.append(score)
                    avatars.append(url!)
                    var currentlevel = 0;
                    if score == 0 {
                        currentlevel = 1
                    } else {
                        currentlevel = Int(ceil(Double(score)/1000.0))
                    }
                    levels.append(currentlevel)
                }
            } else {
                
            }
            //print("leaderboard arrays")
            //print(usernames)
            //print(scores)
            
            // check getImage vs download image
            self.first.text = usernames[4] + " Level " + String(levels[4])
            ImageService.getImage(withURL: (avatars[4])) { image, url in
                self.firstavatar.image = image
//                self.firstavatar.layer.cornerRadius = 18.0;
//                self.firstavatar.layer.borderWidth = 3.0;
//                self.firstavatar.layer.borderColor = UIColor.white.cgColor;
//                self.firstavatar.clipsToBounds = true;
                self.firstavatar.layer.cornerRadius = self.firstavatar.bounds.height / 2
                self.firstavatar.clipsToBounds = true
            }
            self.second.text = usernames[3] + " Level " + String(levels[3])
            ImageService.getImage(withURL: (avatars[3])) { image, url in
                self.secondavatar.image = image
//                self.secondavatar.layer.cornerRadius = 18.0;
//                self.secondavatar.layer.borderWidth = 3.0;
//                self.secondavatar.layer.borderColor = UIColor.white.cgColor;
//                self.secondavatar.clipsToBounds = true;
                self.secondavatar.layer.cornerRadius = self.secondavatar.bounds.height / 2
                self.secondavatar.clipsToBounds = true
            }
            self.third.text = usernames[2] + " Level " + String(levels[2])
            ImageService.getImage(withURL: (avatars[2])) { image, url in
                self.thirdavatar.image = image
//                self.thirdavatar.layer.cornerRadius = 18.0;
//                self.thirdavatar.layer.borderWidth = 3.0;
//                self.thirdavatar.layer.borderColor = UIColor.white.cgColor;
//                self.thirdavatar.clipsToBounds = true;
                self.thirdavatar.layer.cornerRadius = self.thirdavatar.bounds.height / 2
                self.thirdavatar.clipsToBounds = true
            }
            self.fourth.text = usernames[1] + " Level " + String(levels[1])
            ImageService.getImage(withURL: (avatars[1])) { image, url in
                self.fourthavatar.image = image
//                self.fourthavatar.layer.cornerRadius = 18.0;
//                self.fourthavatar.layer.borderWidth = 3.0;
//                self.fourthavatar.layer.borderColor = UIColor.white.cgColor;
//                self.fourthavatar.clipsToBounds = true;
                self.fourthavatar.layer.cornerRadius = self.fourthavatar.bounds.height / 2
                self.fourthavatar.clipsToBounds = true
            }
            self.fifth.text = usernames[0] + " Level " + String(levels[0])
            ImageService.getImage(withURL: (avatars[0])) { image, url in
                self.fifthavatar.image = image
//                self.fifthavatar.layer.cornerRadius = 18.0;
//                self.fifthavatar.layer.borderWidth = 3.0;
//                self.fifthavatar.layer.borderColor = UIColor.white.cgColor;
//                self.fifthavatar.clipsToBounds = true;
                self.fifthavatar.layer.cornerRadius = self.fifthavatar.bounds.height / 2
                self.fifthavatar.clipsToBounds = true
            }
        })
}
}
