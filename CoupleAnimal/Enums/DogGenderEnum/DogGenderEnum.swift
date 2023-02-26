//
//  DogGenderEnum.swift
//  CoupleAnimal
//
//  Created by Nikita on 6.02.23.
//

import Foundation

enum DogGenderEnum {
    case male
    case female
    
    var name: String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
}
