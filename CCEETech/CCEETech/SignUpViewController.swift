//
//  SignUpViewController.swift
//  CCEETech
//
//  Class for handling signing up
//
//  Created by mcaim on 2/14/19
//
import Foundation
import UIKit
import Firebase

class SignUpViewController:UIViewController, UITextFieldDelegate {
    
    // outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var tapToChangeProfileButton: UIButton!
    
    var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    var imagePicker:UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
        // add 2 color background
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        // add continue button
        continueButton = RoundedWhiteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        continueButton.setTitleColor(secondaryColor, for: .normal)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - continueButton.frame.height - 24)
        continueButton.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        continueButton.defaultColor = UIColor.white
        continueButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        view.addSubview(continueButton)
        setContinueButton(enabled: false)
        
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.color = secondaryColor
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        
        view.addSubview(activityView)
        
        // delegating input fields
        usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        usernameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        // set up profile image picker
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(imageTap)
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        profileImageView.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    
    // lock screen to portrait
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    // resign field responders
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    // keyboard dismissal
    override var disablesAutomaticKeyboardDismissal: Bool {
        get { return false }
        set { self.disablesAutomaticKeyboardDismissal = false }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @IBAction func handleDismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /**
     Adjusts the center of the **continueButton** above the keyboard.
     - Parameter notification: Contains the keyboardFrame info.
     */
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        activityView.center = continueButton.center
    }
    
    /**
     Enables the continue button if the **username**, **email**, and **password** fields are all non-empty.
     
     - Parameter target: The targeted **UITextField**.
     */
    
    @objc func textFieldChanged(_ target:UITextField) {
        let username = usernameField.text
        let email = emailField.text
        let password = passwordField.text
        let formFilled = username != nil && username != "" && email != nil && email != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        switch textField {
        case usernameField:
            usernameField.resignFirstResponder()
            emailField.becomeFirstResponder()
            break
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    /**
     Enables or Disables the **continueButton**.
     */
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc func handleSignUp() {
        guard let username = usernameField.text else { return }
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        guard let image = profileImageView.image else { return }
        
        globalUsername = username
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("User created!")
                
                
                
                
                // 1. Upload the profile image to Firebase Storage
                
                self.uploadProfileImage(image) { url in
                    
                    self.saveProfile(username: username, profileImageURL: url!) { success in
                        if success {
                            // continue
                        } else {
                            self.resetForm()
                        }
                    }
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                
                                self.saveProfile(username: username, profileImageURL: url!) { success in
                                    if success {
                                        self.usernameField.resignFirstResponder()
                                        self.emailField.resignFirstResponder()
                                        self.passwordField.resignFirstResponder()
                                        NotificationCenter.default.removeObserver(self)
                                        self.performSegue(withIdentifier: "toMainTabBarController", sender: self)
                                    } else {
                                        self.resetForm()
                                    }
                                }
                                
                            } else {
                                // alert for wierd error
                                print("Error: \(error!.localizedDescription)")
                                let alert = UIAlertController(title: "Error changing username/profile image", message: nil, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                                self.resetForm()
                            }
                        }
                    } else {
                        let alert = UIAlertController(title: "Error uploading image", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        self.resetForm()
                    }
                    
                }
                
            } else {
                // couldn't sign up due to bad username or password
                if (username.count < 5 || pass.count < 5) {
                    let alert = UIAlertController(title: "Username and Password must be at least 6 characters", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Invalid email", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                self.resetForm()
            }
        }
    }
    
    // reset the form if some error happens
    func resetForm() {
        setContinueButton(enabled: true)
        continueButton.setTitle("Continue", for: .normal)
        activityView.stopAnimating()
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // make a reference to Firebase storage in user's node
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        // compress img
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        // info about img
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        // put image in Firebase Storage
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                storageRef.downloadURL { url, error in
                    completion(url)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    // make a reference to the Firebase database and set a new user object with profile info
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "photoURL": profileImageURL.absoluteString,
            "score" : 0,
            "username": username
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // picker functionality
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.editedImage] as? UIImage {            self.profileImageView.image = pickedImage
            globalImage = pickedImage
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
//trash
// Local file you want to upload
//let localFile = URL(string: "path/to/image")!
/*
 // Create the file metadata
 let metadata = StorageMetadata()
 metadata.contentType = "image/jpeg"
 
 // Upload file and metadata to the object 'images/mountains.jpg'
 let uploadTask = storageRef.putData(imageData, metadata: metadata)
 
 // Listen for state changes, errors, and completion of the upload.
 uploadTask.observe(.resume) { snapshot in
 // Upload resumed, also fires when the upload starts
 }
 
 uploadTask.observe(.pause) { snapshot in
 // Upload paused
 }
 
 uploadTask.observe(.progress) { snapshot in
 // Upload reported progress
 let percentComplete = 100.0 * Double(snapshot.progress!.completedUnitCount)
 / Double(snapshot.progress!.totalUnitCount)
 }
 
 uploadTask.observe(.success) { snapshot in
 // Upload completed successfully
 }
 
 uploadTask.observe(.failure) { snapshot in
 if let error = snapshot.error as? NSError {
 switch (StorageErrorCode(rawValue: error.code)!) {
 case .objectNotFound:
 // File doesn't exist
 break
 case .unauthorized:
 // User doesn't have permission to access file
 break
 case .cancelled:
 // User canceled the upload
 break
 
 /* ... */
 
 case .unknown:
 // Unknown error occurred, inspect the server response
 break
 default:
 // A separate error occurred. This is a good place to retry the upload.
 break
 }
 }
 }*/
