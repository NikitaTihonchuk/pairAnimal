//
//  FillingDataViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 8.02.23.

import UIKit
import FirebaseStorage
import JGProgressHUD

class FillingDataViewController: UIViewController, CityProtocol {
    
    static let id = String(describing: FillingDataViewController.self)
    
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petNicknameTextField: UITextField!
    @IBOutlet weak var petGenderSegmentControl: UISegmentedControl!
    @IBOutlet weak var petBreedTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var animalSegment: UISegmentedControl!
    @IBOutlet weak var chooseCityButton: UIButton!
    
    
    
    private let spinner = JGProgressHUD(style: .dark)
    
    var email = "" 
    var location: String? = nil
    var user: UserModel? 
    var image = UIImage()
    
    ///delegate that pass change data to profile
    weak var delegate: GoToChatController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        petImage.isUserInteractionEnabled = true
        petImage.layer.cornerRadius = 25
        warningLabel.isHidden = true
        addGestures()
        setTextFieldText()
    }
    
   //MARK: Objc func
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    @objc private func didTapContentView() {
        view.endEditing(true)
    }
    
    //MARK: Functions
    
    ///this function calls profile to pass the data
    func setTextFields(person: [String:Any], doggyImage: UIImageView ) {
        guard let nickname = person["nickname"] as? String,
              let location = person["location"] as? String,
              let name = person["name"] as? String,
              let additionalInfo = person["additionalInfo"] as? String,
              let id = person["id"] as? String,
              let species = person["species"] as? String,
              let age = person["age"] as? Int,
              let weight = person["weight"] as? Int,
              let height = person["height"] as? Int,
              let gender = person["gender"] as? String ,
              let animal = person["animal"] as? Int else { return }
        
        let user = UserModel(name: name, id: id, emailAddress: email)
        user.gender = gender
        user.nickname = nickname
        user.species = species
        user.location = location
        user.weight = Double(weight)
        user.height = Double(height)
        user.animal = animal
        user.age = age
        user.additionalInfo = additionalInfo
        self.user = user
        
        guard let image = doggyImage.image else { return }
        
        self.image = image
    }
    
    func setTextFieldText() {
        guard let user = user else { return }
            self.petNicknameTextField.text = user.nickname
            self.petBreedTextField.text = user.species
            self.weightTextField.text = String(Int(user.weight))
            self.heightTextField.text = String(Int(user.height))
            self.location = user.location
            self.ageTextField.text = String(user.age)
            self.infoTextField.text = user.additionalInfo
            self.animalSegment.selectedSegmentIndex = user.animal
        
        petImage.image = image
        chooseCityButton.setTitle(location, for: .normal)
    }
    
    private func addGestures() {
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePic))
        petImage.isUserInteractionEnabled = true
        petImage.addGestureRecognizer(gesture)
        
        let viewGesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapContentView))
        view.addGestureRecognizer(viewGesture)
    }
    //MARK: Protocol functions
    func update(text: String) {
        self.location = text
        chooseCityButton.setTitle(location, for: .normal)
    }
    
    
    //MARK: IBActions
    @IBAction func chooseCityButton(_ sender: UIButton) {
        let vc = ChooseCityViewController(nibName: "ChooseCityViewController", bundle: nil)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    @IBAction func buttonDidTap(_ sender: UIButton!) {
        
    
        guard let nickname = petNicknameTextField.text,
              let breed = petBreedTextField.text,
              let weight = Int(weightTextField.text!),
              let height = Int(heightTextField.text!),
              let city = location,
              let age = Int(ageTextField.text!),
              let info = infoTextField.text else { return warningLabel.isHidden = false }
        
        spinner.show(in: view)
        
        DatabaseManager.shared.readUser(email: email) { [weak self] userData in
            guard let strongSelf = self else { return }
            guard let name = userData["name"] as? String,
                  let id = userData["id"] as? String else { return }
            let user = UserModel(name: name, id: id, emailAddress: strongSelf.email)
            user.nickname = nickname
            user.species = breed
            user.location = city
            user.weight = Double(weight)
            user.height = Double(height)
            user.animal = strongSelf.animalSegment.selectedSegmentIndex
            user.age = age
            user.additionalInfo = info
            user.isFillingTheData = true
            DatabaseManager.shared.addAditionalInfo(user: user) { success in
                if success {
                    guard let image = strongSelf.petImage.image,
                            let data = image.pngData() else { return }
                    let fileName = user.profileImageLink
                    
                    StorageManager.shared.uploadProfilePicture(data: data, fileName: fileName) { result in
                        DispatchQueue.main.async {
                            strongSelf.spinner.dismiss()
                        }
                        switch result {
                        case .success(let downlandUrl):
                            DefaultsManager.profileURL = downlandUrl
                            DefaultsManager.rememberMe = true
                            DefaultsManager.dogName = nickname
                            if strongSelf.user != nil {
                                strongSelf.dismiss(animated: true) {
                                    strongSelf.delegate?.updateTableView()
                                }
                            } else {
                                SetupSceneDelegate.sceneDelegate?.setTabbarAsInitial()
                            }
                        case .failure(let error):
                            print("Storage error \(error)")
                        }
                    }
                }
            }
        }
    }
    

}

//MARK: Extension ImagePickerDelegate and NavControllerDelegate

extension FillingDataViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        actionSheet.addAction(UIAlertAction(title: "Choose from library ",
                                            style: .default,
                                            handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet, animated: true )
    }
    
    func presentCamera() {
        spinner.show(in: view)
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        DispatchQueue.main.async {
            self.spinner.dismiss()
        }
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        spinner.show(in: view)
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        DispatchQueue.main.async {
            self.spinner.dismiss()
        }
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.petImage.image = selectedImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


//MARK: Extensions TextFieldDelegate
extension FillingDataViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if petNicknameTextField == textField {
            let maxLength = 25
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
        } else if weightTextField == textField {
            let maxLength = 3
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
        } else if heightTextField == textField {
            let maxLength = 3
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
        }
        return true
    }
}



