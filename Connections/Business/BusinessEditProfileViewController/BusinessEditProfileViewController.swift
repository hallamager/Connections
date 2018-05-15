//
//  BusinessEditProfileViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 03/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import ViewAnimator
import FirebaseDatabase
import GeoFire

class BusinessEditProfileViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionOne: UILabel!
    @IBOutlet weak var questionTwo: UILabel!
    @IBOutlet weak var questionThree: UILabel!
    @IBOutlet weak var cultureOne: UILabel!
    @IBOutlet weak var cultureTwo: UILabel!
    @IBOutlet weak var cultureThree: UILabel!
    @IBOutlet weak var updateLocationLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contentView: UIView!
    
    let sections = ["Info", "Jobs"]
    
    var businesses = [Business]()
    let ref = Database.database().reference().child("business/valid/\(Auth.auth().currentUser!.uid)")
    let refJobs = Database.database().reference().child("business/valid/\(Auth.auth().currentUser!.uid)").child("Jobs")
    let refSpecialties = Database.database().reference().child("business").child("valid").child(Auth.auth().currentUser!.uid).child("specialties")
    let geoRefBusiness = GeoFire(firebaseRef: Database.database().reference().child("business_locations"))
    var jobs = [Job]()
    var specialties = [Specialties]()
    let locationManager = CLLocationManager()
    
    var scrollViewDefaultContenetHeight: CGFloat = 1406
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100
        tableView.sectionHeaderHeight = 40
                
        self.navigationController?.navigationBar.isTranslucent = false
        
        ref.observe(.value, with: { snapshot in
            self.businesses.removeAll()
            if let business = Business(snapshot: snapshot) {
                self.questionOne.text = business.questionOne
                self.questionTwo.text = business.questionTwo
                self.questionThree.text = business.questionThree
                self.cultureOne.text = business.cultureOne
                self.cultureTwo.text = business.cultureTwo
                self.cultureThree.text = business.cultureThree
                self.businesses.append(business)
                self.tableView.reloadData()
                print("business \(self.businesses.count)")
            }
        })
        
        // Create a storage reference from the URL
        let storageRef = Storage.storage().reference(forURL: "gs://connections-bd790.appspot.com").child("Profile Image").child((Auth.auth().currentUser?.uid)!)
        // Download the data, assuming a max size of 1MB (you can change this as necessary)
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            // Create a UIImage, add it to the array
            let pic = UIImage(data: data!)
            self.profilePic.image = pic
        }
        
        refJobs.observe(.value, with: { snapshot in
            
            self.jobs.removeAll()
            self.businesses.removeAll()
            
            for job in snapshot.children {
                if let data = job as? DataSnapshot {
                    if let job = Job(snapshot: data) {
                        self.jobs.append(job)
                    }
                }
            }
            
            self.tableView.reloadData()
            self.caclculateTableViewHeight()
            
            print("job \(self.jobs.count)")
            
        })
        
        refSpecialties.observe(.value, with: { snapshot in
            self.specialties.removeAll()
            for specialties in snapshot.children {
                if let data = specialties as? DataSnapshot {
                    if let specialties = Specialties(snapshot: data) {
                        
                        self.specialties.append(specialties)
                    }
                }
            }
            
            self.collectionView.reloadData()
            
            print("is\(self.specialties.count)")
            
        })
        
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
    }
    
    func caclculateTableViewHeight() {
        
        print("section header: \(tableView.sectionHeaderHeight)")
        print("row height: \(tableView.rowHeight)")
        
        let newHeight: CGFloat = (tableView.sectionHeaderHeight) + (CGFloat(tableView.numberOfRows(inSection: 1))) * (tableView.rowHeight)
        
        tableView.frame = CGRect(x: tableView.frame.minX, y: tableView.frame.minY, width: tableView.frame.width, height: 410 + newHeight)
        
        self.scrollView.contentSize.height = scrollViewDefaultContenetHeight + newHeight
        
        for constraint in self.contentView.constraints {
            if constraint.identifier == "tableViewBottom" {
                print("hello")
                constraint.constant = newHeight + 435
            }
        }
        contentView.layoutIfNeeded()
                
        print("scrollView\(scrollViewDefaultContenetHeight + newHeight)")
        print("func tableView height is \(newHeight)")
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    @IBAction func editProfilePic(_ sender: Any) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
        let BusinessProfilePictureViewController:BusinessProfilePictureViewController = storyboard.instantiateViewController(withIdentifier: "BusinessProfilePictureViewController") as! BusinessProfilePictureViewController
        self.navigationController?.pushViewController(BusinessProfilePictureViewController, animated: true)
        
    }
    
    @IBAction func addJobs(_ sender: Any) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
        let AddJobsViewController:AddJobsViewController = storyboard.instantiateViewController(withIdentifier: "AddJobsViewController") as! AddJobsViewController
        self.navigationController?.pushViewController(AddJobsViewController, animated: true)
        
    }
    
    @IBAction func addSpecialties(_ sender: Any) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
        let BusinessSpecialtiesViewController:BusinessSpecialtiesViewController = storyboard.instantiateViewController(withIdentifier: "BusinessSpecialtiesViewController") as! BusinessSpecialtiesViewController
        self.navigationController?.pushViewController(BusinessSpecialtiesViewController, animated: true)
        
    }
    
    @IBAction func EditQuestions(_ sender: Any) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
        let BusinessQuestionsViewController:BusinessQuestionsViewController = storyboard.instantiateViewController(withIdentifier: "BusinessQuestionsViewController") as! BusinessQuestionsViewController
        self.navigationController?.pushViewController(BusinessQuestionsViewController, animated: true)
        
    }
    
    @IBAction func editCultureBtn(_ sender: Any) {
        
        let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
        let BusinessDetailsViewController:BusinessDetailsViewController = storyboard.instantiateViewController(withIdentifier: "BusinessDetailsViewController") as! BusinessDetailsViewController
        self.navigationController?.pushViewController(BusinessDetailsViewController, animated: true)
        
    }
    
    @IBAction func UpdateLocationBtn(_ sender: UIButton) {
        
        sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 1.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.25),
                       initialSpringVelocity: CGFloat(8.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform = CGAffineTransform.identity
        },
                       completion: { Void in()  }
        )
        
        self.updateLocationLabel.text = "Your location has been updated!"
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        geoRefBusiness.setLocation(location, forKey: (Auth.auth().currentUser?.uid)!)
    }
    
}

