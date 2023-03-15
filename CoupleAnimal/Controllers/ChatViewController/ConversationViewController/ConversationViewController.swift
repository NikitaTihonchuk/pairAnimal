//
//  ConversationViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 17.02.23.
//

import UIKit
import MessageKit
import InputBarAccessoryView


//MARK: Struct Message and Sender

///messageModel
struct Message: MessageType {
    public var sender: MessageKit.SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKit.MessageKind
}
///sender message model
struct Sender: SenderType {
    public var photoURL: String
    public var senderId: String
    public var displayName: String
}

//MARK: MessageKind extension

extension MessageKind {
    var messageKindString: String {
        switch self {
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_preview"
        case .custom(_):
            return "custom"
        }
    }
}

//MARK: ConversationController
class ConversationViewController: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.timeZone = .current
        return formatter
    }()
    
    public var isNewConversation = true
    public let otherUserEmail: String
    private var messages = [Message]()
    
    ///sender object that storage ownEmail
    private var selfSender: Sender? {
        guard let email = DefaultsManager.safeEmail else { return nil }
        return Sender(photoURL: "",
               senderId: email,
               displayName: "Nikita")
    }

    init(with email: String) {
        self.otherUserEmail = email
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        view.backgroundColor = .white
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
    }

}
//MARK: ConversationController extensions
extension ConversationViewController: InputBarAccessoryViewDelegate {
    ///function for chat, that can recieve when the button did press
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
        let selfSender = self.selfSender,
        let messageID = createMessageID() else { return }
        print(text)
        let message = Message(sender: selfSender,
                              messageId: messageID,
                              sentDate: Date(),
                              kind: .text(text))
        if isNewConversation {
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, firstMessage: message) { success in
                if success {
                    print("success")
                } else {
                    print("sorry")
                }
            }
        } else {
            
        }
    }
    
    private func createMessageID() -> String? {
        let dateString = Self.dateFormatter.string(from: Date())
        guard let ownEmail = DefaultsManager.safeEmail else { return nil }
        let date = dateString.replacingOccurrences(of: ".", with: "-")
        let newID = "\(otherUserEmail)_\(ownEmail)_\(date)"
        print(newID)
        return newID
    }
}

extension ConversationViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> MessageKit.SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("email should be cached")
        //return Sender(photoURL: "", senderId: "123", displayName: "")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
