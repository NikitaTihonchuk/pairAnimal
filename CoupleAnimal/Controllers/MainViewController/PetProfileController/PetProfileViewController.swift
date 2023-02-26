//
//  PetProfileViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 23.02.23.
//

import UIKit

class PetProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var additionalInfoLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    var user: UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameLabel.text = user?.nickname
        additionalInfoLabel.text = user?.additionalInfo
        cityLabel.text = user?.location
    }



}
