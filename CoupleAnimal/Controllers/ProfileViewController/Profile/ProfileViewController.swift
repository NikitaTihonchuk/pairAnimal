//
//  ProfileViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 18.01.23.
//

import UIKit
import JGProgressHUD
import SDWebImage

class ProfileViewController: UIViewController, GoToChatController{

    @IBOutlet weak var doggyImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    
    private let spinner = JGProgressHUD(style: .dark)
    
    var personInfo = [String:Any]() {
        didSet {
            profileTableView.reloadData()
        }
    }
    var email: String?
    var settingPoints: [ProfileInfoEnum] = ProfileInfoEnum.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailFirstCheck()
    }
    //MARK: Objc functions
    
    @objc private func addTapped() {
        let vc = SettingsViewController(nibName: SettingsViewController.id, bundle: nil)
        present(vc, animated: true)
    }
    ///change user data
    @objc private func changeAdditionalInformation() {
        let vc = FillingDataViewController(nibName: FillingDataViewController.id, bundle: nil)
        guard let userEmail = email else { return }
        vc.email = userEmail
        vc.delegate = self
        vc.setTextFields(person: personInfo, doggyImage: doggyImage)
        present(vc, animated: true)
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    //MARK: Functions

    private func registerCell() {
        let nib = UINib(nibName: LocationTableViewCell.id , bundle: nil)
        profileTableView.register(nib, forCellReuseIdentifier: LocationTableViewCell.id)
        
        let nib2 = UINib(nibName: AchievementTableViewCell.id , bundle: nil)
        profileTableView.register(nib2, forCellReuseIdentifier: AchievementTableViewCell.id)
        
        let nib3 = UINib(nibName: OwnerTableViewCell.id , bundle: nil)
        profileTableView.register(nib3, forCellReuseIdentifier: OwnerTableViewCell.id)
        
        let nib4 = UINib(nibName: InformationTableViewCell.id , bundle: nil)
        profileTableView.register(nib4, forCellReuseIdentifier: InformationTableViewCell.id)
    }
    
    ///function that check if user have own email or another and insert data in Profile depending on that email
    func emailFirstCheck() {
        if let email = email {
            DatabaseManager.shared.readUser(email: email) { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.personInfo = data
                strongSelf.profileTableView.delegate = strongSelf
                strongSelf.profileTableView.dataSource = strongSelf
                strongSelf.getImage(email: strongSelf.email)
            }
        } else {
            self.email = DefaultsManager.safeEmail
            guard let email = DefaultsManager.safeEmail else { return }
            DatabaseManager.shared.readUser(email: email) { [weak self] data in
                guard let strongSelf = self else { return }
                strongSelf.personInfo = data
                strongSelf.profileTableView.delegate = strongSelf
                strongSelf.profileTableView.dataSource = strongSelf
                strongSelf.getImage(email: email)
                let gesture = UITapGestureRecognizer(target: strongSelf,
                                                     action: #selector(strongSelf.didTapChangeProfilePic))
                strongSelf.doggyImage.isUserInteractionEnabled = true
                strongSelf.doggyImage.addGestureRecognizer(gesture)
                strongSelf.addBarButton()
            }
        }
        
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 50
        registerCell()
        
    }
    
    
    private func addBarButton() {
        let rightBarSettingsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let settingsImage = UIImage(systemName: "gear")
        rightBarSettingsButton.setImage(settingsImage, for: .normal)
        rightBarSettingsButton.tintColor = UIColor().hexStringToUIColor(hex: "#D7484B")
        rightBarSettingsButton.layer.cornerRadius = 15
        rightBarSettingsButton.backgroundColor = UIColor.white
        rightBarSettingsButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightBarSettingsButton)
        navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarCancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let cancelImage = UIImage(systemName: "person.fill")
        leftBarCancelButton.setImage(cancelImage, for: .normal)
        leftBarCancelButton.tintColor = UIColor().hexStringToUIColor(hex: "#D7484B")
        leftBarCancelButton.layer.cornerRadius = 15
        leftBarCancelButton.backgroundColor = UIColor.white
        leftBarCancelButton.addTarget(self, action: #selector(changeAdditionalInformation), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftBarCancelButton)
        navigationItem.leftBarButtonItem = leftBarButton
        
        
    }
    ///get Image to profile controller and than download
    private func getImage(email: String?) {
        guard let safeEmail = email else { return }
        let fileName = safeEmail+"_profile_picture.png"
        let path = "images/"+fileName
        StorageManager.shared.downloadURL(path: path) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let url):
                strongSelf.downloadImage(imageView: strongSelf.doggyImage, url: url)
            case .failure(let failure):
                print("Failed to download url \(failure) ")
            }
        }
    }
    
    private func downloadImage(imageView: UIImageView, url: URL) {
        spinner.show(in: view)
        
        imageView.sd_setImage(with: url)
        spinner.dismiss()
    }
    ///get data
    private func getData() {
        guard let email = DefaultsManager.safeEmail else { return }
        DatabaseManager.shared.readUser(email: email) { data in
            self.personInfo = data
            self.profileTableView.delegate = self
            self.profileTableView.dataSource = self
            self.getImage(email: email)
        }
    }
    
    //MARK: Protocol Functions
    func updateTableView() {
        emailFirstCheck()
    }
    ///function that pass data about selected user in ConversationController
    func goToChatVC(email: String) {
        
        DatabaseManager.shared.conversationExists(iwth: email, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let conversationId):
                let vc = ConversationViewController(with: email, id: conversationId)
                vc.isNewConversation = false
                guard let nickname = strongSelf.personInfo["nickname"] as? String else { return }
                vc.title = nickname
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            case .failure(_):
                let vc = ConversationViewController(with: email, id: nil)
                vc.isNewConversation = true
                guard let nickname = strongSelf.personInfo["nickname"] as? String else { return }
                vc.title = nickname
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
        
    }

}
//MARK: TableViewDelegate and DataSource
extension ProfileViewController: UITableViewDelegate {
    
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingPoints.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let typeCell = settingPoints[indexPath.row]
        
