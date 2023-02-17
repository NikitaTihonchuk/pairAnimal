//
//  ProfileViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 18.01.23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var doggyImage: UIImageView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    
    @IBOutlet weak var signOutButton: UIButton!
    
    var personInfo = [String: Any]() {
        didSet {
            profileTableView.reloadData()
        }
    }
    var settingPoints: [ProfileInfoEnum] = ProfileInfoEnum.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImage(email: DefaultsManager.safeEmail)
        getData()

        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePic))
        backgroundView.layer.masksToBounds = true
        backgroundView.layer.cornerRadius = 50
        doggyImage.isUserInteractionEnabled = true
        doggyImage.addGestureRecognizer(gesture)
        registerCell()
        
        addBarButton()
        
    }
    
    
    
    @objc func addTapped() {
        let vc = SettingsViewController(nibName: SettingsViewController.id, bundle: nil)
        present(vc, animated: true)
    }
    
    @objc func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    private func addBarButton() {
        let rightBarSettingsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let settingsImage = UIImage(systemName: "gear")
        rightBarSettingsButton.setImage(settingsImage, for: .normal)
        rightBarSettingsButton.tintColor = .red
        rightBarSettingsButton.layer.cornerRadius = 15
        rightBarSettingsButton.backgroundColor = UIColor.white
        rightBarSettingsButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightBarSettingsButton)
        navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarCancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                let cancelImage = UIImage(systemName: "list.dash")
        leftBarCancelButton.setImage(cancelImage, for: .normal)
        leftBarCancelButton.tintColor = .red
        leftBarCancelButton.layer.cornerRadius = 15
        leftBarCancelButton.backgroundColor = UIColor.white
      //  leftBarCancelButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftBarCancelButton)
        navigationItem.leftBarButtonItem = leftBarButton
        
        
    }
    
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
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
    }
    
    private func getData() {
        guard let email = DefaultsManager.safeEmail else { return }
        DatabaseManager.shared.readUser(email: email) { data in
            self.personInfo = data
            self.profileTableView.delegate = self
            self.profileTableView.dataSource = self
        }
        
        
    }

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
    
    
    @IBAction func signOutButton(_ sender: UIButton) {
        DefaultsManager.rememberMe = false
        let vc = WelcomePageViewController(nibName: WelcomePageViewController.id, bundle: nil)
        tabBarController?.tabBar.isHidden = true
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
 
    
}

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
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.doggyImage.image = selectedImage
        
        guard let image = doggyImage.image,
                let data = image.pngData(),
                let name = DefaultsManager.safeEmail else {
            return
        }
        let fileName = "\(name)_profile_picture.png"
        
        StorageManager.shared.uploadProfilePicture(data: data, fileName: fileName) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let downlandUrl):
                DefaultsManager.profileURL = downlandUrl
                strongSelf.getImage(email: name)
                print(downlandUrl)
            case .failure(let error):
                print("Storage error \(error)")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
