//
//  ProfileViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.11.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var userImage: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.image = UIImage(systemName: "person.crop.circle")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var userNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Username"
        label.textColor = .black
        label.font = UIFont(name: "Futura", size: 16)
        return label
    }()
    
    private var userName: UILabel = {
        var label = UILabel()
        label.text = "Nurdaulet"
        label.textColor = .black
        label.font = UIFont(name: "Futura-Bold", size: 22)
        return label
    }()
    
    private var editButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "pencil"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.backgroundColor = .clear
        return btn
    }()
    
    private var logOutView: UIView = {
        var view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(hex: "#eeeeef")
        view.layer.cornerRadius = 16
        return view
    }()
    
    private var logOutImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
        image.backgroundColor = UIColor(hex: "#ffe2e4")
        image.tintColor = UIColor(hex: "#fd3c4a")
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 15
        image.layer.cornerCurve = .continuous
        return image
    }()
    
    private var logOutLabel: UILabel = {
        var label = UILabel()
        label.text = "Logout"
        label.textColor = .black
        label.font = UIFont(name: "Futura", size: 20)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logOutView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logOut)))
        setupView()
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
        print("Tapped logout")
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(userImage)
        userImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            make.size.equalTo(60)
        }
        
        view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(userImage.snp.right).offset(20)
            make.top.equalTo(userImage.snp.top).offset(10)
        }
        
        view.addSubview(userName)
        userName.snp.makeConstraints { make in
            make.left.equalTo(userImage.snp.right).offset(20)
            make.top.equalTo(userImage.snp.bottom).offset(-10)
        }
        
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
        }
        
        view.addSubview(logOutView)
        logOutView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(userImage.snp.bottom).offset(30)
            make.height.equalTo(70)
        }
        
        logOutView.addSubview(logOutImage)
        logOutImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }
        
        logOutView.addSubview(logOutLabel)
        logOutLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(logOutImage.snp.centerY)
        }
    }
    
}
