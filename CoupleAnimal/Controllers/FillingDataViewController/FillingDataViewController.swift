//
//  FillingDataViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 8.02.23.
//

import UIKit
import FirebaseStorage
class FillingDataViewController: UIViewController {
    static let id = String(describing: FillingDataViewController.self)
    
    
    @IBOutlet weak var petImage: UIImageView!
    @IBOutlet weak var petNicknameTextField: UITextField!
    @IBOutlet weak var petGenderSegmentControl: UISegmentedControl!
    @IBOutlet weak var petBreedTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var infoTextField: UITextField!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var warningLabel: UILabel!
    
    var email = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        petImage.isUserInteractionEnabled = true
        petImage.layer.cornerRadius = 25
        warningLabel.isHidden = true
        addGestures()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
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
    
 
    @objc func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    @objc func didTapContentView() {
        view.endEditing(true)
    }
    
    
    @IBAction func buttonDidTap(_ sender: UIButton!) {
    
        guard let nickname = petNicknameTextField.text,
              let breed = petBreedTextField.text,
              let location = locationTextField.text,
              let weight = Int(weightTextField.text!),
              let height = Int(heightTextField.text!),
              let info = infoTextField.text else { return warningLabel.isHidden = false }
        
        
        DatabaseManager.shared.readUser(email: email) { [weak self] userData in
            guard let strongSelf = self else { return }
            guard let name = userData["name"] as? String,
                  let id = userData["id"] as? String else { return }
            let user = UserModel(name: name, id: id, emailAddress: strongSelf.email)
            user.nickname = nickname
            user.species = breed
            user.location = location
            user.weight = Double(weight)
            user.height = Double(height)
            user.additionalInfo = info
            user.isFillingTheData = true
            DatabaseManager.shared.addAditionalInfo(user: user) { success in
                if success {
                    guard let image = strongSelf.petImage.image,
                            let data = image.pngData() else {
                        return
                    }
                    let fileName = user.profileImageLink
                    StorageManager.shared.uploadProfilePicture(data: data, fileName: fileName) { result in
                        switch result {
                        case .success(let downlandUrl):
                            DefaultsManager.profileURL = downlandUrl
                            DefaultsManager.rememberMe = true
                            print(downlandUrl)
                            let vc = TabBarController(nibName: "TabBarController", bundle: nil)
                            strongSelf.navigationController?.pushViewController(vc, animated: true)
                        case .failure(let error):
                            print("Storage error \(error)")
                        }
                    }
                }
            }
        }
    }
    

}

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
        self.petImage.image = selectedImage
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


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
        } else if locationTextField == textField {
            let maxLength = 20
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
        }
        return true
    }
}



