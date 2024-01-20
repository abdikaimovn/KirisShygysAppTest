//
//  TabViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 31.10.2023.
//

import UIKit
import SnapKit

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
            createVC(for: createHomeModule(),
                     icon: UIImage(systemName: "house")!),
            createVC(for: createProfileModule(),
                     icon: UIImage(systemName: "square.stack.3d.up")!)
        ]
        
        let buttonSize: CGFloat = 60
        let image = UIImage(systemName: "plus.circle.fill")?.withTintColor(UIColor.shared.Brown, renderingMode: .alwaysOriginal)
        let resizedImage = image?.resized(to: CGSize(width: buttonSize, height: buttonSize))
        
        let plusButton = ExtendedTapAreaButton(type: .custom)
        plusButton.setImage(resizedImage, for: .normal)
        plusButton.backgroundColor = .clear
        
        plusButton.addTarget(self, action: #selector(addTransactionPressed), for: .touchUpInside)
        tabBar.addSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(tabBar.snp.top).inset(5)
        }
    }
    
    @objc private func addTransactionPressed() {
        let transactionPresenter = TransactionPresenter(service: UserDataManager.shared)
        let transactionViewController = TransactionViewController(presenter: transactionPresenter)
        transactionPresenter.view = transactionViewController
        self.present(transactionViewController, animated: true)
    }
    
    private func createVC(for rootViewController: UIViewController, icon: UIImage) -> UIViewController{
        let navViewController = rootViewController
        navViewController.tabBarItem.image = icon
        return navViewController
    }
    
    private func createHomeModule() -> UIViewController {
        let presenter = HomePresenter(userManager: UserDataManager.shared)
        let view = HomeViewController(presenter: presenter)
        presenter.view = view
        
        return view
    }
    
    private func createProfileModule() -> UIViewController {
        let presenter = ServicesPresenter(profileAuthService: AuthService.shared, userManager: UserDataManager.shared)
        let view = ServicesViewController(presenter: presenter)
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
