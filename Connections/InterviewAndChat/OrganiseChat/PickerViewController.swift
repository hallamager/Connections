//
//  PickerViewController.swift
//  Connections
//
//  Created by Hallam John Ager on 28/04/2018.
//  Copyright © 2018 Hallam John Ager. All rights reserved.
//

import Foundation

class PickerViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    var onConfirm: ((_ data: String) -> ())?
    
    var showTimePicker: Bool = false
    
    var formattedFirstDate: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            return formatter.string(from: datePicker.date)
        }
    }
    
    var formattedSecondDate: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            return formatter.string(from: datePicker.date)
        }
    }
    
    var formattedFirstTime: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: datePicker.date)
        }
    }
    
    var formattedSecondTime: String {
        get {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: datePicker.date)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showTimePicker == true {
            titleLabel.text = "Select Time"
            datePicker.datePickerMode = .time
            datePicker.minuteInterval = 15
        }
        
    }
    
    @IBAction func confirmBtn(_ sender: Any) {
        
        if showTimePicker {
            onConfirm?(formattedFirstTime)
            onConfirm?(formattedSecondTime)
        } else {
            onConfirm?(formattedFirstDate)
            onConfirm?(formattedSecondDate)
        }
            
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeModalBtn(_ sender: UIButton) {
        
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
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
