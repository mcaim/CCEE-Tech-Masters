//
//  InstructionsViewController.swift
//  CCEEtest
//
//  Created by Macbook Pro on 4/15/19.
//

import Foundation
import UIKit

class InstructionsViewController: UIViewController {
    
    @IBOutlet weak var popup: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tap.numberOfTapsRequired = 1
        popup.addGestureRecognizer(tap)
        
        view.isUserInteractionEnabled = true
    }
    
    @IBAction func tapped(_ gestureRecognizer : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
