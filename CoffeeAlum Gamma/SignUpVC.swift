//
//  ViewController.swift
//  CoffeeAlum Gamma
//
//  Created by Trevin Wisaksana on 12/24/16.
//  Copyright © 2016 Trevin Wisaksana. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController, UITextFieldDelegate {
    
    // Adaptive Keyboard Property
    var adaptiveKeyboard: AdaptiveKeyboard!
    
    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollViewOutlet: UIScrollView!
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var backingView: UIView!
    
    /* confirmPasswordTextField:
    Used to compare to new password so that the users
    can assure that they have entered the same password
    as they thought.
    */
    
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    /*
    These IBOutlets are used to change the text label color to 
    red when there's an error.
    */
    
    @IBOutlet weak var emailAddressLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordLabel: UILabel!

    
    var userRef:FIRDatabaseReference = FIRDatabase.database().reference().child("users")
    
    // MARK: - Overrided Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Placing the text fields as the Adaptive Keyboard initializer
        adaptiveKeyboard = AdaptiveKeyboard(
            scrollView: scrollViewOutlet,
            textField: emailTextField,
            passwordTextField, confirmPasswordTextField,
            pushHeight: 80
        )
        
        scrollViewOutlet.isScrollEnabled = false
        
        // Used for adjust the scroll view when text field is being editted to give room
        adaptiveKeyboard.registerKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Checks if the text field is being editted or not
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        // Adding corner radius
        backingView.addPresetCornerRadius()
        // Adding shadow
        shadowView.addPresetShadow()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Removes the keyboad notification when the view has changed
        adaptiveKeyboard.unregisterKeyboardNotifications()
    }
    
    
    // MARK: - IBActions
    @IBAction private func signUpButtonAction(_ sender: UIButton) {
        let emailCondition = hasFullfilledEmailRequirementsIn(emailAddressTextField: emailTextField)
        let passwordCondition = hasFulfilledPasswordRequirementsIn(textField: passwordTextField)
        let confirmPasswordCondition = hasFulfilledConfirmPasswordRequirements(newPasswordTextField: passwordTextField, confirmTextField: confirmPasswordTextField)
        
        
        let credentialAlert = UIAlertController(title: "Invalid Credentials", message: "Credentials incorrect or poorly formatted", preferredStyle: .alert)
        credentialAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        
        // Extracting the String for email and password
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            present(credentialAlert, animated: true, completion: nil)
            return
        }
        
        if (emailCondition) && (passwordCondition) && (confirmPasswordCondition) {
            // MARK: Firebase Auth
            // Success in signing up, create user in Firebase
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                // There's no error
                if error == nil {
                    // Create Firebase path for this user and save email
                    let thisUserRef = self.userRef.child(user!.uid)
                    thisUserRef.setValue(["email":email]){ ( error, ref) -> Void in
                        self.presentSearchViewController()
                    }
                    
            
                } else {
                    let alert = UIAlertController(title: "An Error Occurred", message: "Your Connection has timed out", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
            
        }
        
        else{
            present(
                credentialAlert,
                animated: true,
                completion: nil
            )
        }
        
    }
  
    @IBAction func googleLoginButtonAction(_ sender: UIButton) {
        
        
        
    }
    
    
    // MARK: - Firebase Methods
    func firabaseDatabaseReference() {
        let ref = FIRDatabase.database().reference(fromURL: "https://coffeealum-beta-c723a.firebaseio.com/")
        // TODO: Save the name of user
        let values = ["name" : emailTextField.text, "email" : emailTextField.text]
        
        ref.updateChildValues(values) { (errorValue, ref) in
            // If there's no error, this means the user has been saved successfully
            if errorValue == nil {
                print("Saved user succesfully")
            } else {
                print(errorValue!)
            }
        }
    }
    
    
    // MARK: - Methods for Checking Text Field
    
    // Method that returns a Bool if the new password requirement is fulfilled
    private func hasFulfilledPasswordRequirementsIn(textField: UITextField) -> Bool {
        // Checks if the text field is empty to give an appropriate warning
        if textField.text?.isEmpty == true {
            // TODO: Popup "Please enter your new password" alert
            displayUsefulErrorMessage(errorMessage: "Please enter your new password",
                                      label: passwordLabel)
            print("Please enter your new password")
            
        // Checks if the password text field is has enough characters
        } else if hasEnoughCharactersIn(textField: textField) == true {
            normalizLabels(labelTitle: "Password", label: passwordLabel)
            return true
            
        } else {
            // TODO: Popup "You need to have at least 6 characters" alert
            displayUsefulErrorMessage(errorMessage: "Password needs at least 6 characters",
                                      label: passwordLabel)
            print("You need to have at least 6 characters")
        }
        
        return false
    }
    
    // Method that returns a Bool if the new password matches the confirmed password
    private func hasFulfilledConfirmPasswordRequirements(newPasswordTextField: UITextField, confirmTextField: UITextField) -> Bool {
        // Checks fi the confirm password text field is empty
        if confirmTextField.text?.isEmpty == true {
            displayUsefulErrorMessage(errorMessage: "Please re-enter your new password",
                                      label: confirmPasswordLabel)
            print("Please re-enter your new password to confirm")
            
        // If the new password matches with the confirm password
        } else if (passwordMatchesIn(passwordTextField: newPasswordTextField, confirmPasswordTextField: confirmTextField) == true) && (confirmTextField.text?.isEmpty == false) {
            normalizLabels(labelTitle: "Confirm password", label: confirmPasswordLabel)
            return true
        
        } else {
            // TODO: Popup "Your password does not match" alert
            displayUsefulErrorMessage(errorMessage: "Your password does not match",
                                      label: confirmPasswordLabel)
            print("Your password does not match")
        }
        
        return false
    }
    
    // Method to check if email address entered fulfills the requirements
    private func hasFullfilledEmailRequirementsIn(emailAddressTextField: UITextField) -> Bool {
        // Checks if the email address text field is empty
        if emailAddressTextField.text?.isEmpty == true {
            // TODO: Popup "Please enter your email address" alert
            displayUsefulErrorMessage(errorMessage: "Please enter your email address",
                                      label: emailAddressLabel)
            print("Please enter your email address")
        
        // Validates the email address
        } else if (validateEmailAddressIn(textField: emailAddressTextField) == true) {
            normalizLabels(labelTitle: "Email address", label: emailAddressLabel)
            return true
            
        } else {
            // TODO: Popup "Please enter a valid email address" alert
            displayUsefulErrorMessage(errorMessage: "Please enter a valid email address",
                                      label: emailAddressLabel)
            print("Please enter a valid email address")
        }
        
        return false
    }
    
    // Method to check if the password contains enough characters
    private func hasEnoughCharactersIn(textField: UITextField) -> Bool {
        // Number of characters in the text field
        let characterCountInTextField = textField.text?.characters.count
        // At least 6 characters is needed for the text field
        if characterCountInTextField! >= 6 {
            return true
        }
        return false
    }
    
    // Method to check if the email address entered is valid
    private func validateEmailAddressIn(textField: UITextField) -> Bool {
        let emailAddress = textField.text
        let emailRegularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        // Uses NSPredicate to filter through the email address string using the Regular Expression
        let emailCheck = NSPredicate(format:"SELF MATCHES %@", emailRegularExpression)
        // Returns a Bool to check if the condition passes
        return emailCheck.evaluate(with: emailAddress)
    }
    
    // Method to check if the password entered matches the confirm password
    private func passwordMatchesIn(passwordTextField: UITextField, confirmPasswordTextField: UITextField) -> Bool {
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        if password == confirmPassword {
            return true
        }
        return false
    }
    
    // Method to allow the next view controller to be presented
    private func presentSearchViewController() {
        
        // Accessing the App Delegate
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let swRevealViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController")
        // Present the next view controller
        appDelegate?.window?.rootViewController = swRevealViewController
    }
    
    // Method to show useful error message
    func displayUsefulErrorMessage(errorMessage message: String, label: UILabel) {
        label.text = message
        label.textColor = UIColor.red
    }
    
    // Method to change the sign up labels back to its original
    func normalizLabels(labelTitle: String, label: UILabel) {
        // Changing the label into the useful error message
        label.text = labelTitle
        // Changing the color of the text to red
        label.textColor = UIColor(colorLiteralRed: 116/255, green: 116/255, blue: 116/255, alpha: 1.0)
    }
    
    // Method to hide the keyboard when the return button is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
}

