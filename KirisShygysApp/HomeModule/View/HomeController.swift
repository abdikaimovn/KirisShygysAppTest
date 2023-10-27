//
//  ViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.10.2023.
//

import UIKit
import SnapKit

class HomeController: UIViewController {
    private var welcomeLabel: UILabel = {
        var label = UILabel()
        label.text = "Welcome Back,"
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private var userNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Nurdaulet"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private var card: UIView = {
        var card = UIView()
        card.backgroundColor = UIColor.shared.Brown
        card.layer.cornerRadius = 10
        card.clipsToBounds = true
        return card
    }()
    
    private var total: UILabel = {
        var label = UILabel()
        label.text = "Total Balance:"
        label.font = .systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .white
        return label
    }()
    
    private var totalBalance: UILabel = {
        var label = UILabel()
        label.text = "$15000"
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello world")
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(hex: "#FCEED4")
        
        view.addSubview(welcomeLabel)
        welcomeLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(25)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
        
        view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom).offset(10)
            make.left.equalTo(welcomeLabel.snp.left)
        }
        
        
        
        let logOutBtn = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(logOut))
        logOutBtn.title = "Log Out"
        self.navigationItem.rightBarButtonItem = logOutBtn
    }
    
    @objc private func logOut() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else {return}
            
            if let error = error {
                AlertManager.showLogOutErrorAlert(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        }
    }
}

