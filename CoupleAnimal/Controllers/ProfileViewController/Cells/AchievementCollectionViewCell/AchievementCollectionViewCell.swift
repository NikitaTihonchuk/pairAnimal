//
//  AchievementCollectionViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 29.01.23.
//

import UIKit

class AchievementCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: AchievementCollectionViewCell.self)
    
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var collectionBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionBackgroundView.layer.masksToBounds = true
        collectionBackgroundView.layer.cornerRadius = 25
    }
    
    
}
