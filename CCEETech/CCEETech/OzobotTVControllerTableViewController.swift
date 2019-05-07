//
//  OzobotTVControllerTableViewController.swift
//  CCEEtest
//
//  Created by mcaim on 2/25/19.
//

import UIKit

class OzobotTVControllerTableViewController: UITableViewController {
    
    
    var challenges = ["Challenge 1", "Challenge 2", "Challenge 3", "Challenge 4", "Instructor Challenges"]
    var segueIdentifiers = ["ozochallenge1", "ozochallenge2", "ozochallenge3", "ozochallenge4", "ozochallengefinal"]
    
    var detailList = ["Intro to Ozobots", "Ozobot Basics", "Twists and Turns", "Maze Master", "Custom Challenges"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    let MinHeight: CGFloat = 100.0
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let tHeight = tableView.bounds.height
        let temp = tHeight/CGFloat(challenges.count)
        
        return temp > MinHeight ? temp : MinHeight
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return challenges.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
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
        
        // Configure the cell...

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
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
