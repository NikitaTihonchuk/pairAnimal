//
//  LoginViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 1.02.23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    static let id = String(describing: LoginViewController.self)
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
    }
    
    


    @IBAction func loginButtonDidTap(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                return
            }
            
            let vc = TabBarController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func registrationButtonDidTap(_ sender: UIButton) {
        let vc = RegistrationViewController(nibName: "RegistrationViewController", bundle: nil)
        print(vc)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    @IBAction func signAsGuestButtonDidTap(_ sender: UIButton) {
    }
    
}
