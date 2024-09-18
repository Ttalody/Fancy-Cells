//
//  SceneDelegate.swift
//  Fancy Cells
//
//  Created by Artur Akulich on 18.09.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        self.window = UIWindow(windowScene: windowScene)
        let rootVC = MainViewController()
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
    }
}
