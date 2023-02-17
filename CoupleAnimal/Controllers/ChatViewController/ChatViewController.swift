//
//  ChatViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 16.02.23.
//

import UIKit

class ChatViewController: UIViewController, UISearchResultsUpdating {
    
    @IBOutlet weak var chatTableView: UITableView!
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Messanger"
        chatTableView.dataSource = self
        chatTableView.delegate = self
        registerCell()
        addBarButton()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
        
        print(text)
    }
    
    private func addBarButton() {
        var rightBarSettingsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let settingsImage = UIImage(systemName: "gear")
        rightBarSettingsButton.setImage(settingsImage, for: .normal)
        rightBarSettingsButton.tintColor = .red
        rightBarSettingsButton.layer.cornerRadius = 15
        rightBarSettingsButton.backgroundColor = UIColor.white
        // rightBarSettingsButton.addTarget(self, action: #selector, for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: rightBarSettingsButton)
        navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarCancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                let cancelImage = UIImage(systemName: "list.dash")
        leftBarCancelButton.setImage(cancelImage, for: .normal)
        leftBarCancelButton.tintColor = .red
        leftBarCancelButton.layer.cornerRadius = 15
        leftBarCancelButton.backgroundColor = UIColor.white
      //  leftBarCancelButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        let leftBarButton = UIBarButtonItem(customView: leftBarCancelButton)
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    private func registerCell() {
        let nib = UINib(nibName: ChatTableViewCell.id, bundle: nil)
        chatTableView.register(nib, forCellReuseIdentifier: ChatTableViewCell.id)
    }


}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.id, for: indexPath)
        guard let messageCell = cell as? ChatTableViewCell else { return cell }
        return messageCell
    }
    
    
}

extension ChatViewController: UITableViewDelegate {
    
}
