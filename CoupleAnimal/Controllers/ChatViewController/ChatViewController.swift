//
//  ChatViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 16.02.23.
//

import UIKit
import JGProgressHUD


class ChatViewController: UIViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    private let spinner = JGProgressHUD(style: .dark)
    
    
    
    private var users = [[String:Any]]()
    private var results = [[String:String]]()

    private var hasFetched = false
    
    private let noConversationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "You don't have any conversations!"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUsers()
        title = "Messanger"
        view.addSubview(noConversationLabel)
        registerCell()
        chatTableView.dataSource = self
        chatTableView.delegate = self
        
        fetchConversations()
    }
    
    private func getAllUsers() {
        DatabaseManager.shared.getAllUsers { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let success):
                print("\(success)///////////////////////////////")
               // strongSelf.users = success
                strongSelf.chatTableView.reloadData()
            case .failure(let failure):
                print("\(failure)///////////////")
            }
        }
    }
    
    private func registerCell() {
        let nib = UINib(nibName: ChatTableViewCell.id, bundle: nil)
        chatTableView.register(nib, forCellReuseIdentifier: ChatTableViewCell.id)
    }

    private func fetchConversations() {
        chatTableView.isHidden = false
    }
  


}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return users.count
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.id, for: indexPath)
        guard let messageCell = cell as? ChatTableViewCell else { return cell }
       // messageCell.senderNameLabel.text = users["name"] as? String
        
        return messageCell
    }
    
    
}

extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ConversationViewController(with: "")
        vc.title = "Nikita"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
