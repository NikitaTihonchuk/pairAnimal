//
//  DatabaseManager.swift
//  CoupleAnimal
//
//  Created by Nikita on 7.02.23.
//

import Foundation
import FirebaseDatabase

//MARK: Database Manager
final class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
}
//MARK: Read and update users
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
}

//MARK: Reading country
extension DatabaseManager {
    
    ///read country
    public func readCountry(completion: @escaping(Result<[String:Any], Error>) -> Void) {
        
        database.child("country").observeSingleEvent(of: .value) { [weak self] snapshot in
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
    
}
    public enum DatabaseError:Error {
        case failedToReturn
    }



//MARK: - Sending messages
extension DatabaseManager {
    ///create new conversation
    ///How it works:
    ///1. Find our user for our email
    ///2. Prepeare date,  find a message that's was sent and his kind, and from our parameter message take his id
    ///3. create arrays that's include info about message
    ///4. check if conversation exist, and append, if not - create new branch in firebase
    ///5. call function finishCreatingConversations
    
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, complition: @escaping(Bool) -> Void) {
        
        guard let safeEmail = DefaultsManager.safeEmail,
        let nickname = DefaultsManager.dogName else { return }
        
        let ref = database.child("users/\(safeEmail)")
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
                "name": name,
                "other_user_email": otherUserEmail,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            /// set that array to the recipient user
            let recipientNewConversationData: [String:Any] = [
                "id": conversationID,
                "name": nickname,
                "other_user_email": safeEmail,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            ///update recipient conversation
            
            self.database.child("users/\(otherUserEmail)/conversations").observeSingleEvent(of: .value) { [weak self] snapshot in
                if var conversations = snapshot.value as? [[String: Any]] {
                    //append
                    conversations.append(recipientNewConversationData)
                    self?.database.child("users/\(otherUserEmail)/conversations").setValue(conversations)

                } else {
                    //create
                    self?.database.child("users/\(otherUserEmail)/conversations").setValue([recipientNewConversationData])
                }
            }
            
             ///check conversation exist and update conversation
            if var conversations = userNode["conversations"] as? [[String: Any]] {
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: {[weak self] error, _ in
                    guard error == nil else {
                        complition(false)
                        return
                    }
                    self?.finishCreatingConversations(conversationID: conversationID,
                                                     name: name,
                                                     firstMessage: firstMessage,
                                                     completion: complition)
                })
            }
            else {
                userNode["conversations"] = [newConversationData]
                ref.setValue(userNode)  { [weak self] error, _ in
                    guard error == nil else {
                        complition(false)
                        return
                    }
                    self?.finishCreatingConversations(conversationID: conversationID,
                                                     name: name,
                                                     firstMessage: firstMessage,
                                                     completion: complition)
                }
            }
            
            
        }
    }
    
    
    ///dublicate message above users in database
    ///How it works:
    ///1.   Prepeare date,  find a message that's was sent and his kind, and from our parameter message take his id, take own email
    ///2.   make an array with the data of message
    ///3.   append this array to firebase branch at the top
    private func finishCreatingConversations(conversationID: String, name: String, firstMessage: Message, completion: @escaping(Bool) -> Void) {
        
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
        
        guard let ownEmail = DefaultsManager.safeEmail else {
            completion(false)
            return
        }
        
        let collectionMessage: [String: Any] = [
            "id" : firstMessage.messageId,
            "type" : firstMessage.kind.messageKindString,
            "content" : message,
            "date" : dateString,
            "sender_email" : ownEmail,
            "is_read" : false,
            "name" : name
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
    
    
    ///gets all conversation
    ///how it works
    ///1. try to find all conversations in database
    ///2. try to parse this dictionary with a compact map
    ///3. create new object of message and set data
    ///4. create new object of conversation and set data and message object
    ///5. return converation object
    public func getsAllConversation(email: String, complition: @escaping (Result<[Conversation], Error>) -> Void) {
        
        database.child("users/\(email)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                complition(.failure(DatabaseError.failedToReturn))
                return
            }
            ///compact map needed to convert our dictionary to our model
            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationID = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool else {
                            return nil
                }
                ///creates objects
                let latestMessageObject = LatestMessage(date: date,
                                                        text: message,
                                                        isRead: isRead)
                
                return Conversation(id: conversationID,
                                    name: name,
                                    otherUserEmail: otherUserEmail,
                                    latestMessage: latestMessageObject)
            })
            complition(.success(conversations))
        })
    }
    ///get message
    ///how ot works
    ///1. try to find messages data in firebase
    ///2. try to parse this dictionary with a compact map
    ///3. create new object of sender and set data
    ///4. create new object of message and set data and sender object
    public func getAllMessagesForConversation(with id: String, complition: @escaping(Result<[Message], Error>) -> Void) {
        database.child("\(id)/messages").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                complition(.failure(DatabaseError.failedToReturn))
                return
            }
            //print(value.count)
            
            let messages: [Message] = value.compactMap({ dictionary in
                guard let name = dictionary["name"] as? String,
                      let isRead = dictionary["is_read"] as? Bool,
                      let messageId = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                      let senderEmail = dictionary["sender_email"] as? String,
                      let type = dictionary["type"] as? String,
                      let dateString = dictionary["date"] as? String else { return nil }
                
                var date = dateString.replacingOccurrences(of: ".", with: "-")
                date = date.replacingOccurrences(of: ",", with: "-")
                date = date.replacingOccurrences(of: "/", with: "_")
            
                guard let date = ConversationViewController.dateFormatter.date(from: dateString) else {
                    return nil }
                
                print(date)
                print(dateString)
                
                let sender = Sender(photoURL: "",
                                    senderId: senderEmail,
                                    displayName: name)
                
                return Message(sender: sender,
                               messageId: messageId,
                               sentDate: date,
                               kind: .text(content))
            })
            complition(.success(messages))
        })
    }
    
    
    
    ///send message
    /// Sends a message with target conversation and message
    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping (Bool) -> Void) {
        // add new message to messages
        // update sender latest message
        // update recipient latest message

        guard let ownEmail = DefaultsManager.safeEmail else { return }

        database.child("\(conversation)/messages").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else {
                return
            }

            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }

            let messageDate = newMessage.sentDate
            let dateString = ConversationViewController.dateFormatter.string(from: messageDate)

            var message = ""
            switch newMessage.kind {
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(let mediaItem):
                break
            case .video(let mediaItem):
                break
            case .location(let locationData):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .custom(_), .linkPreview(_):
                break
            }

            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": message,
                "date": dateString,
                "sender_email": ownEmail,
                "is_read": false,
                "name": name
            ]

            currentMessages.append(newMessageEntry)

            strongSelf.database.child("\(conversation)/messages").setValue(currentMessages) { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }

                strongSelf.database.child("users/\(ownEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                    var databaseEntryConversations = [[String: Any]]()
                    let updatedValue: [String: Any] = [
                        "date": dateString,
                        "is_read": false,
                        "message": message
                    ]

                    if var currentUserConversations = snapshot.value as? [[String: Any]] {
                        var targetConversation: [String: Any]?
                        var position = 0

                        for conversationDictionary in currentUserConversations {
                            if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                                targetConversation = conversationDictionary
                                break
                            }
                            position += 1
                        }

                        if var targetConversation = targetConversation {
                            targetConversation["latest_message"] = updatedValue
                            currentUserConversations[position] = targetConversation
                            databaseEntryConversations = currentUserConversations
                        }
                        else {
                            let newConversationData: [String: Any] = [
                                "id": conversation,
                                "other_user_email": otherUserEmail,
                                "name": name,
                                "latest_message": updatedValue
                            ]
                            currentUserConversations.append(newConversationData)
                            databaseEntryConversations = currentUserConversations
                        }
                    }
                    else {
                        let newConversationData: [String: Any] = [
                            "id": conversation,
                            "other_user_email": otherUserEmail,
                            "name": name,
                            "latest_message": updatedValue
                        ]
                        databaseEntryConversations = [
                            newConversationData
                        ]
                    }

                    strongSelf.database.child("users/\(ownEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }


                        // Update latest message for recipient user

                        strongSelf.database.child("users/\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                            let updatedValue: [String: Any] = [
                                "date": dateString,
                                "is_read": false,
                                "message": message
                            ]
                            var databaseEntryConversations = [[String: Any]]()

                            guard let currentName = DefaultsManager.dogName else {
                                return
                            }

                            if var otherUserConversations = snapshot.value as? [[String: Any]] {
                                var targetConversation: [String: Any]?
                                var position = 0

                                for conversationDictionary in otherUserConversations {
                                    if let currentId = conversationDictionary["id"] as? String, currentId == conversation {
                                        targetConversation = conversationDictionary
                                        break
                                    }
                                    position += 1
                                }

                                if var targetConversation = targetConversation {
                                    targetConversation["latest_message"] = updatedValue
                                    otherUserConversations[position] = targetConversation
                                    databaseEntryConversations = otherUserConversations
                                }
                                else {
                                    // failed to find in current colleciton
                                    let newConversationData: [String: Any] = [
                                        "id": conversation,
                                        "other_user_email": ownEmail,
                                        "name": currentName,
                                        "latest_message": updatedValue
                                    ]
                                    otherUserConversations.append(newConversationData)
                                    databaseEntryConversations = otherUserConversations
                                }
                            }
                            else {
                                // current collection does not exist
                                let newConversationData: [String: Any] = [
                                    "id": conversation,
                                    "other_user_email": ownEmail,
                                    "name": currentName,
                                    "latest_message": updatedValue
                                ]
                                databaseEntryConversations = [
                                    newConversationData
                                ]
                            }

                            strongSelf.database.child("users/\(otherUserEmail)/conversations").setValue(databaseEntryConversations, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(false)
                                    return
                                }

                                completion(true)
                            })
                        })
                    })
                })
            }
        })
    }
    
    public func conversationExists(iwth targetRecipientEmail: String, completion: @escaping (Result<String, Error>) -> Void) {
        let safeRecipientEmail = targetRecipientEmail
        guard let senderEmail = DefaultsManager.safeEmail else { return }

        database.child("users/\(safeRecipientEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToReturn))
                return
            }

            // iterate and find conversation with target sender
            if let conversation = collection.first(where: {
                guard let targetSenderEmail = $0["other_user_email"] as? String else {
                    return false
                }
                return senderEmail == targetSenderEmail
            }) {
                // get id
                guard let id = conversation["id"] as? String else {
                    completion(.failure(DatabaseError.failedToReturn))
                    return
                }
                completion(.success(id))
                return
            }

            completion(.failure(DatabaseError.failedToReturn))
            return
        })
    }

}



