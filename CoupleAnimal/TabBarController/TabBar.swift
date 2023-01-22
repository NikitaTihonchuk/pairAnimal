//
//  TabBar.swift
//  CoupleAnimal
//
//  Created by Nikita on 18.01.23.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }

    private func setupTabBar() {
        let dataSource: [TabBarItem] = [.main, .chat, .profile]
        self.viewControllers = dataSource.map {
            switch $0 {
            case .main:
                let mainController = MainViewController()
                    return self.wrappedInNavigationController(with: mainController, title: $0.title)
            case .profile:
                let profileController = ProfileViewController()
                    return self.wrappedInNavigationController(with: profileController, title: $0.title)
            case .chat:
                let chatController = ChatViewController()
                    return self.wrappedInNavigationController(with: chatController, title: $0.title)
            }
        }
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
            tabBar.tintColor = .red
            tabBar.backgroundColor = .white
        }
    }
    
    private func wrappedInNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
            return UINavigationController(rootViewController: with)
    }
    
}

private enum TabBarItem {
    case profile
    case chat
    case main
   
    
    var title: String {
        switch self {
        case .main:
            return "Главная"
        case .profile:
            return "Профиль"
        case .chat:
            return "Сообщения"
        }
    }
    
    var iconName: String {
        switch self {
        case .main:
            return "house"
        case .profile:
            return "person"
        case .chat:
            return "message"
        }
    }
}

