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
        let dataSource: [TabBarItem] = [.main, .favourite, .chat, .search, .profile]
        self.viewControllers = dataSource.map {
            switch $0 {
            case .main:
                let mainController = MainViewController()
                    return self.wrappedInNavigationController(with: mainController, title: $0.title)
            case .search:
                let searchController = SearchViewController()
                    return self.wrappedInNavigationController(with: searchController, title: $0.title)
            case .profile:
                let profileController = ProfileViewController()
                    return self.wrappedInNavigationController(with: profileController, title: $0.title)
            case .favourite:
                let chatController = ChatViewController()
                    return self.wrappedInNavigationController(with: chatController, title: $0.title)
            case .chat:
                let searchController = SearchViewController()
                    return self.wrappedInNavigationController(with: searchController, title: $0.title)
            }
        }
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.title = dataSource[$0].title
            $1.tabBarItem.image = UIImage(systemName: dataSource[$0].iconName)
            tabBar.tintColor = .red
        }
    }
    
    private func wrappedInNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
            return UINavigationController(rootViewController: with)
    }
    
}

private enum TabBarItem {
    case profile
    case search
    case favourite
    case chat
    case main
   
    
    var title: String {
        switch self {
        case .main:
            return "Главная"
        case .search:
            return "Поиск"
        case .profile:
            return "Профиль"
        case .favourite:
            return "Избранное"
        case .chat:
            return "Сообщения"
        }
    }
    
    var iconName: String {
        switch self {
        case .main:
            return "house"
        case .search:
            return "magnifyingglass"
        case .profile:
            return "person"
        case .favourite:
            return "star"
        case .chat:
            return "message"
        }
    }
}

