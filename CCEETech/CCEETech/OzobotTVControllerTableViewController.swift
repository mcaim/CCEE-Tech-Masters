//
//  OzobotTVControllerTableViewController.swift
//  CCEETech
//
//  Class for customizing TableVC for Ozobots (list of 5 challenges)
//
//  Created by mcaim on 2/25/19.
//

import UIKit

class OzobotTVControllerTableViewController: UITableViewController {
    
    // Lists for challenge labels (images dynamically set depending on player score))
    var challenges = ["Challenge 1", "Challenge 2", "Challenge 3", "Challenge 4", "Instructor Challenges"]
    var detailList = ["Intro to Ozobots", "Ozobot Basics", "Twists and Turns", "Maze Master", "Custom Challenges"]
    var segueIdentifiers = ["ozochallenge1", "ozochallenge2", "ozochallenge3", "ozochallenge4", "ozochallengefinal"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        // reloads table each time view appears (so star changes if player has enough score)
        self.tableView.reloadData()
    }
    
    
    // Set up tableview to be split into equal height cells
    let MinHeight: CGFloat = 100.0
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tHeight = tableView.bounds.height
        let temp = tHeight/CGFloat(challenges.count)
        
        return temp > MinHeight ? temp : MinHeight
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }

    // Configure each cell using index path and list from earlier to set labels and image
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        
        // Image is set depending on score - black star unless score is high enough
        let score = UserService.currentUserProfile!.score
        if score < (indexPath.row+1)*1000 {
            cell.imageView?.image = UIImage(named: "black_star")
        } else {
            cell.imageView?.image = UIImage(named: "gold_star2")
        }
        
        cell.textLabel?.text = challenges[indexPath.row]
        cell.textLabel?.font = UIFont(name: "Futura", size: 20)
        cell.detailTextLabel?.text = detailList[indexPath.row]
        cell.detailTextLabel?.font = UIFont(name: "Futura", size: 15)

        return cell
    }

    // When a cell is clicked on, check if user has enough score
    // If true, then ok to seque
    // If false, then alert user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (UserService.currentUserProfile!.score >= (indexPath.row)*1000) {
            performSegue(withIdentifier: segueIdentifiers[indexPath.row], sender: self)
        } else {
            let alertController = UIAlertController(title: "Wait!", message:
                "Complete earlier challenges before trying this!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
