//
//  ChatTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 16.02.23.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    static let id = String(describing: ChatTableViewCell.self)
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var indicatorPicture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    
}
