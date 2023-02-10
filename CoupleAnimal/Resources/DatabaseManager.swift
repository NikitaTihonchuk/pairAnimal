//
//  DatabaseManager.swift
//  CoupleAnimal
//
//  Created by Nikita on 7.02.23.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}

extension DatabaseManager {
    
    public func updateUser(user: UserModel) {
        database.child(user.safeEmail).updateChildValues([
            "nickname" : user.nickname,
            "breed" : user.species,
            "location" : user.location,
            "weight" : user.weight,
            "height" : user.height
        ])
    }
    /// read user data
    public func readUser(email: String, complition: @escaping(([String : Any]) -> Void)) {
            var safeEmail = email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
             guard (snapshot.value != nil) else { return }
            if let info = snapshot.value as? [String:Any] {
                complition(info)
            }
        }
    }
    /// search if user exist
    public func isUserExists(email: String, complition: @escaping ((Bool) -> Void)) {

        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")

        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                complition(false)
                return
            }
            complition(true)
        }
    }
    
    ///  Inserts new user to the database
    public func inserUser(user: UserModel) {
        database.child(user.safeEmail).setValue([
            "name" : user.name,
            "id" : user.id,
            "fullRegister" : user.isFillingTheData
        ])
        DefaultsManager.userID = user.id
        DefaultsManager.safeEmail = user.safeEmail
    }
    /// update user
    public func addAditionalInfo(user: UserModel, complition: () -> Void) {
        database.child(user.safeEmail).updateChildValues([
            "nickname" : user.nickname,
            "breed" : user.species,
            "location" : user.location,
            "weight" : user.weight,
            "height" : user.height,
            "info" : user.additionalInfo,
            "fullRegister" : user.isFillingTheData
        ])
        complition()
    }

}
