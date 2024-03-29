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

    
    @IBOutlet weak var ageView: UILabel!
    @IBOutlet weak var photoProfileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var backgroundPetCollectionCell: UIView!
    @IBOutlet weak var likeButton: UIButton!
    
    var isCellSelected = false
    var imageIsNotSelected = UIImage(systemName: "heart")
    var imageIsSelected = UIImage(systemName: "heart.fill")
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoProfileImageView.layer.masksToBounds = true
        photoProfileImageView.layer.cornerRadius = 15
    }
    
    override func prepareForReuse() {
       super.prepareForReuse()
       //Do reset here
        nicknameLabel.text = nil
        speciesLabel.text = ""
        photoProfileImageView.image = nil
        
        if isCellSelected {
            likeButton.setImage(imageIsNotSelected, for: .normal)
        } else {
            likeButton.setImage(imageIsSelected, for: .normal)
        }
        ageView.layer.masksToBounds = true
        ageView.layer.cornerRadius = 9

        //likeButton.setImage(, for: <#T##UIControl.State#>)
        

   }
    
    func set(users: UserModel) {
        nicknameLabel.text = users.nickname
        speciesLabel.text = users.species
        ageLabel.text = "\(users.age) YRS"
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
            likeButton.setImage(imageIsNotSelected, for: .normal)
        } else {
            likeButton.setImage(imageIsSelected, for: .normal)
        }
    }
    
    
    
}
