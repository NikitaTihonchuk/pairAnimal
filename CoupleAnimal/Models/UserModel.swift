//
//  UserModel.swift
//  CoupleAnimal
//
//  Created by Nikita on 5.02.23.
//

import Foundation
import UIKit

class UserModel {
    var nickname: String = ""
    var species: String = ""
    var age: Int = 0
    var weight: Double = 0.0
    var location: String = ""
    var name: String = "unknown"
    var height: Double = 0.0
    var additionalInfo: String = ""
    var id: String
    var gender = DogGenderEnum.male
    var emailAddress: String
    
    var safeEmail: String {
        var safemail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safemail = safemail.replacingOccurrences(of: "@", with: "-")
        return safemail
    }
    
    var profileImageLink: String {
        return "\(safeEmail)_profile_picture.png"
         
    }
    
    var isFillingTheData = false
    
   /* convenience init(nickname: String, location: String, name: String, additionalInfo: String, id: String, species: String, age: Int, weight: Double, height: Double, gender: DogGenderEnum,         emailAddress: String) {
        self.init()
        self.nickname = nickname
        self.location = location
        self.emailAddress = emailAddress
        self.name = name
        self.additionalInfo = additionalInfo
        self.id = id
        self.species = species
        self.age = age
        self.weight = weight
        self.height = height
        self.gender = gender
    }*/
    
    init(name: String, id: String, emailAddress: String) {
        self.emailAddress = emailAddress
        self.name = name
        self.id = id
    }
}
