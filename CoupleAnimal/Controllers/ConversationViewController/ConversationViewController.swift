//
//  ConversationViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 17.02.23.
//

import UIKit
import MessageKit

struct Message: MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}

struct Sender: SenderType {
    var photoURL: String
    var senderId: String
    var displayName: String
}

class ConversationViewController: MessagesViewController {
    
    private var messages = [Message]()
    
    private let selfSender = Sender(photoURL: "",
                                    senderId: "1",
                                    displayName: "Polina")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Hi, Nikita, I'm sleeping all day and raise just now!)")))
        
        messages.append(Message(sender: selfSender,
                                messageId: "1",
                                sentDate: Date(),
                                kind: .text("Wow, Polina! You are crazy!))))")))
        
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }

}

extension ConversationViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> MessageKit.SenderType {
        return selfSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        return messages.count
    }
    
    
}