extension BusinessEditProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return 410
        }

        return 100

    }
    
}

extension BusinessEditProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return businesses.count
        }
        
        return jobs.count
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return nil
        }
        return sections[section]
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }

        let image = (Bundle.main.loadNibNamed("JobsTitle", owner: self, options: nil)![0] as? UIView)
        return image

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell") as! InfoCell
            
            let business = businesses[indexPath.row]
            
            cell.companyName?.text = business.username
            cell.companyIndustry?.text = business.industry
            cell.companyHeadquarters?.text = business.businessHeadquarters
            cell.companyDecription?.text = business.description
            cell.companySize?.text = business.companySize
            cell.companyWebsite?.text = business.companyWebsite
            cell.backgroundColor = .clear
            cell.backgroundView = UIView()
            cell.selectedBackgroundView = UIView()
            
            cell.delegate = self
            
            print("business \(self.businesses.count)")
            
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "jobsCell") as! JobsCell
        
        let job = jobs[indexPath.row]
        
        cell.jobTitle?.text = job.title
        cell.jobType?.text = job.employmentType
        cell.backgroundColor = .clear
        cell.backgroundView = UIView()
        cell.selectedBackgroundView = UIView()
        
        cell.delegate = self
        
        print("job \(self.jobs.count)")
        
        return cell
        
    }
    
}

extension BusinessEditProfileViewController: EditInfoCellDelegate, EditJobCellDelegate, DeleteSpecaltiesCellDelegate {
    
    func didTapButton(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            
            if sender.tag == 1 {
                
                let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
                let BusinessAboutViewController:BusinessAboutViewController = storyboard.instantiateViewController(withIdentifier: "BusinessAboutViewController") as! BusinessAboutViewController
                BusinessAboutViewController.business = businesses[indexPath.row]
                self.navigationController?.pushViewController(BusinessAboutViewController, animated: true)

                
            }
            
            if sender.tag == 2 {
                
                let storyboard:UIStoryboard = UIStoryboard(name: "BusinessRegister", bundle: nil)
                let EditJobsViewController:EditJobsViewController = storyboard.instantiateViewController(withIdentifier: "EditJobsViewController") as! EditJobsViewController
                EditJobsViewController.job = jobs[indexPath.row]
                self.navigationController?.pushViewController(EditJobsViewController, animated: true)
                
            }
            
            if sender.tag == 3 {
                
                let job = jobs[indexPath.row]
                
                let refDeleteJobs = Database.database().reference().child("business/valid/\(Auth.auth().currentUser!.uid)").child("Jobs").child(job.uuid!)
                
                refDeleteJobs.removeValue()
                
            }
            
        }
        
        if let indexPath = getCurrentCollectionCellIndexPath(sender) {
            
            if sender.tag == 4 {
                
                let specialtie = specialties[indexPath.row]
                
                let refDeleteSpecalties = Database.database().reference().child("business/valid/\(Auth.auth().currentUser!.uid)").child("specialties").child(specialtie.uuid!)
                
                refDeleteSpecalties.removeValue()
                
            }
            
        }
        
    }
    
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
    func getCurrentCollectionCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: collectionView)
        if let indexPath: IndexPath = collectionView.indexPathForItem(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
}
