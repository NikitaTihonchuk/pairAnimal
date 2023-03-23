//
//  GoToChatController.swift
//  CoupleAnimal
//
//  Created by Nikita on 23.03.23.
//

import Foundation
import UIKit

protocol GoToChatController: UIViewController {
    func goToChatVC(email: String)
    func updateTableView()
}
