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
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(didTapContentView))
        self.contentView.addGestureRecognizer(viewGesture)
    }
    
    @objc func didTapContentView() {
        contentView.endEditing(true)
    }
    
    func set(text: String) {
        cityNameButton.setTitle(text, for: .normal)
    }
    
    
    @IBAction func notificationButtonDidTap(_ sender: UIButton) {
        delegate?.notificationVC()
    }
    
    
    @IBAction func cityNameButtonDidTap(_ sender: UIButton) {
        delegate?.changeCity()
    }
    
    
}
