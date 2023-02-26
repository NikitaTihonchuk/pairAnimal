//
//  RegistrationViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 1.02.23.
//

import UIKit
import FirebaseAuth
import  JGProgressHUD

class RegistrationViewController: UIViewController {
    static let id = String(describing: RegistrationViewController.self)
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    private let spinner = JGProgressHUD(style: .dark)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"
    }

    private func showAlert(title: String, message: String, bool: Bool) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            if alert.title == "Success" {
                if action.isEnabled {
                    self.dismiss(animated: true)
                }
            }
        }))
        present(alert, animated: true)
    }


    @IBAction func registerButtonDidTap(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let name = nameTextField.text else { return }
        spinner.show(in: view)
        DatabaseManager.shared.isUserExists(email: email) { [weak self] exists in
            guard let strongSelf = self else { return }
            
            guard !exists else {
                strongSelf.showAlert(title: "Sorry", message: "User already exists", bool: false)
                return
            }
                FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    DispatchQueue.main.async {
                        strongSelf.spinner.dismiss()
                    }
                    guard let result = authResult, error == nil else {
                        strongSelf.showAlert(title: "Error", message: "Please enter correct email or password", bool: false)
                        return
                    }
                    DatabaseManager.shared.inserUser(user: UserModel(name: name, id: result.user.uid, emailAddress: email))
                        strongSelf.showAlert(title: "Success", message: "Now you can sign in", bool: true)
                    }
                    
            }
        }
      
    }
    

