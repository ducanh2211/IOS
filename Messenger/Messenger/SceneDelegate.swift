//
//  SceneDelegate.swift
//  Messenger
//
//  Created by Đức Anh Trần on 13/01/2023.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        if Auth.auth().currentUser == nil {
            window.rootViewController = UINavigationController(rootViewController: LoginViewController())
        } else {
            window.rootViewController = MainTabBarViewController()
        }
        
//        window.rootViewController = MainTabBarViewController()
        
        window.makeKeyAndVisible()
        self.window = window
    }

    /// Change the root view controller to your specific view controller
    func changeRootViewController(_ viewController: UIViewController, options: UIView.AnimationOptions, animated: Bool) {
        guard let window = window else { return }
        window.rootViewController = viewController
        // Add animation
        UIView.transition(with: window, duration: 0.5, options: options, animations: nil, completion: nil)
    }
}
