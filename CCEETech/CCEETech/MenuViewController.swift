//
//  ViewController.swift
//  CCEEtest
//
//  This is the starting screen (before logging/signing in
//
//  Created by mcaim on 2/14/19
//

import UIKit
import Firebase

class MenuViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // not used
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
    }
    
    override func viewDidLayoutSubviews() {
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
}
