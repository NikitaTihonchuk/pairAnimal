//
//  SceneDelegate.swift
//  CoupleAnimal
//
//  Created by Nikita on 18.01.23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        window?.windowScene = windowScene
        
        setWelcomeAsInitial()
            self.window?.makeKeyAndVisible()
             
    }

    func setTabbarAsInitial() {
        window?.rootViewController = TabBarController()
        
    }
    
    func setWelcomeAsInitial() {
        window?.rootViewController = WelcomePageViewController(nibName: WelcomePageViewController.id, bundle: nil)
    }
    
    func setAsInitial(vc: UIViewController) {
        window?.rootViewController = vc
    }

}

