import UIKit
import Firebase
class AppContainerViewController: UIViewController{
    
    override func viewDidAppear(_ animated: Bool) {
    
        super.viewDidAppear(animated)
        
        AppManager.shared.appContainer = self
        
//        try! Auth.auth().signOut()
        
        guard let user = Auth.auth().currentUser else  {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Test")
            present(vc, animated: true, completion: nil)
            return
        }

            
        Database.database().reference().child("users/\(user.uid)/type").observeSingleEvent(of: .value, with: {
            (snapshot) in
            
            ViewedManager.shared.configure(uuid: user.uid)
            
            if snapshot.exists() {
                
                switch snapshot.value as! String {
                // If our user is admin...
                case "business":
                    // ...redirect to the student page
                    addTokenBusiness()
                    let storyboard:UIStoryboard = UIStoryboard(name: "StudentMain", bundle: nil)
                    let SWRevealViewController:SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "StudentSWRevealViewController") as! SWRevealViewController
                    self.present(SWRevealViewController, animated: true, completion: nil)
                // If out user is a regular user...
                case "student":
                    // ...redirect to the business page
                    addTokenStudent()
                    let storyboard:UIStoryboard = UIStoryboard(name: "BusinessMain", bundle: nil)
                    let SWRevealViewController:SWRevealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                    self.present(SWRevealViewController, animated: true, completion: nil)
                // If the type wasn't found...
                default:
                    // ...print an error
                    print("Error: Couldn't find type for user \(user.uid)")
                    try! Auth.auth().signOut()
                    
                }
                
            } else {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "Test")
                self.present(vc, animated: true, completion: nil)
                
                try! Auth.auth().signOut()
                
                return
                
            }
            
        })
        
        func addTokenStudent() {
            
            let ref = Database.database().reference().child("student").child("valid").child(Auth.auth().currentUser!.uid).child("FCM Token")
            
            // [START log_fcm_reg_token]
            let token = Messaging.messaging().fcmToken
            print("FCM token: \(token ?? "")")
            // [END log_fcm_reg_token]
            
            ref.setValue([token!: true])
            
        }
        
        func addTokenBusiness() {
            
            let ref = Database.database().reference().child("business").child("valid").child(Auth.auth().currentUser!.uid).child("FCM Token")
            
            // [START log_fcm_reg_token]
            let token = Messaging.messaging().fcmToken
            print("FCM token: \(token ?? "")")
            // [END log_fcm_reg_token]
            
            ref.setValue([token!: true])
            
        }
        
    }
    
    
}
