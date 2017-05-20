//
//  APIClient.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 5/19/17.
//  Copyright © 2017 Trevin Wisaksana. All rights reserved.
//

import Firebase

class APIClient {
    
    fileprivate static let uid = FIRAuth.auth()!.currentUser!.uid
    fileprivate static var db = FIRDatabase.database().reference()
    fileprivate static let firebaseAuth = FIRAuth.auth()
    fileprivate static let coffeeReference = db.child("coffees")
    
    // MARK: - Invitation Response
    static func acceptInvitation(with id: String) {
        let invitationReference = coffeeReference.child(id)
        invitationReference.child("accepted").setValue(true)
    }
    
    static func declineInvitation(with id: String) {
        let invitationReference = coffeeReference.child(id)
        invitationReference.child("accepted").setValue(false)
    }
    
    // MARK: - CoffeeData Manager 
    static func retrieveCoffeeData() {
        
    }
    
    static func getCoffeeInvitation() {
        
    }
    
    static func sendCoffeeInvitation() {
        
    }
    
    // MARK: - App Entry And Exit 
    static func signIn(with email: String, password: String, completion: (() -> Void)?) {
        firebaseAuth?.signIn(withEmail: email, password: password,
            completion: { (user, error) in
            if error == nil {
                // Presents the home view controller
                completion?()
            } else {
                // Throws error
                // TODO: UIAlert
                /*
                let credentialAlert = UIAlertController(title: "Sign in error", message: "Password or email may be incorrect", preferredStyle: .alert)
                credentialAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                present(credentialAlert, animated: true, completion: nil)
                */
            }

        })
        
    }
    
    static func signOut() {
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    static func signUp() {
        
    }
    
    // MARK: - Retrieve User Information 
    static func retrieveUserInformation() {
        
    }
    
}