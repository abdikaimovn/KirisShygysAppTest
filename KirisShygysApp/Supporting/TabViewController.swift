//
//  TabViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 31.10.2023.
//

import UIKit

class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
    }
    
    private func setupVC() {
        UITabBar.appearance().barTintColor = .clear
        tabBar.tintColor = UIColor(hex: "#C7B08E")
        tabBar.backgroundColor = UIColor(hex: "#FCFCFC")
        viewControllers = [
            createVC(for: HomeViewController(), title: NSLocalizedString("", comment: ""), icon: UIImage(systemName: "house")!),
            createVC(for: HomeViewController(), title: NSLocalizedString("", comment: ""), icon: UIImage(systemName: "plus.rectangle")!),
            createVC(for: HomeViewController(), title: NSLocalizedString("", comment: ""), icon: UIImage(systemName: "person.crop.circle")!)
        ]
    }
    
    private func createVC(for rootViewController: UIViewController, title: String, icon: UIImage) -> UIViewController{
        let navViewController = UINavigationController(rootViewController: rootViewController)
        navViewController.tabBarItem.title = title
        navViewController.tabBarItem.image = icon
        let titleFont = UIFont.systemFont(ofSize: 16, weight: .bold)
        rootViewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: titleFont]
        return navViewController
    }
}
