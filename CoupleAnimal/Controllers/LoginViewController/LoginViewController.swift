//
//  LoginViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 1.02.23.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    static let id = String(describing: LoginViewController.self)
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    private let spinner = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

    @IBAction func loginButtonDidTap(_ sender: UIButton) {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        spinner.show(in: view)
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] loginResult, error in
            guard let strongSelf = self else { return }
            guard let result = loginResult, error == nil else {
                DispatchQueue.main.async {
                    strongSelf.spinner.dismiss()
                }
                strongSelf.showAlert(title: "Error", message: "Sorry, the data is incorrect", bool: true)
                return
            }
        
            DatabaseManager.shared.readUser(email: email) { [weak self] userInfo in
                guard let strongSelf = self else { return }
                var safeEmail = email.replacingOccurrences(of: ".", with: "-")
                safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
                DefaultsManager.safeEmail = safeEmail
                DispatchQueue.main.async {
                    strongSelf.spinner.dismiss()
                }
                if userInfo.isEmpty {
                    return
                } else {
                    guard let isFullRegister = userInfo["fullRegister"] as? Bool else { return }
                    DefaultsManager.dogName = userInfo["nickname"] as? String
                    if isFullRegister {
                        let vc = TabBarController(nibName: "TabBarController", bundle: nil)
                        DefaultsManager.rememberMe = true
                        strongSelf.dismiss(animated: true) {
                            UIView.animate(withDuration: 0.3) {
                                SetupSceneDelegate.sceneDelegate?.setAsInitial(vc: vc)
                            }
                        }
                    } else {
                        let vc = FillingDataViewController(nibName: FillingDataViewController.id, bundle: nil)
                        vc.email = email
                        strongSelf.dismiss(animated: true) {
                            UIView.animate(withDuration: 0.3) {
                                SetupSceneDelegate.sceneDelegate?.setAsInitial(vc: vc)
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @IBAction func backButttonDidTap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
}
