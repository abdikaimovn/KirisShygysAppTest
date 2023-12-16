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
        tabBar.tintColor = UIColor.shared.Brown
        tabBar.backgroundColor = UIColor.shared.LightGray
        
        viewControllers = [
            createVC(for: createHomeModule(), title: NSLocalizedString("", comment: ""), icon: UIImage(systemName: "house")!),
            createVC(for: createProfileModule(), title: NSLocalizedString("", comment: ""), icon: UIImage(systemName: "person.crop.circle")!)
        ]
        
        let buttonSize: CGFloat = 60
        let image = UIImage(systemName: "plus.circle.fill")?.withTintColor(UIColor.shared.Brown, renderingMode: .alwaysOriginal)
        let resizedImage = image?.resized(to: CGSize(width: buttonSize, height: buttonSize))
        
        let plusButton = UIButton(type: .custom)
        plusButton.setImage(resizedImage, for: .normal)
        plusButton.backgroundColor = .clear
        let tabBarHeight = tabBar.bounds.height
        let tabBarWidth = tabBar.bounds.width
        
        plusButton.frame = CGRect(x: (tabBarWidth - buttonSize) / 2, y: tabBarHeight - buttonSize - 60, width: buttonSize, height: buttonSize)
        plusButton.addTarget(self, action: #selector(addTransactionPressed), for: .touchUpInside)
        tabBar.addSubview(plusButton)
    }
    
    @objc private func addTransactionPressed() {
        let transactionPresenter = TransactionPresenter()
        let transactionViewController = TransactionViewController(presenter: transactionPresenter)
        transactionPresenter.view = transactionViewController
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
    
    private func createHomeModule() -> UIViewController {
        let presenter = HomePresenter(userManager: UserDataManager.shared)
        let view = HomeViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
    
    private func createProfileModule() -> UIViewController {
        let presenter = ProfilePresenter(service: AuthService.shared, userManager: UserDataManager.shared)
        let view = ProfileViewController(profilePresenter: presenter)
        presenter.view = view
        
        return view
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
