//
//  MainTabController.swift
//  CCEEtest
//
//  Class for customizing TabController
//
//  Created by mcaim on 2/27/19.
//

import Foundation
import UIKit

class MainTabController: UITabBarController {
    
    //override var shouldAutorotate: Bool {
        //return false
    //}
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .landscapeRight
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
