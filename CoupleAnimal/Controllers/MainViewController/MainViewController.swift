//
//  MainViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 18.01.23.
//


protocol UpdateTableView: UIViewController {
    func update()
    func goToProfile(user: UserModel)
    func changeCity()
}

import UIKit

class MainViewController: UIViewController, UpdateTableView {
    

    @IBOutlet weak var mainTableView: UITableView!
    
    private var tableRows:[MainEnum] = MainEnum.allCases
    
    var usersArray = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

        registerCell()
        mainTableView.delegate = self
        mainTableView.dataSource = self
    }
    
    func changeCity() {
        let vc = ChangeCityViewController(nibName: ChangeCityViewController.id, bundle: nil)
        self.present(vc, animated: true)
    }
    
    func update() {
        mainTableView.reloadData()
    }
    
    func goToProfile(user: UserModel) {
        let vc = PetProfileViewController(nibName: "PetProfileViewController", bundle: nil)
        vc.user = user
        self.present(vc, animated: true)
    }
    
    
    private func registerCell() {
        let nib = UINib(nibName: PetsTableViewCell.id , bundle: nil)
        mainTableView.register(nib, forCellReuseIdentifier: PetsTableViewCell.id)
        
        let nib2 = UINib(nibName: CategoryTableViewCell.id , bundle: nil)
        mainTableView.register(nib2, forCellReuseIdentifier: CategoryTableViewCell.id)
        
        let nib3 = UINib(nibName: SearchTableViewCell.id , bundle: nil)
        mainTableView.register(nib3, forCellReuseIdentifier: SearchTableViewCell.id)
        
        let nib4 = UINib(nibName: PersonalLocationTableViewCell.id , bundle: nil)
        mainTableView.register(nib4, forCellReuseIdentifier: PersonalLocationTableViewCell.id)
    }

}

extension MainViewController: UITableViewDelegate {
    
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let typeCell = tableRows[indexPath.row]
        
        switch typeCell {
        case .location:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: PersonalLocationTableViewCell.id, for: indexPath)
            guard let locationCell = cell as? PersonalLocationTableViewCell else { return cell }
            locationCell.delegate = self
            return locationCell
        case .search:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath)
            guard let searchCell = cell as? SearchTableViewCell else { return cell }
            return searchCell
        case .category:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.id, for: indexPath)
            guard let categoryCell = cell as? CategoryTableViewCell else { return cell }
            return categoryCell
        case .pets:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: PetsTableViewCell.id, for: indexPath)
            guard let petsCell = cell as? PetsTableViewCell else { return cell }
            petsCell.delegate = self
            return petsCell
            
        }
    }
    
    
}
