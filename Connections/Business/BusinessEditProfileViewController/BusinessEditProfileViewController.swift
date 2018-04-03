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

class BusinessEditProfileViewController: UIViewController {
    
    @IBOutlet var openMenu: UIBarButtonItem!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var questionOne: UILabel!
    @IBOutlet weak var questionTwo: UILabel!
    @IBOutlet weak var questionThree: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let sections = ["Info", "Jobs"]
    
    var businesses = [Business]()
    let ref = Database.database().reference().child("business/\(Auth.auth().currentUser!.uid)")
    let refJobs = Database.database().reference().child("business/\(Auth.auth().currentUser!.uid)").child("Jobs")
    let refSpecialties = Database.database().reference().child("business").child(Auth.auth().currentUser!.uid).child("specialties")
    var jobs = [Job]()
    var specialties = [Specialties]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        
        ref.observe(.value, with: { snapshot in
            if let business = Business(snapshot: snapshot) {
                self.questionOne.text = business.questionOne
                self.questionTwo.text = business.questionTwo
                self.questionThree.text = business.questionThree
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
            
            for job in snapshot.children {
                if let data = job as? DataSnapshot {
                    if let job = Job(snapshot: data) {
                        self.jobs.append(job)
                    }
                }
            }
            
            self.tableView.reloadData()
            
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
//
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 440
        
        //open menu with tab bar button
        openMenu.target = self.revealViewController()
        openMenu.action = #selector(SWRevealViewController.revealToggle(_:))
        
        
        //open menu with swipe gesture
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        
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
    
}

extension BusinessEditProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
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

extension BusinessEditProfileViewController: EditInfoCellDelegate, EditJobCellDelegate {
    
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
            
        }
        
    }
    
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition = sender.convert(CGPoint.zero, to: tableView)
        if let indexPath: IndexPath = tableView.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
    
}
