//
//  SetupSceneDelegate.swift
//  CoupleAnimal
//
//  Created by Nikita on 14.02.23.
//

import Foundation
import UIKit

struct SetupSceneDelegate {
    static var sceneDelegate: SceneDelegate? {
        let scene = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        return scene
    }
}
