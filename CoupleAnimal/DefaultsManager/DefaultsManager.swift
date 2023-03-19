//
//   .swift
//  CoupleAnimal
//
//  Created by Nikita on 6.02.23.
//

import Foundation

class DefaultsManager {
    private static let defaults = UserDefaults.standard

    static var rememberMe: Bool {
        get {
            defaults.value(forKey: #function) as? Bool ?? false
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    static var userID: String? {
        get {
            defaults.value(forKey: #function) as? String
        }
        set {
            defaults.set(newValue, forKey: #function)

        }
    }
    
    static var safeEmail: String? {
        get {
            defaults.value(forKey: #function) as? String
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
    static var profileURL: String? {
        get {
            defaults.value(forKey: #function) as? String
        }
        set {
            defaults.set(newValue, forKey: #function)

        }
    }
    
    static var dogName: String? {
        get {
            defaults.value(forKey: #function) as? String
        }
        set {
            defaults.set(newValue, forKey: #function)
        }
    }
    
}

