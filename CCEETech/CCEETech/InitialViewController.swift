//
//  InitialViewController.swift
//  CCEETech
//
// Class for customizing inital loading screen
//
//  Created by mcaim on 2/14/19
//

import Foundation
import UIKit

class InitialViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}
