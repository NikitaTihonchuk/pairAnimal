//
//  WelcomePageViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 5.02.23.
//

import UIKit
import JGProgressHUD

class WelcomePageViewController: UIViewController {
    static let id = String(describing: WelcomePageViewController.self)
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        if DefaultsManager.rememberMe {
            SetupSceneDelegate.sceneDelegate?.setTabbarAsInitial()
        }
        loginButton.layer.cornerRadius = 12
        signUpButton.layer.cornerRadius = 12

    }
    
    private func showMyViewControllerInACustomizedSheet() {
        let viewControllerToPresent = RegistrationViewController(nibName: RegistrationViewController.id, bundle: nil)
        if let sheet = viewControllerToPresent.sheetPresentationController {
            sheet.detents = [ .large()]
            sheet.preferredCornerRadius = 30
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        
        present(viewControllerToPresent, animated: true)

    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
       
       showMyViewControllerInACustomizedSheet()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let loginVC = LoginViewController(nibName: LoginViewController.id, bundle: nil)
        if let sheet = loginVC.sheetPresentationController {
            sheet.detents = [ .large()]
            sheet.preferredCornerRadius = 30
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.prefersScrollingExpandsWhenScrolledToEdge = true
            sheet.prefersEdgeAttachedInCompactHeight = true
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
        }
        present(loginVC, animated: true)
    }
    
    

}
