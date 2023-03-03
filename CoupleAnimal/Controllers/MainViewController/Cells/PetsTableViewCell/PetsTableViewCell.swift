//
//  PetsTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 22.02.23.
//



protocol ProfileInformation: AnyObject {
    var color: UIColor { get }
    
}

import UIKit

class PetsTableViewCell: UITableViewCell, ProfileInformation {
    
    static let id = String(describing: PetsTableViewCell.self)
    
    @IBOutlet weak var petsCollectionView: UICollectionView!
    var color: UIColor = .red
    weak var delegate: UpdateTableView?
    
    var users = [UserModel]() {
        didSet {
            petsCollectionView.reloadData()
        }
    }
    
    var animalType: CategoryEnum = .dogs {
        didSet {
            //getAllUsersData()
            petsCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        petsCollectionView.delegate = self
        petsCollectionView.dataSource = self
    }
    
    func setAnimal(animal: CategoryEnum) {
        animalType = animal
        //getAllUsersData()
    }
    
    func setUser(users: [UserModel]) {
        self.users = users
    }

    
    private func registerCell() {
        let nib = UINib(nibName: PetsCollectionViewCell.id, bundle: nil)
        petsCollectionView.register(nib, forCellWithReuseIdentifier: PetsCollectionViewCell.id)
    }
}

extension PetsTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PetsCollectionViewCell.id, for: indexPath)
        guard let petCell = cell as? PetsCollectionViewCell else { return cell }
        petCell.set(users: users[indexPath.row])
        if petCell.isCellSelected {
            petCell.likeButton.tintColor = .purple
        } else {
            petCell.likeButton.tintColor = .blue
        }
        return petCell
    }
    
    
}

extension PetsTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        self.delegate?.goToProfile(user: user)
    }
    
}

extension PetsTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160.0, height: 200)
        
    }
    
}
