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
    weak var delegate: GoToChatController?
    var email: String?
    
    @IBOutlet weak var messageMeButton: UIButton!
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
    
    
    
    @IBAction func messageMeButton(_ sender: UIButton) {
        guard let email = email else { return }
        delegate?.goToChatVC(email: email)
    }
    
}
