//
//  UserModel.swift
//  CoupleAnimal
//
//  Created by Nikita on 5.02.23.
//

import Foundation
import UIKit

class UserModel {
    var nickname: String?
    var species: String?
    var age: Int?
    var weight: Double?
    var location: String?
    var name: String?
    var height: Double?
    var additionalInfo: String?
    var id: String?
    var gender: DogGenderEnum?
    
    
    
    
    convenience init(nickname: String, location: String, name: String, additionalInfo: String, id: String, species: String, age: Int, weight: Double, height: Double, gender: DogGenderEnum) {
        self.init()
        self.nickname = nickname
        self.location = location
        self.name = name
        self.additionalInfo = additionalInfo
        self.id = id
        self.species = species
        self.age = age
        self.weight = weight
        self.height = height
        self.gender = gender
    }
}
