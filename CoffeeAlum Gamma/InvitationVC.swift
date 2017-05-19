//
//  InvitationViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 1/16/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Foundation

class InvitationVC: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    
    @IBOutlet weak var personInvitingLabel: UILabel!
    
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBAction func declineButtonAction(_ sender: UIButton) {
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func acceptButtonAction(_ sender: UIButton) {
        // Dismisses the popover
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
    }
    
}