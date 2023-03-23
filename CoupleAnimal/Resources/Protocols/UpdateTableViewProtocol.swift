//
//  UpdateTableViewProtocol.swift
//  CoupleAnimal
//
//  Created by Nikita on 23.03.23.
//

import Foundation
import UIKit

protocol UpdateTableView: UIViewController {
    func update(selectedIndex: Int)
    func goToProfile(user: UserModel)
    func changeCity()
    func notificationVC()
    func searchResult(text: String)
}
