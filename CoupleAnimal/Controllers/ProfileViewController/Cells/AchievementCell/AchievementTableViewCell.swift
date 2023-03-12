//
//  AchievementTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 29.01.23.
//

import UIKit

class AchievementTableViewCell: UITableViewCell {

    static let id = String(describing: AchievementTableViewCell.self)
    var dictionary = [String:Any]()
    @IBOutlet weak var achievementCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        achievementCollection.dataSource = self
    }
    
    func set(userInfo: [String: Any]) {
        guard let breed = userInfo["breed"] as? String else { return }
        dictionary["breed"] = breed
        guard let weight = userInfo["weight"] as? Int else { return }
        dictionary["weight"] = weight
        guard let height = userInfo["height"] as? Int else { return }
        dictionary["height"] = height
        guard let age = userInfo["age"] as? Int else { return }
        dictionary["age"] = age
        achievementCollection.reloadData()
    }
    
    

    private func registerCell() {
        let nib = UINib(nibName: AchievementCollectionViewCell.id, bundle: nil)
        achievementCollection.register(nib, forCellWithReuseIdentifier: AchievementCollectionViewCell.id)
    }
    
    
}

extension AchievementTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dictionary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.row)
        let cell = achievementCollection.dequeueReusableCell(withReuseIdentifier: AchievementCollectionViewCell.id, for: indexPath)
        guard let achievmentCell = cell as? AchievementCollectionViewCell else { return cell }
        
        switch indexPath.row {
            case 0:
                achievmentCell.valueLabel.text = "Breed"
                guard let breed = dictionary["breed"] as? String else { return cell }
                achievmentCell.typeLabel.text = "\(breed)"
            case 1:
                achievmentCell.valueLabel.text = "Weight"
                guard let weight = dictionary["weight"] as? Int else { return cell }
                achievmentCell.typeLabel.text = "\(weight) kg"
            achievmentCell.backgroundImage.isHidden = true
            achievmentCell.collectionBackgroundView.backgroundColor = .lightGray
            case 2:
                achievmentCell.valueLabel.text = "Height"
                guard let height = dictionary["height"] as? Int else { return cell }
                achievmentCell.typeLabel.text = "\(height) сm"
                achievmentCell.typeLabel.textColor = .white
                achievmentCell.valueLabel.textColor = .white
                achievmentCell.backgroundImage.isHidden = true
                achievmentCell.collectionBackgroundView.backgroundColor = .blue
            case 3:
                achievmentCell.valueLabel.text = "Age"
                guard let age = dictionary["age"] as? Int else { return cell }
                achievmentCell.typeLabel.text = "\(age) years"
                achievmentCell.typeLabel.textColor = .white
                achievmentCell.valueLabel.textColor = .white
                achievmentCell.backgroundImage.isHidden = true
                achievmentCell.collectionBackgroundView.backgroundColor = .systemRed
            default:
                return achievmentCell
            }
         return achievmentCell
    }
}
