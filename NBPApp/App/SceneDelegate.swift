//
//  SceneDelegate.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let vc = HomeViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.backgroundColor = .white
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
    }
}

