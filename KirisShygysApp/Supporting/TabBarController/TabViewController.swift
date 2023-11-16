//
//  TabViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 31.10.2023.
//

import UIKit

final class TabViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVC()
    }
    
    private func setupVC() {
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        UITabBar.appearance().barTintColor = .clear
        tabBar.tintColor = UIColor(hex: "#C7B08E")
        tabBar.backgroundColor = UIColor(hex: "#FCFCFC")
        
        viewControllers = [
            createVC(for: HomeViewController(), title: NSLocalizedString("", comment: ""), icon: UIImage(systemName: "house")!),
            createVC(for: ProfileViewController(), title: NSLocalizedString("", comment: ""), icon: UIImage(systemName: "person.crop.circle")!)
        ]
        
        let buttonSize: CGFloat = 60
        let image = UIImage(systemName: "plus.circle.fill")?.withTintColor(UIColor.shared.Brown, renderingMode: .alwaysOriginal)
        let resizedImage = image?.resized(to: CGSize(width: buttonSize, height: buttonSize))
        
        let secondImage = UIImage(systemName: "xmark.circle.fill")?.withTintColor(UIColor.shared.Brown, renderingMode: .alwaysOriginal)
        let secondResizedImage = secondImage?.resized(to: CGSize(width: buttonSize, height: buttonSize))
        
        let plusButton = UIButton(type: .custom)
        plusButton.setImage(resizedImage, for: .normal)
        plusButton.setImage(secondResizedImage, for: .selected)
        plusButton.backgroundColor = .clear
        let tabBarHeight = tabBar.frame.height
        let tabBarWidth = tabBar.frame.width
        
        plusButton.frame = CGRect(x: (tabBarWidth - buttonSize) / 2, y: tabBarHeight - buttonSize - 60, width: buttonSize, height: buttonSize)
        plusButton.addTarget(self, action: #selector(addTransactionPressed), for: .touchUpInside)
        tabBar.addSubview(plusButton)
    }
    
    @objc private func addTransactionPressed() {
        let transactionViewController = TransactionViewController()
        self.present(transactionViewController, animated: true)
    }
    
    private func createVC(for rootViewController: UIViewController, title: String, icon: UIImage) -> UIViewController{
        let navViewController = rootViewController
        navViewController.tabBarItem.title = title
        navViewController.tabBarItem.image = icon
        let titleFont = UIFont.systemFont(ofSize: 20, weight: .bold)
        rootViewController.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: titleFont]
        return navViewController
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
