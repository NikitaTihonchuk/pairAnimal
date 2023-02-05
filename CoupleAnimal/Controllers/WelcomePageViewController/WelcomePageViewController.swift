//
//  WelcomePageViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 5.02.23.
//

import UIKit

class WelcomePageViewController: UIViewController {
    static let id = String(describing: WelcomePageViewController.self)
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.layer.cornerRadius = 12
        signUpButton.layer.cornerRadius = 12

    }


}
