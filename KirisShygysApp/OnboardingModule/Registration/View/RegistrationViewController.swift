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
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1.0
        textField.layer.masksToBounds = true
        textField.placeholder = "Name"
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private var emailTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .line
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1.0
        textField.layer.masksToBounds = true
        textField.placeholder = "Email"
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .line
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1.0
        textField.layer.masksToBounds = true
        textField.placeholder = "Password"
        textField.font = UIFont.systemFont(ofSize: 16)
        return textField
    }()
    
    private var hidePasswordField: UIButton = {
        var button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .black
        button.setImage(UIImage(systemName:"eye.slash"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        return button
    }()
    
    private var signUpButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor.shared.Brown
        button.setTitle("Sign Up", for: .normal)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.tintColor = .black
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidePasswordField.addTarget(self, action: #selector(hideTextField(_:)), for: .touchUpInside)
        
        setupView()
    }
    
    @objc func hideTextField(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        hidePasswordField.setImage(UIImage(systemName: imageName), for: .normal)
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
            make.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(55)
        }
        
        let leftPaddingViewName = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        nameTextField.leftView = leftPaddingViewName
        nameTextField.leftViewMode = .always
        
        let leftPaddingViewEmail = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        emailTextField.leftView = leftPaddingViewEmail
        emailTextField.leftViewMode = .always
        
        let leftPaddingViewPassword = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        passwordTextField.leftView = leftPaddingViewPassword
        passwordTextField.leftViewMode = .always
        
        let rightPaddingButton = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        rightPaddingButton.addSubview(hidePasswordField)
        hidePasswordField.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
        passwordTextField.rightView = rightPaddingButton
        passwordTextField.rightViewMode = .always
    }
    
}
