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
        database.child("users").child(user.safeEmail).updateChildValues([
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
        database.child("users").child(safeEmail).observeSingleEvent(of: .value) { snapshot in
             guard (snapshot.value != nil) else { return }
            if let info = snapshot.value as? [String:Any] {
                complition(info)
            }
        }
    }
    
    ///read country
   
    public func readCountry(completion: @escaping(Result<[String:Any], Error>) -> Void) {

        database.child("country").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                completion(.failure(DatabaseError.failedToReturn))
                return
            }
            completion(.success(value))
        }
    }
    
    public func readCity(nameCountry: String, completion: @escaping(Result<[String:Any], Error>) -> Void) {
        database.child("country").child(nameCountry).observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                completion(.failure(DatabaseError.failedToReturn))
                return
            }
            completion(.success(value))
        }
    }
    /// search if user exist
    public func isUserExists(email: String, complition: @escaping ((Bool) -> Void)) {

        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")

        database.child("users").child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                complition(false)
                return
            }
            complition(true)
        }
    }
    
    ///  Inserts new user to the database
    public func inserUser(user: UserModel) {
        database.child("users").child(user.safeEmail).setValue([
            "name" : user.name,
            "id" : user.id,
            "fullRegister" : user.isFillingTheData
        ])
        //DefaultsManager.userID = user.id
        DefaultsManager.safeEmail = user.safeEmail
    }
    /// update user
    public func addAditionalInfo(user: UserModel, complition: @escaping(Bool) -> Void) {
        
        
        database.child("users").child(user.safeEmail).updateChildValues([
            "nickname" : user.nickname,
            "breed" : user.species,
            "animal" : user.animal,
            "location" : user.location,
            "weight" : user.weight,
            "height" : user.height,
            "info" : user.additionalInfo,
            "age" : user.age,
            "id" : user.id,
            "gender" : user.gender,
            "additionalInfo" : user.additionalInfo,
            "species" : user.species,
            "fullRegister" : user.isFillingTheData
        ], withCompletionBlock: { error, _ in
            guard  error == nil else {
                complition(false)
                return
            }
            DefaultsManager.safeEmail = user.safeEmail
            complition(true)
        })
    }
    
    public func getAllUsers(completion: @escaping(Result<[String:Any], Error>) -> Void) {
        database.child("users").observeSingleEvent(of: .value) { snapshot in
            guard let value = snapshot.value as? [String:Any] else {
                completion(.failure(DatabaseError.failedToReturn))
                return
            }
            completion(.success(value))
        }
    }
    
    public enum DatabaseError:Error {
        case failedToReturn
    }

}

//MARK: - Sending messages
extension DatabaseManager {
    //create new conversation
    public func createNewConversation(with otherUserEmail: String, firstMessage: Message, complition: @escaping(Bool) -> Void) {
        guard let safeEmail = DefaultsManager.safeEmail else { return }
        let ref = database.child("users").child("\(safeEmail)")
        ///try to find user
        ref.observeSingleEvent(of: .value) { snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                complition(false)
                print("Nothing user is not found")
                return
            }
            ///prepeare date to write in database
            let messageDate = firstMessage.sentDate
            let dateString = ConversationViewController.dateFormatter.string(from: messageDate)
            
            ///find a message type and text that we should write in database
            var message = ""
            switch firstMessage.kind {
                
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            ///messageID
            let conversationID = "conversation_\(firstMessage.messageId)"
            ///array that storage info about messsage
            let newConversationData: [String:Any] = [
                "id": conversationID,
                "other_user_email": otherUserEmail,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
             ///check conversation exist
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: {[weak self] error, _ in
                    guard error == nil else {
                        complition(false)
                        return
                    }
                    self?.finishCreatingConversations(conversationID: conversationID,
                                                     firstMessage: firstMessage,
                                                     completion: complition)
                })
            } else {
                userNode["conversations"] = [newConversationData]
                
                ref.setValue(userNode)  { [weak self] error, _ in
                    guard error == nil else {
                        complition(false)
                        return
                    }
                    self?.finishCreatingConversations(conversationID: conversationID,
                                                     firstMessage: firstMessage,
                                                     completion: complition)
                }
            }
            
            
        }
    }
    
    private func finishCreatingConversations(conversationID: String, firstMessage: Message, completion: @escaping(Bool) -> Void) {
        
        let messageDate = firstMessage.sentDate
        let dateString = ConversationViewController.dateFormatter.string(from: messageDate)
        
        var message = ""
        switch firstMessage.kind {
            
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        guard let currentUserEmail = DefaultsManager.safeEmail else {
            completion(false)
            return
        }
        
        let collectionMessage: [String: Any] = [
            "id" : firstMessage.messageId,
            "type" : firstMessage.kind.messageKindString,
            "content" : message,
            "date" : dateString,
            "sender_email" : currentUserEmail,
            "is_read" : false
        ]
        
        let value: [String: Any] = [ "messages": [collectionMessage] ]
        database.child("\(conversationID)").setValue(value) { error, _ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    ///return all conversation
    public func getsAllConversation(email: String, complition: @escaping (Result<String, Error>) -> Void) {
        
    }
    ///get message
    public func getAllMessagesForConversation(with id: String, complition: @escaping(Result<String, Error>) -> Void) {
        
    }
    ///send message
    public func sendMessage(to conversation: String, message: Message, complition: @escaping (Bool) -> Void) {
         
    }
}
