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

    private func showAlert(title: String, message: String, bool: Bool) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            if bool {
                let vc = LoginViewController(nibName: LoginViewController.id, bundle: nil)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        present(alert, animated: true)
    }


    @IBAction func registerButtonDidTap(_ sender: UIButton) {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            guard let result = authResult, error == nil else {
                
                self.showAlert(title: "Error", message: "please enter correct email or password", bool: false)
                return
            }
            let user = result.user
            print("Your user: \(user)")
            self.dismiss(animated: true) {
                self.showAlert(title: "Success", message: "Now you can sign in", bool: true)

            }
        }
    }
    
}
