//
//  InformationTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 29.01.23.
//

import UIKit

class InformationTableViewCell: UITableViewCell {
    static let id = String(describing: InformationTableViewCell.self)

    @IBOutlet weak var additionalInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func set(userInfo: [String: Any]) {
        guard let additionalInfo = userInfo["info"] as? String else { return }
       
        additionalInfoLabel.text = additionalInfo
        
    }
    
}
