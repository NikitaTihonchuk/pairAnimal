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
    var location: String?
    var name: String?
    var additionalInfo: String?
    var id = ""
    
    var features = [String]()
    
    
    convenience init(nickname: String, location: String, name: String, additionalInfo: String) {
        self.init()
        self.nickname = nickname
        self.location = location
        self.name = name
        self.additionalInfo = additionalInfo
        self.id = UUID().uuidString
        self.features = features
    }
}
