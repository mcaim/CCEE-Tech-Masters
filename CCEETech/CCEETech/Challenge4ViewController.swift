//
//  Challenge3ViewController.swift
//  CCEEtest
//
//  Created by Macbook Pro on 4/14/19.
//

import Foundation
import UIKit
import Firebase
import AVFoundation

class Challenge4ViewController: UIViewController {
    var score = 0
    let currentUser = Auth.auth().currentUser;
    let ref = Database.database().reference().child("users/profile/")
    @IBOutlet weak var goal: UILabel!

    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet var blanks: [UIImageView]!
    
    var questionNum = 0
    var player: AVAudioPlayer?
    var alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    var quiz = Quiz()
    var endQuiz = false
    var selectedBlank: UIView?
    
    func initQuiz() {
        let q1_a1 = ["straight_code_0.0", "right_code_0.0", "", "", "straight_code_180.0", "", "right_code_90.0", "straight_code_0.0", "straight_code_0.0", "straight_code_90.0", "right_code_180.0", "", "", "", "", "straight_code_-90.0", "", "", "", "", "", ""]
        
        let q1_answers = [Quiz.AnswerList(l: q1_a1)]
        
        let q1 = Quiz.Question(a: q1_answers, n: 1, g: "Maze Master")
        
        quiz.questions = [q1]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let userProfile = UserService.currentUserProfile else { return }
        score = userProfile.score
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: {action in self.closeQuiz()}))
        initQuiz()
        nextQuestion()
        rotateBlanks()
        
        for b in buttons {
            let dragRecognizer = UIPanGestureRecognizer(target: self, action: #selector(dragCode))
            b.addGestureRecognizer(dragRecognizer)
        }
        
        for blank in blanks {
            let tap = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
            tap.numberOfTapsRequired = 2
            blank.addGestureRecognizer(tap)
            
            let select = UITapGestureRecognizer(target: self, action: #selector(selected))
            tap.numberOfTapsRequired = 1
            blank.addGestureRecognizer(select)
        }
        
        let check = UITapGestureRecognizer(target: self, action: #selector(checkAnswer))
        check.numberOfTapsRequired = 3
        view.addGestureRecognizer(check)
        
        view.isUserInteractionEnabled = true
    }
    
    @IBAction func checkAnswer(_ gestureRecognizer : UITapGestureRecognizer) {
        var answers = [String]()
        for blank in blanks {
            answers.append(blank.restorationIdentifier ?? "")
        }
        switch(quiz.checkAnswer(num: questionNum, answers: answers)) {
        case(true):
            correct()
        case(false):
            incorrect()
        }
    }
    
    
    @IBAction func clear(_ sender: Any) {
        for blank in blanks {
            blank.image = nil
            blank.restorationIdentifier = ""
        }
    }
    
    @IBAction func rotate(_ sender: Any) {
        selectedBlank?.transform = CGAffineTransform(rotationAngle: .pi + getImageAngle(image: selectedBlank) * (.pi/180))
        for blank in blanks {
            if (blank == selectedBlank) {
                let s = blank.restorationIdentifier!.split(separator: "_")
                blank.restorationIdentifier = "\(s[0])_\(s[1])_\(String(format: "%.1f", getImageAngle(image: blank)))"
            }
        }
    }
    
    @IBAction func selected(_ gestureRecognizer : UITapGestureRecognizer) {
        selectedBlank = gestureRecognizer.view
        
        for blank in blanks {
            if (blank == selectedBlank) {
                if (blank.layer.borderColor == UIColor.cyan.cgColor) {
                    blank.layer.borderColor = UIColor.clear.cgColor
                    selectedBlank = nil
                }
                else {
                    blank.layer.borderColor = UIColor.cyan.cgColor
                    blank.layer.borderWidth = 3.0
                }
            }
            else {
                blank.layer.borderColor = UIColor.clear.cgColor
            }
        }
    }
    
    @IBAction func doubleTapped(_ gestureRecognizer : UITapGestureRecognizer) {
        print("double tapped")
        blanks[gestureRecognizer.view!.tag - 1].image = nil
    }
    
    //Handle Drag/Drop
    var initialCenter = CGPoint()
    @IBAction func dragCode(_ gestureRecognizer : UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else {return}
        let code = gestureRecognizer.view!
        
        let translation = gestureRecognizer.translation(in: code.superview)
        if gestureRecognizer.state == .began {
            self.initialCenter = code.center
        }
        
        if gestureRecognizer.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            code.center = newCenter
        }
        
        if gestureRecognizer.state == .ended{
            
            //Check if near a blank
            var boundsA = code.convert(code.bounds, to: nil);
            boundsA.size.width = 100
            boundsA.size.height = 25
            print(boundsA)
            print(boundsA.width)
            print(boundsA.height)
            //Fix for multiple collisions
            for blank in blanks {
                let boundsB = blank.convert(blank.bounds, to: nil);
                
                if (boundsB.intersects(boundsA)) {
                    switch(code.tag) {
                    case(0):
                        blank.image = UIImage(named: "left_code")
                        blank.restorationIdentifier = "left_code_\(getImageAngle(image: blank))"
                    case(1):
                        blank.image = UIImage(named: "right_code")
                        blank.restorationIdentifier = "right_code_\(getImageAngle(image: blank))"
                    case(2):
                        blank.image = UIImage(named: "straight_code")
                        blank.restorationIdentifier = "straight_code_\(getImageAngle(image: blank))"
                    case(3):
                        blank.image = UIImage(named: "uturn_code")
                        blank.restorationIdentifier = "uturn_code_\(getImageAngle(image: blank))"
                    default:
                        blank.image = nil
                        blank.restorationIdentifier = ""
                    }
                    playSound(sound: "place_object")
                }
            }
            
            code.center = initialCenter
        }
    }
    
    func playSound(sound: String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func incorrect() {
        playSound(sound:"incorrect")
        
        alert.title = "You may have found a path, but not the BEST path!"
        self.present(alert, animated: true)
        
    }
    
    func correct() {
        playSound(sound:"correct")
        
        alert.title = "Correct!"
        
        for blank in blanks {
            blank.image = nil
            blank.restorationIdentifier = ""
        }
        
        if (questionNum < quiz.questions.count) {
            nextQuestion()
            self.present(alert, animated: true)
        }
        else {
            if score < 4000 {
                ref.child("\(currentUser!.uid)/score").setValue(4000)
            }
            endQuiz = true
            playSound(sound: "completed")
            alert.title = "Congratulations!"
            alert.message = "You have successfully completed the quiz."
            self.present(alert, animated: true)
        }
    }
    
    func nextQuestion() {
        questionNum += 1
        goal.text = quiz.questions[questionNum - 1].goalText
    }
    
    func closeQuiz() {
        if (endQuiz){
            dismiss(animated: true, completion: nil)
        }
    }
    
    func getImageAngle(image: UIView?) -> CGFloat{
        let radians = atan2(image?.transform.b ?? 0, image?.transform.a ?? 0)
        let degrees = radians * 180 / .pi
        
        return degrees.rounded()
    }
    
    func rotateBlanks() {
        for blank in blanks {
            if (blank.restorationIdentifier?.contains("rotate") ?? false) {
                blank.transform = CGAffineTransform(rotationAngle: .pi / 2)
                blank.restorationIdentifier = ""
            }
        }
    }
}
