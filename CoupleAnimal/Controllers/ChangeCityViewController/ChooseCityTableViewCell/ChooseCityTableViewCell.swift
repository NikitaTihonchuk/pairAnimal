//
//  ChooseCityTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 5.03.23.
//

import UIKit

class ChooseCityTableViewCell: UITableViewCell {
    static let id = String(describing: ChooseCityTableViewCell.self)

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setLabel(city: String) {
        nameLabel.text = city
    }
    
}
