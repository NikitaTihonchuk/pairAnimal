//
//  MainViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 18.01.23.
//


protocol UpdateTableView: UIViewController {
    func update(selectedIndex: Int)
    func goToProfile(user: UserModel)
    func changeCity()
}

import UIKit

class MainViewController: UIViewController, UpdateTableView {
    

    @IBOutlet weak var mainTableView: UITableView!
    
    private var tableRows:[MainEnum] = MainEnum.allCases
    
    var usersArray = [UserModel]() {
        didSet {
            mainTableView.reloadData()
        }
    }
    var animalType: CategoryEnum = .dogs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        registerCell()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        getAllUsersData()
    }
    
    func changeCity() {
        let vc = ChangeCityViewController(nibName: ChangeCityViewController.id, bundle: nil)
        self.present(vc, animated: true)
    }
    
    func update(selectedIndex: Int) {
        
        if selectedIndex == 0 {
            animalType = .dogs
        } else if selectedIndex == 1 {
            animalType = .cats
        }
        getAllUsersData()
    }
    
    func goToProfile(user: UserModel) {
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        vc.email = user.safeEmail
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    private func getAllUsersData() {
        usersArray.removeAll()
        DatabaseManager.shared.getAllUsers { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let success):
                for value in success.keys {
                    DatabaseManager.shared.readUser(email: value) { user in
                        guard let nickname = user["nickname"] as? String,
                        let location = user["location"] as? String,
                        let name = user["name"] as? String,
                        let additionalInfo = user["additionalInfo"] as? String,
                        let id = user["id"] as? String,
                        let species = user["species"] as? String,
                        let age = user["age"] as? Int,
                        let weight = user["weight"] as? Double,
                        let height = user["height"] as? Double,
                        let gender = user["gender"] as? String ,
                        let animal = user["animal"] as? Int else { return }
                        if animal == strongSelf.animalType.animalType {
                            let user = UserModel(nickname: nickname, location: location, name: name, additionalInfo: additionalInfo, id: id, species: species, age: age, weight: weight, height: height, gender: gender, emailAddress: value)
                            user.animal = animal
                            
                            strongSelf.usersArray.append(user)
                        }
                    }
                }
            case .failure(let failure):
                print(failure)
            }
            //strongSelf.delegate?.update()
        }
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
            categoryCell.delegate = self
            return categoryCell
        case .pets:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: PetsTableViewCell.id, for: indexPath)
            guard let petsCell = cell as? PetsTableViewCell else { return cell }
            petsCell.delegate = self
            petsCell.setAnimal(animal: animalType)
            petsCell.setUser(users: usersArray)
            return petsCell
            
        }
    }
    
    
}
