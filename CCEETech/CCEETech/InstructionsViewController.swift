//
//  InstructionsViewController.swift
//  CCEETech
//
//  Class for customizing and handling instructions viewcontroller
//
//  Created by Macbook Pro on 4/15/19.
//

import Foundation
import UIKit

class InstructionsViewController: UIViewController {
    
    @IBOutlet weak var popup: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        popup.addGestureRecognizer(tap)
        
        view.isUserInteractionEnabled = true
    }
    
    // when tappped, dismiss this viewcontroller
    @IBAction func tapped(_ gestureRecognizer : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