        switch typeCell {
        case .location:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.id, for: indexPath)
            guard let locationCell = cell as? LocationTableViewCell else { return cell }
            if email == DefaultsManager.safeEmail {
                locationCell.likeButton.isHidden = true
            }
            locationCell.set(userInfo: personInfo)
            return locationCell
        case .achievement:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: AchievementTableViewCell.id, for: indexPath)
            guard let achievementCell = cell as? AchievementTableViewCell else { return cell }
            achievementCell.set(userInfo: personInfo)
            return achievementCell
        case .owner:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: OwnerTableViewCell.id, for: indexPath)
            guard let ownerCell = cell as? OwnerTableViewCell else { return cell }
            if email == DefaultsManager.safeEmail {
                ownerCell.messageMeButton.isHidden = true
            }
            ownerCell.email = email
            ownerCell.delegate = self
            ownerCell.set(userInfo: personInfo)
            return ownerCell
        case .information:
            let cell = profileTableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.id, for: indexPath)
            guard let infoCell = cell as? InformationTableViewCell else { return cell }
            infoCell.set(userInfo: personInfo)
            return infoCell
        }
    }
}

//MARK: Extension for ImagePickerDelegate and navControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select the photo?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose from library",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true )
    }
    ///present camera
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    ///present photo picker
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        ///get image
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.doggyImage.image = selectedImage
        
        guard let image = doggyImage.image,
                let data = image.pngData(),
                let name = DefaultsManager.safeEmail else {
            return
        }
        let fileName = "\(name)_profile_picture.png"
        ///upload image
        StorageManager.shared.uploadProfilePicture(data: data, fileName: fileName) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let downlandUrl):
                DefaultsManager.profileURL = downlandUrl
                strongSelf.getImage(email: name)
            case .failure(let error):
                print("Storage error \(error)")
            }
        }
    }
    ///action for cancel button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
