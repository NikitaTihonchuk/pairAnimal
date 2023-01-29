//
//  AchievementTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 29.01.23.
//

import UIKit

class AchievementTableViewCell: UITableViewCell {

    static let id = String(describing: AchievementTableViewCell.self)
    
    
    @IBOutlet weak var achievementCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCell()
        achievementCollection.delegate = self
        achievementCollection.dataSource = self
    }

    private func registerCell() {
        let nib = UINib(nibName: AchievementCollectionViewCell.id, bundle: nil)
        achievementCollection.register(nib, forCellWithReuseIdentifier: AchievementCollectionViewCell.id)
    }
    
}

extension AchievementTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = achievementCollection.dequeueReusableCell(withReuseIdentifier: AchievementCollectionViewCell.id, for: indexPath)
        guard let achievmentCell = cell as? AchievementCollectionViewCell else { return cell }
        return achievmentCell
    }
    
    
}


extension AchievementTableViewCell: UICollectionViewDelegate {
    
}
