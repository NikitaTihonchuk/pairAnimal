//
//  ChatTableViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 16.02.23.
//

import UIKit
import SDWebImage

class ChatTableViewCell: UITableViewCell {
    static let id = String(describing: ChatTableViewCell.self)
    
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var indicatorPicture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.frame.width / 2
    }


    func set(conversation: Conversation) {
        senderNameLabel.text = conversation.name
        senderTextLabel.text = conversation.latestMessage.text
        
        let path = "images/\(conversation.otherUserEmail)_profile_picture.png"
        StorageManager.shared.downloadURL(path: path) { [weak self] result in
            switch result {
                
            case .success(let url):
                DispatchQueue.main.async {
                    self?.profilePicture.sd_setImage(with: url, completed: nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        //profilePicture.image = userModel.profileImageLink
        
    }
    
}
