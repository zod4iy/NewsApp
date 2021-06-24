//
//  SceneDelegate.swift
//  UptechTest
//
//  Created by Alex Kurylenko on 12.05.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        
        let listNavigationController = ListWireframe.createModuleWithNavigationController()
        
        window?.rootViewController = listNavigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataService.shared.saveContext()
    }
}

