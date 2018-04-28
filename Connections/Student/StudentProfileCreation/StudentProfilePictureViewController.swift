//
//  StudentProfilePictureViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 18/02/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class StudentProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage: UIImage?
    let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(Auth.auth().currentUser!.uid)
    let ref = Database.database().reference().child("student").child(Auth.auth().currentUser!.uid)
    
    @IBOutlet var profileImg: UIImageView!
    @IBOutlet weak var noImgEntered: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(StudentProfilePictureViewController.handleSelectProfileImageView))
        profileImg.addGestureRecognizer(tapGesture)
        profileImg.isUserInteractionEnabled = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleSelectProfileImageView() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("finish")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = image
            profileImg.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraRollBtn(_ sender: Any) {
        handleSelectProfileImageView()
    }
    
    @IBAction func comfirmBtn(_ sender: Any) {
        
        guard let _ = profileImg.image else {
            
            noImgEntered.text! = "You must enter at least one image."
            
            return
            
        }
        
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                
                let profileImageURl = metadata?.downloadURL()?.absoluteString
                self.ref.updateChildValues(["profileImageURL": profileImageURl!])
                
            })
        }
        
        presentStudentProfileCreationViewController()
        
    }
    
    func presentStudentProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
