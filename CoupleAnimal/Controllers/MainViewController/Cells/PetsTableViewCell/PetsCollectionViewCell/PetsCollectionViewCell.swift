//
//  PetsCollectionViewCell.swift
//  CoupleAnimal
//
//  Created by Nikita on 22.02.23.
//

import UIKit
//узнать у ильи по поводу изменения ячеек

class PetsCollectionViewCell: UICollectionViewCell {
    static let id = String(describing: PetsCollectionViewCell.self)

    
    @IBOutlet weak var photoProfileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var backgroundPetCollectionCell: UIView!
    @IBOutlet weak var likeButton: UIButton!
    
    var isCellSelected = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
       super.prepareForReuse()
       //Do reset here
        nicknameLabel.text = nil
        speciesLabel.text = ""
        likeButton.tintColor = nil
        
        photoProfileImageView.image = nil

   }
    
    func set(users: UserModel) {
        nicknameLabel.text = users.nickname
        speciesLabel.text = users.species
        ageLabel.text = String(users.age)
        getImage(email: users.safeEmail)
    }
    
    private func getImage(email: String?) {
        guard let safeEmail = email else { return }
        let fileName = safeEmail+"_profile_picture.png"
        let path = "images/"+fileName
        StorageManager.shared.downloadURL(path: path) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let url):
                strongSelf.downloadImage(imageView: strongSelf.photoProfileImageView, url: url)
            case .failure(let failure):
                print("Failed to download url \(failure) ")
            }
        }
    }
    
    private func downloadImage(imageView: UIImageView, url: URL) {
        imageView.sd_setImage(with: url)
    }
    
    @IBAction func likeButtonDidTap(_ sender: UIButton) {
        isCellSelected = !isCellSelected
        if isCellSelected {
            likeButton.tintColor = .purple
        } else {
            likeButton.tintColor = nil
        }
    }
    
    
    
}
