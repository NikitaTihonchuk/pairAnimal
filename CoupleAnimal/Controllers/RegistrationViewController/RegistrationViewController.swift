//
//  RegistrationViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 1.02.23.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
    static let id = String(describing: RegistrationViewController.self)
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registration"
    }


    @IBAction func registerButtonDidTap(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { result, error in
            guard error == nil else {
                
              return
            }
          
        }
    }
    
}
