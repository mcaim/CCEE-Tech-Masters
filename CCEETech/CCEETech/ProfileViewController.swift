//
//  ProfileViewController.swift
//  CCEETech
//
//  Class for customing Profile VC
//
//  Created by mcaim on 2/27/19.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController:UIViewController {
    
    // top left outlets
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var imageTap: UIButton!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var xpLabel: UILabel!
    @IBOutlet weak var level_label: UILabel!
    
    // imagePicker for changing profile picture
    var imagePicker:UIImagePickerController!
    
    // badge outlets
    @IBOutlet weak var badge1: UIImageView!
    @IBOutlet weak var badge2: UIImageView!
    @IBOutlet weak var badge3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        ImageService.getImage(withURL: (UserService.currentUserProfile?.photoURL)!) { image, url in
            self.profileImage.image = image
            self.profileImage.layer.cornerRadius = 18.0;
            self.profileImage.layer.borderWidth = 3.0;
            self.profileImage.layer.borderColor = UIColor.white.cgColor;
            self.profileImage.clipsToBounds = true;
        }
        
        // Set up imageUI for tapping to change
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(imageTap)
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    var score = 0;
    var currentProgress = 0;
    
    override func viewDidAppear(_ animated: Bool) {
        guard let userProfile = UserService.currentUserProfile else { return }
        let username = userProfile.username
        self.username.text = username
        score = userProfile.score;
        
        var currentlevel = 0;
        if score == 0 {
            currentlevel = 1
        } else {
            currentlevel = Int(ceil(Double(score)/1000.0))
        }
        currentProgress = 0;
        if score == 0 {
            currentProgress = 0;
        } else {
            currentProgress = currentlevel*1000 - (currentlevel*1000-score); //
        }
        print(Float(Double(currentProgress)/1000.0))
        progressBar.setProgress(Float(Double(currentProgress)/(Double(currentlevel)*1000.0)), animated: false)
        
        self.xpLabel.text = String(score) + " / " + String(currentlevel*1000) + " xp"
        self.level_label.text = "Level " + String(currentlevel)
        
        if score > 1000 {
            self.badge1.image = #imageLiteral(resourceName: "firebaselogo")
        }
        if score >= 3000 {
            self.badge2.image = #imageLiteral(resourceName: "gold_star2")
        }
        if score >= 4000 {
            self.badge3.image =  #imageLiteral(resourceName: "Image")
        }
    }
    
    @objc func openImagePicker(_ sender:Any) {
        // Open Image Picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // change profile image
    @objc func handleSignUp() {
        guard let image = profileImage.image else { return }
                
                // 1. Upload the profile image to Firebase Storage
                
                self.uploadProfileImage(image) { url in
                    
                    print("uploading profile img")
                    self.saveProfile(username: "username", profileImageURL: url!) { success in
                        if success {
                            // continue
                        } else {
                            self.resetForm()
                        }
                    }
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                
                                self.saveProfile(username: "username", profileImageURL: url!) { success in
                                    if success {
                                        // continue
                                    } else {
                                        //print("1")
                                    }
                                }
                                
                            } else {
                                print("Error: \(error!.localizedDescription)")
                            }
                        }
                    } else {
                        print("2")
                    }
                    
                }
        
    }
    
    func resetForm() {
        let alert = UIAlertController(title: "Error changing profile image", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        //setContinueButton(enabled: true)
        //continueButton.setTitle("Continue", for: .normal)
        //activityView.stopAnimating()
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                storageRef.downloadURL { url, error in
                    completion(url)
                }
            } else {
                completion(nil)
            }
            print("image saved")
        }
    }
    
    
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
        //guard let uid = Auth.auth().currentUser?.uid else { return }
        let currentUser = Auth.auth().currentUser;
        //let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        let ref = Database.database().reference().child("users/profile/")
        ref.child("\(currentUser!.uid)/photoURL").setValue(profileImageURL.absoluteString) { error, ref in
            completion(error == nil)
        }
        //let userObject = [
        //    "photoURL": profileImageURL.absoluteString,
         //   "score" : 0,
         //   "username": username
         //   ] as [String:Any]
        
        //databaseRef.setValue(userObject) { error, ref in
        //    completion(error == nil)
        //}
        print("saved user")
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[.editedImage] as? UIImage {            self.profileImage.image = pickedImage
            handleSignUp()
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}

