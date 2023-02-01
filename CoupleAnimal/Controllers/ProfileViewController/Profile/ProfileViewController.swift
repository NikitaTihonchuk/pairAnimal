//
//  ProfileViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 18.01.23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var doggyImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    
    var settingPoints: [ProfileInfoEnum] = ProfileInfoEnum.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 50
        
        registerCell()
        profileTableView.delegate = self
        profileTableView.dataSource = self
    }

    private func registerCell() {
        let nib = UINib(nibName: LocationTableViewCell.id , bundle: nil)
        profileTableView.register(nib, forCellReuseIdentifier: LocationTableViewCell.id)
        
        let nib2 = UINib(nibName: AchievementTableViewCell.id , bundle: nil)
        profileTableView.register(nib2, forCellReuseIdentifier: AchievementTableViewCell.id)
        
        let nib3 = UINib(nibName: OwnerTableViewCell.id , bundle: nil)
        profileTableView.register(nib3, forCellReuseIdentifier: OwnerTableViewCell.id)
        
        let nib4 = UINib(nibName: InformationTableViewCell.id , bundle: nil)
        profileTableView.register(nib4, forCellReuseIdentifier: InformationTableViewCell.id)
    }

}

extension ProfileViewController: UITableViewDelegate {
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let typeCell = settingPoints[indexPath.row]
        
        switch typeCell {
        case .location:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.id, for: indexPath)
            guard let locationCell = cell as? LocationTableViewCell else { return cell }
            return locationCell
        case .achievement:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: AchievementTableViewCell.id, for: indexPath)
            guard let achievementCell = cell as? AchievementTableViewCell else { return cell }
            return achievementCell
        case .owner:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: OwnerTableViewCell.id, for: indexPath)
            guard let ownerCell = cell as? OwnerTableViewCell else { return cell }
            return ownerCell
        case .information:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.id, for: indexPath)
            guard let infoCell = cell as? InformationTableViewCell else { return cell }
            return infoCell
        }
    }




}
