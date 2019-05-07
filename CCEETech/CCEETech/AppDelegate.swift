//
//  AppDelegate.swift
//  CCEEtest
//
//  Created by mcaim on 2/14/19
//
import UIKit
import Firebase

let primaryColor = UIColor(red: 210/255, green: 109/255, blue: 180/255, alpha: 1)
let secondaryColor = UIColor(red: 52/255, green: 148/255, blue: 230/255, alpha: 1)
//var username = String()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var ref: DatabaseReference!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        Firebase.FirebaseApp.configure()
        print("User?", Auth.auth().currentUser == nil)
        //test
        // Override point for customization after application launch.
        
        //Auth.addStateDidChangeListener(<#T##Auth#>)
        // FIX THIS ASAP...BREAKS LOG IN/SIGN UP
        // MAYBE FIXED????
        var loggedIn = false
        try! Auth.auth().signOut()
        if Auth.auth().currentUser != nil {
            let uid = Auth.auth().currentUser?.uid
            
            // here
            UserService.observeUserProfile(uid!){ userProfile in
                UserService.currentUserProfile = userProfile
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
            }
        }
        
        Auth.auth().addStateDidChangeListener { auth, user in
            print("ENTERED  STATE LISTENER")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            print("state changed")
            // if user wasn't logged in, then they are now
            // this only happens after signing up or logging in
            if loggedIn == false {
                loggedIn = true
            }
            
            if user != nil {
                
                UserService.observeUserProfile(user!.uid){ userProfile in
                    UserService.currentUserProfile = userProfile
                    // user was logged out so go to home screen
                    if loggedIn == false {
                        print("went to maintabcontroller")
                        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
                        loggedIn = true
                    } else {
                        // user was already logged in so go to home screen
                        // only want this if user was already signed in, not if logged in/signed up
//                        let controller = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
//                        self.window?.rootViewController = controller
//                        self.window?.makeKeyAndVisible()
                    }
                }
                
            } else {
                // menu screen
                //user logged out so send back to Login/Signup screen
                loggedIn = false
                UserService.currentUserProfile = nil
                print("back to menuviewcontroller")
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                let controller = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
            }
        }
        
        return true
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        try! Auth.auth().signOut()
    }
    
    
}
