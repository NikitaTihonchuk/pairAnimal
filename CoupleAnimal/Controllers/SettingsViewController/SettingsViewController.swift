//
//  SettingsViewController.swift
//  CoupleAnimal
//
//  Created by Nikita on 14.02.23.
//

import UIKit

class SettingsViewController: UIViewController {
    static let id = String(describing: SettingsViewController.self)
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
    }
    
    private func registerCell() {
        let nib = UINib(nibName: SettingsTableViewCell.id, bundle: nil)
        settingsTableView.register(nib, forCellReuseIdentifier: SettingsTableViewCell.id)
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            DefaultsManager.rememberMe = false
            SetupSceneDelegate.sceneDelegate?.setWelcomeAsInitial()
        
    }
}

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.id, for: indexPath)
        guard let logoutCell = cell as? SettingsTableViewCell else { return cell }
        return logoutCell
    }
    
    
}


