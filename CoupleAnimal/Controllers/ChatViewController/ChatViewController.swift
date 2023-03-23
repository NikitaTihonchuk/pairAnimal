//
//  ChatViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 16.02.23.
//

import UIKit
import JGProgressHUD
//MARK: Conversations and LastMessage Struct

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}

//MARK: ChatViewController
class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    
    
    private let spinner = JGProgressHUD(style: .dark)
    private var conversations = [Conversation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Messanger"
        registerCell()
        chatTableView.dataSource = self
        chatTableView.delegate = self
        startListeningForConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    ///fetch conversations and assign to our conversation property
    private func startListeningForConversations() {
        guard let email = DefaultsManager.safeEmail else { return }
        
        DatabaseManager.shared.getsAllConversation(email: email) { [weak self] result in
            switch result {
                case .success(let conversations):
                guard !conversations.isEmpty else { return }
                self?.conversations = conversations
                
                DispatchQueue.main.async {
                    self?.chatTableView.reloadData()
                }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    private func registerCell() {
        let nib = UINib(nibName: ChatTableViewCell.id, bundle: nil)
        chatTableView.register(nib, forCellReuseIdentifier: ChatTableViewCell.id)
    }
  
}

//MARK: ChatController extension
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.id, for: indexPath)
        guard let messageCell = cell as? ChatTableViewCell else { return cell }
        messageCell.set(conversation: conversations[indexPath.row])
        return messageCell
    }
    
    
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ConversationViewController(with: conversations[indexPath.row].otherUserEmail, id: conversations[indexPath.row].id)
        vc.title = conversations[indexPath.row].name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let conversationId = conversations[indexPath.row].id
            tableView.beginUpdates()
            self.conversations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            DatabaseManager.shared.deleteConversation(conversationId: conversationId, completion: { success in
                if !success {
                    //if error return conversation
                }
            })
            tableView.endUpdates()

        }
    }
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }*/
    
}
