//
//  SceneDelegate.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.10.2023.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        self.setupWindow(with: scene)
        self.checkAuthentication()
    }
    
    private func setupWindow(with scene: UIScene) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.overrideUserInterfaceStyle = .light
        self.window?.makeKeyAndVisible()
    }
    
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            let onboardingVC = OnboardingViewController()
            let navController = UINavigationController(rootViewController: onboardingVC)
            navController.modalPresentationStyle = .fullScreen
            self.goToController(with: navController)
        } else {
            let tabVC = TabViewController()
            let navController = UINavigationController(rootViewController: tabVC)
            navController.modalPresentationStyle = .fullScreen
            self.goToController(with: navController)
        }
    }

    
    private func goToController(with viewController: UIViewController) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.25) {
                self.window?.layer.opacity = 0
            } completion: { [weak self] _ in
                let nav = viewController
                nav.modalPresentationStyle = .fullScreen
                self?.window?.rootViewController = nav
                
                UIView.animate(withDuration: 0.25) { [weak self] in
                    self?.window?.layer.opacity = 1
                }
            }
        }
    }

}

