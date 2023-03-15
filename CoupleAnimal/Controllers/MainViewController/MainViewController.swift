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
    func notificationVC()
    func searchResult(text: String)
}

import UIKit

class MainViewController: UIViewController, UpdateTableView, CityProtocol {

    @IBOutlet weak var mainTableView: UITableView!
    
    private var tableRows:[MainEnum] = MainEnum.allCases
    private var personalEmail = DefaultsManager.safeEmail
    private var filterArray: [UserModel]? = nil

    var animalType: CategoryEnum = .dogs
    var city: String? = nil

    private var searchResult: String? = nil {
        didSet {
            usersFilter()
        }
    }
    
    var usersArray = [UserModel]() {
        didSet {
            usersFilter()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.keyboardDismissMode = .onDrag
        self.navigationController?.isNavigationBarHidden = true
        registerCell()
        mainTableView.delegate = self
        mainTableView.dataSource = self
        getAllUsersData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true

    }
    //MARK: Protocol Fuctions
    func changeCity() {
        let vc = ChooseCityViewController(nibName: "ChooseCityViewController", bundle: nil)
        vc.delegate = self
        self.present(vc, animated: true)
        
    }
    
    func notificationVC() {
        let vc = NotificationViewController(nibName: NotificationViewController.id, bundle: nil)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func update(text: String) {
        city = text
        getAllUsersData()
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
        self.navigationController?.isNavigationBarHidden = false
        let vc = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        vc.email = user.safeEmail
        vc.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func searchResult(text: String) {
        searchResult = text
    }
    
    //MARK: Register Cells
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
    
    //MARK: Get and filter user
    private func getAllUsersData() {
        usersArray.removeAll()
        
        guard let ownEmail = personalEmail else { return }
        DatabaseManager.shared.getAllUsers { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let success):
                for value in success.keys {
                    if value != ownEmail {
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
                            let user = UserModel(nickname: nickname, location: location, name: name, additionalInfo: additionalInfo, id: id, species: species, age: age, weight: weight, height: height, gender: gender, emailAddress: value)
                            user.animal = animal
                            
                            strongSelf.usersArray.append(user)
                        }
                    }
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func usersFilter() {
        filterArray = usersArray.filter { $0.animal == animalType.animalType }
        if let city = self.city {
            filterArray = filterArray?.filter({ $0.location == city })
        }
        if searchResult != nil, searchResult != "", searchResult != " " {
            var filtredData = [UserModel]()
            let text = searchResult!.lowercased()
            guard let filterArray = filterArray else { return }
            for user in filterArray {
                let isArrayContain = user.nickname.lowercased().range(of: text)
                if isArrayContain != nil {
                    print("Search Complete")
                    filtredData.append(user)
                }
                self.filterArray = filtredData
            }
        }
        mainTableView.reloadData()
    }

}
//MARK: TableView DataSource and Delegate

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
            if let city = city {
                locationCell.set(text: city)
            }
            
            return locationCell
        case .search:
            let cell = mainTableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.id, for: indexPath)
            guard let searchCell = cell as? SearchTableViewCell else { return cell }
            searchCell.delegate = self

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
            guard let filterArray = filterArray else { return petsCell }
            petsCell.setUser(users: filterArray)
            
            return petsCell
            
        }
    }
    
    
}
