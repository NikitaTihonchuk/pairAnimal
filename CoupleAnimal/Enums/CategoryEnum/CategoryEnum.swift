//
//  CategoryEnum.swift
//  CoupleAnimal
//
//  Created by Nikita on 2.03.23.
//

import Foundation
import UIKit

enum CategoryEnum: CaseIterable {
    case dogs
    case cats
    
    var animalType: Int {
        switch self {
        case .dogs:
            return 0
        case .cats:
            return 1
        }
    }
    
}
