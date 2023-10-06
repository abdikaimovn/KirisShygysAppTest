//
//  RegistrationViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 06.10.2023.
//

import UIKit

class RegistrationViewController: UIViewController {
    private var nameTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .line
        textField.layer.cornerRadius = 10
        textField.placeholder = "Name"
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private var emailTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .line
        textField.layer.cornerRadius = 10
        textField.placeholder = "Email"
        textField.clipsToBounds = true
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .line
        textField.layer.cornerRadius = 10
        textField.clipsToBounds = true
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private var signUpButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor.shared.Brown
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupView() {
        self.title = "Sign Up"
        view.backgroundColor = .white
        
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signUpButton)
        
        nameTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.height.equalTo(40)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(nameTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(55)
        }
        
    }

}
