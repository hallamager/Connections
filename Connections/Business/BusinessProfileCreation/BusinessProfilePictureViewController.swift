//
//  BusinessProfilePictureViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 01/03/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

class BusinessProfilePictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var selectedImage: UIImage?
    let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child(Auth.auth().currentUser!.uid)
    let ref = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid)
    
    @IBOutlet var profileImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(BusinessProfilePictureViewController.handleSelectProfileImageView))
        profileImg.addGestureRecognizer(tapGesture)
        profileImg.isUserInteractionEnabled = true
        
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
        
        if let profileImg = self.selectedImage, let imageData = UIImageJPEGRepresentation(profileImg, 0.1) {
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    return
                }
                
                let profileImageURl = metadata?.downloadURL()?.absoluteString
                self.ref.updateChildValues(["profileImageURL": profileImageURl!])
                
            })
        }
        
        presentBusinessProfileCreationViewController()
        
    }
    
    func presentBusinessProfileCreationViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
