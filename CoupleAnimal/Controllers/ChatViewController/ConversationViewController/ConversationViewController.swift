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
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
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
final class ConversationViewController: MessagesViewController {
    
    private var senderPhotoURL: URL?
    private var otherUserPhotoURL: URL?
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        //formatter.timeStyle = .medium
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()
    
    private var conversationID: String?
    private var messages = [Message]()
    
    public let otherUserEmail: String
    public var isNewConversation = false
    
    ///sender object that storage ownEmail
    private var selfSender: Sender? {
        guard let email = DefaultsManager.safeEmail else { return nil }
        return Sender(photoURL: "",
               senderId: email,
               displayName: "Me")
    }

    init(with email: String, id: String?) {
        self.conversationID = id
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
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           messageInputBar.inputTextView.becomeFirstResponder()
           if let conversationID = conversationID {
               listenForMessages(id: conversationID, shouldScrollToBottom: true)
           }
       }
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        DatabaseManager.shared.getAllMessagesForConversation(with: id) { [weak self] result in
            switch result {
                
            case .success(let messages):
                guard !messages.isEmpty else { return }
                print(messages)
                self?.messages = messages
                
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadDataAndKeepOffset()
                     
                    if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToLastItem()
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
//MARK: ConversationController extensions
extension ConversationViewController: InputBarAccessoryViewDelegate {
    ///function for chat, that can recieve when the button send did pressed
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
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: message) { [weak self] success in
                guard let strongSelf = self else { return }
                if success {
                    print("message sent")
                    strongSelf.isNewConversation = false
                    let newConversationID = "conversation_\(message.messageId)"
                    strongSelf.conversationID = newConversationID
                    strongSelf.listenForMessages(id: newConversationID, shouldScrollToBottom: true)
                    strongSelf.messageInputBar.inputTextView.text = nil
                } else {
                    print("sorry")
                }
            }
        } else {
            guard let conversationId = conversationID, let name = self.title else {
                return
            }

            // append to existing conversation data
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: message, completion: { [weak self] success in
                guard let strongSelf = self else { return }
                if success {
                    strongSelf.messageInputBar.inputTextView.text = nil
                    print("message sent")
                }
                else {
                    print("failed to send")
                }
            })
        }
    }
    ///create new messageID
    private func createMessageID() -> String? {
        let dateString = Self.dateFormatter.string(from: Date())
        guard let ownEmail = DefaultsManager.safeEmail else { return nil }
        print(dateString)
        var date = dateString.replacingOccurrences(of: ".", with: "-")
        date = date.replacingOccurrences(of: ",", with: "-")
        date = date.replacingOccurrences(of: "/", with: "_")


        let newID = "\(otherUserEmail)_\(ownEmail)_\(date)"
        print(newID)
        return newID
    }
}

extension ConversationViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> SenderType {
        if let sender = selfSender {
            return sender
        }
        fatalError("email should be cached")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let sender = message.sender
        
        if sender.senderId == selfSender?.senderId {
            if let currentUserImageURL = self.senderPhotoURL {
                avatarView.sd_setImage(with: currentUserImageURL, completed: nil)
            } else {
                guard let safeEmail = DefaultsManager.safeEmail else { return }
                let path = "images/\(safeEmail)_profile_picture.png"
                StorageManager.shared.downloadURL(path: path) { [weak self] result in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .success(let url):
                        strongSelf.senderPhotoURL = url
                        DispatchQueue.main.async {
                            avatarView.sd_setImage(with: url, completed: nil)
                        }
                    case .failure(let failure):
                        print(failure)
                    }
                }
            }
        } else {
            
            if let otherUserPhotoURL = self.otherUserPhotoURL {
                avatarView.sd_setImage(with: otherUserPhotoURL, completed: nil)
            } else {
                let safeEmail = self.otherUserEmail
                let path = "images/\(safeEmail)_profile_picture.png"
                
                StorageManager.shared.downloadURL(path: path) { [weak self] result in
                    guard let strongSelf = self else { return }
                    switch result {
                    case .success(let url):
                        strongSelf.otherUserPhotoURL = url
                        DispatchQueue.main.async {
                            avatarView.sd_setImage(with: url, completed: nil)
                        }
                    case .failure(let failure):
                        print(failure)
                    }
                }

            }
        }
    }
    
    
}
