//
//  RegistrationViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 06.10.2023.
//

import UIKit
import SnapKit

final class RegistrationViewController: UIViewController {
    private let presenter: RegistrationPresenter
    private let loader = UIActivityIndicatorView()
    private let loaderView = UIView()
    
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
        textField.textColor = .black
        textField.font = UIFont.defaultFont(16)
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
        textField.textColor = .black
        textField.font = UIFont.defaultFont(16)
        return textField
    }()
    
    private var passwordTextField: UITextField = {
        var textField = UITextField()
        textField.backgroundColor = .white
        textField.borderStyle = .line
        textField.layer.cornerRadius = 12
        textField.layer.borderWidth = 1.0
        textField.layer.masksToBounds = true
        textField.isSecureTextEntry = true 
        textField.placeholder = "Password"
        textField.textColor = .black
        textField.font = UIFont.defaultFont(16)
        return textField
    }()
    
    private lazy var hidePasswordFieldButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = .clear
        button.tintColor = .black
        button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.addTarget(self, action: #selector(hideTextField(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        var button = UIButton()
        button.backgroundColor = UIColor.shared.Brown
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.defaultBoldFont(20)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.tintColor = .black
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(signUpPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    init(presenter: RegistrationPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    @objc func hideTextField(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        let eyeImageCondition = passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
        hidePasswordFieldButton.setImage(UIImage(systemName: eyeImageCondition), for: .normal)
    }
    
    @objc func signUpPressed(_ sender: UIButton) {
        let registrationModel = RegistrationModel(
            name: nameTextField.text ?? "",
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
        
        presenter.signUpPressed(with: registrationModel)
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
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(imageLogo.snp.bottom).offset(50)
            make.height.equalTo(50)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
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
            make.leading.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        
        passwordTextField.rightView = rightPaddingButton
        passwordTextField.rightViewMode = .always
    }
    
}

// Presenter's methods 
extension RegistrationViewController: RegistrationViewProtocol {
    func showLoader() {
        view.addSubview(loaderView)
        loaderView.backgroundColor = UIColor.shared.LigthGray
        loaderView.layer.cornerRadius = 20
        loaderView.layer.cornerCurve = .continuous
        
        loaderView.snp.makeConstraints { make in
            make.center.equalTo(view.snp.center)
            make.size.equalTo(100)
        }
        
        loaderView.addSubview(loader)
        loader.style = .large
        loader.color = .black
        
        loader.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(30)
        }
        
        loader.startAnimating()
    }
    
    func hideLoader() {
        loader.stopAnimating()
        loader.removeFromSuperview()
        loaderView.removeFromSuperview()
    }
    
    func showInvalidEmailError() {
        AlertManager.showInvalidEmailAlert(on: self)
    }
    
    func showInvalidUsernameError() {
        AlertManager.showInvalidUsernameAlert(on: self)
    }
    
    func showInvalidPasswordError() {
        AlertManager.showInvalidPasswordAlert(on: self)
    }
    
    func showRegistrationError(with error: Error) {
        AlertManager.showRegistrationErrorAlert(on: self, with: error)
    }
    
    func checkAuthentication(answer: Bool) {
        if answer {
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.checkAuthentication()
            }
        } else {
            AlertManager.showRegistrationErrorAlert(on: self)
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            // Dismiss the keyboard when return is tapped
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Dismiss the keyboard when return is tapped
        textField.resignFirstResponder()
        return true
    }
}
