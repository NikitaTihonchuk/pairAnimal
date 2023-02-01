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
        self.navigationItem.setHidesBackButton(true, animated: true)
        setupTabBar()
        setupTabBarAppearance()
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
            //tabBar.tintColor = .red
            //tabBar.backgroundColor = .white
        }
    }
    
    private func wrappedInNavigationController(with: UIViewController, title: Any?) -> UINavigationController {
            return UINavigationController(rootViewController: with)
    }
    
    private func setupTabBarAppearance() {
        //для рисование кривых безье
        let positionOnX: CGFloat = 10
        let positionOnY: CGFloat = 14
        let width = tabBar.bounds.width - positionOnX * 2
        let height = tabBar.bounds.height + positionOnY * 2
        
        let roundLayer = CAShapeLayer()
        
        let bezierPath = UIBezierPath(roundedRect: CGRect(x: positionOnX,
                                                          y: tabBar.bounds.minY - positionOnY,
                                                          width: width,
                                                          height: height),
                                                          cornerRadius: height / 2)
        
        roundLayer.path = bezierPath.cgPath
        tabBar.layer.insertSublayer(roundLayer, at: 0)
        tabBar.itemWidth = width / 5
        tabBar.itemPositioning = .centered
        roundLayer.fillColor = UIColor.white.cgColor
        tabBar.tintColor = .red
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

