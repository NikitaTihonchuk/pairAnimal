//
//  CategoryCollectionViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 22.02.23.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: CategoryCollectionViewCell.self)

    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var categoryBackgroundView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryBackgroundView.layer.cornerRadius = 25
        categoryBackgroundView.layer.masksToBounds = true

    }
    
    func set(text: String) {
        nicknameLabel.text = text
    }

}
