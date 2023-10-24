//
//  RegistrationViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 06.10.2023.
//

import UIKit
import SnapKit

protocol RegistrationViewControllerDelegate {
    func didRegister(with data: RegistrationModel)
}

protocol RegistrationPresenterDelegate {
    func didCheckAuthorization(answer: Bool)
}

class RegistrationViewController: UIViewController {
    var delegate: RegistrationViewControllerDelegate?
    
    private var imageLogo: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.layer.cornerCurve = .continuous
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
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
    
    private var hidePasswordFieldButton: UIButton = {
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
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.tintColor = .black
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var registrationPresenter = RegistrationPresenter(delegate: self)
        delegate = registrationPresenter
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
    }
    
    @objc func hideTextField(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        hidePasswordFieldButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    @objc func signUpPressed(_ sender: UIButton) {
        //Username check
        if !Validator.isValidUsername(for: nameTextField.text ?? "") {
            AlertManager.showInvalidUsernameAlert(on: self)
            return
        }
        //Email check
        if !Validator.isValidEmail(for: emailTextField.text ?? "") {
            AlertManager.showInvalidEmailAlert(on: self)
            return
        }
        //Password check
        if !Validator.isValidPassword(for: passwordTextField.text ?? "") {
            AlertManager.showInvalidPasswordAlert(on: self)
            return
        }
        
        self.delegate?.didRegister(with: RegistrationModel(name: nameTextField.text!,
                                                           email: emailTextField.text!,
                                                           password: passwordTextField.text!))
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(imageLogo)
        imageLogo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(20)
            make.size.equalTo(view.bounds.width * 0.25)
        }
        
        view.addSubview(nameTextField)
        nameTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(imageLogo.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(signUpButton)
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
        rightPaddingButton.addSubview(hidePasswordFieldButton)
        hidePasswordFieldButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
        passwordTextField.rightView = rightPaddingButton
        passwordTextField.rightViewMode = .always
        
        hidePasswordFieldButton.addTarget(self, action: #selector(hideTextField(_:)), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpPressed(_:)), for: .touchUpInside)
    }
    
}

// Presenter's methods {
extension RegistrationViewController: RegistrationPresenterDelegate {
    func didCheckAuthorization(answer: Bool) {
        if answer {
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        } else {
            AlertManager.showRegistrationErrorAlert(on: self)
        }
    }
}
