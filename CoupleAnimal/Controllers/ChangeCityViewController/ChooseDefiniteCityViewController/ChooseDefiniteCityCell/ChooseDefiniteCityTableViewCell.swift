//
//  ChooseDefiniteCityTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 5.03.23.
//

import UIKit

class ChooseDefiniteCityTableViewCell: UITableViewCell {
    
    static let id = String(describing: ChooseDefiniteCityTableViewCell.self)

    @IBOutlet weak var cityLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    func set(city: String) {
        cityLabel.text = city
    }
    
}
