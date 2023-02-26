//
//  MainCategoryEnum.swift
//  CoupleAnimal
//
//  Created by Nikita on 22.02.23.
//

import Foundation


enum MainCategoryEnum: CaseIterable {
    case dogs
    case cats
    
    var name: String {
        switch self {
        case .dogs:
            return "Dogs"
        case .cats:
            return "Cats"
        }
    }
    
    
}
