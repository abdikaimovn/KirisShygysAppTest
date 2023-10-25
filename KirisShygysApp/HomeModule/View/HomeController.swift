//
//  ViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.10.2023.
//

import UIKit
import SnapKit

class HomeController: UIViewController {
    private var label: UILabel = {
        var label = UILabel()
        label.text = "Hello world"
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .black
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
//        let logOutBtn = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(logOut))
//        logOutBtn.title = "Log Out"
//        self.navigationItem.rightBarButtonItem = logOutBtn
    }

//    @objc private func logOut() {
//        Network.shared.signOut { [weak self] error in
//            guard let self = self else {return}
//
//            if let error = error {
//                AlertManager.showLogOutErrorAlert(on: self, with: error)
//                return
//            }
//
//            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
//                sceneDelegate.checkAuthentication()
//            }
//        }
//    }
}

