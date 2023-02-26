//
//  PersonalLocationTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 22.02.23.
//

import UIKit

//на этом контроллере нужно повесить гестуру на кнопку и прописать действия для уведомлений(кнопка справа)

class PersonalLocationTableViewCell: UITableViewCell {
    
    static let id = String(describing: PersonalLocationTableViewCell.self)
    
    @IBOutlet weak var cityNameButton: UIButton!
    @IBOutlet weak var imageDown: UIImageView!
    @IBOutlet weak var notificationButton: UIButton!
    
    weak var delegate: UpdateTableView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func set(text: String) {
        cityNameButton.setTitle(text, for: .normal)
    }
    
    @IBAction func cityNameButtonDidTap(_ sender: UIButton) {
        delegate?.changeCity()
    }
    
    
}
