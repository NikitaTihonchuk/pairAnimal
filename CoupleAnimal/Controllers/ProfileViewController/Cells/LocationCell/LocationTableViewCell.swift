//
//  LocationTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 29.01.23.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    static let id = String(describing: LocationTableViewCell.self)
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func set(userInfo: [String: Any]) {
        guard let nickname = userInfo["nickname"] as? String else { return }
        guard let location = userInfo["location"] as? String else { return }

        nicknameLabel.text = nickname
        locationLabel.text = location
    }

}
