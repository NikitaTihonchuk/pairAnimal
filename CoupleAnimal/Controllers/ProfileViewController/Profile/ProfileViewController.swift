//
//  ProfileViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 18.01.23.
//

import UIKit
import FloatingPanel

class ProfileViewController: UIViewController {

    @IBOutlet weak var doggyImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showFloatingPanel()
        
    }




}

extension ProfileViewController: FloatingPanelControllerDelegate {
    func showFloatingPanel() {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        let userInfoVC = AdditionalInfoViewController()
        fpc.set(contentViewController: userInfoVC)
        fpc.addPanel(toParent: self)
    }
}
