//
//  OwnerTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 29.01.23.
//

import UIKit

class OwnerTableViewCell: UITableViewCell {
    static let id = String(describing: OwnerTableViewCell.self)

    @IBOutlet weak var nameOwner: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func set(userInfo: [String: Any]) {
        guard let nickname = userInfo["nickname"] as? String else { return }
        guard let name = userInfo["name"] as? String else { return }

        nameOwner.text = name
        title.text = "\(nickname) owner"
    }
    
}
