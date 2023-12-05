//
//  ProfileViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.11.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let profilePresenter: ProfilePresenter
    
    private let loader = UIActivityIndicatorView()
    private let loaderView = UIView()
    
    private var userImage: UIImageView = {
        var image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.layer.cornerCurve = .continuous
        image.image = UIImage(systemName: "person.crop.circle")
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor(hex: "#eeeeef")
        image.tintColor = UIColor.shared.Brown
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
        label.text = "Loading..."
        label.textColor = .black
        label.font = UIFont(name: "Futura-Bold", size: 22)
        return label
    }()
    
    private var editButton: UIButton = {
        var btn = UIButton()
        btn.tintColor = .black
        btn.setImage(UIImage(systemName: "pencil"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.backgroundColor = .clear
        return btn
    }()
    
    private lazy var transactionReport: UIView = {
        var view = configureCustomButtonView(viewImage: "doc", viewTitle: "Transaction Report")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(reportTransactionTapped)))
        return view
    }()
    
    private lazy var settingsView: UIView = {
        var view = configureCustomButtonView(viewImage: "gear", viewTitle: "Settings")
        return view
    }()
    
    private lazy var logOutView: UIView = {
        var view = configureCustomButtonView(viewImage: "rectangle.portrait.and.arrow.right", viewTitle: "Logout")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logOutDidTapped)))
        return view
    }()
    
    private lazy var statisticsView: UIView = {
        var view = configureCustomButtonView(viewImage: "chart.bar.xaxis", viewTitle: "Statistics")
        return view
    }()
    
    init(profilePresenter: ProfilePresenter) {
        self.profilePresenter = profilePresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        profilePresenter.viewDidLoaded()
    }
    
    deinit {
        print("Profile VC deinit")
    }

    @objc internal func logOutDidTapped() {
        profilePresenter.logOutDidTapped()
    }
    
    @objc private func reportTransactionTapped() {
        self.profilePresenter.reportTransactionDidTapped()
    }
    
    private func configureCustomButtonView(viewImage: String, viewTitle: String) -> UIView {
        let mainView: UIView = {
            let view = UIView()
            view.isUserInteractionEnabled = true
            view.backgroundColor = UIColor(hex: "#eeeeef")
            view.layer.cornerRadius = 10
            return view
        }()
        
        let subView: UIView = {
            let view = UIView()
            view.backgroundColor = .white
            view.layer.cornerRadius = 15
            view.layer.cornerCurve = .continuous
            return view
        }()
        
        let image: UIImageView = {
            let image = UIImageView()
            image.image = UIImage(systemName: viewImage)
            image.tintColor = .black
            image.contentMode = .scaleAspectFit
            return image
        }()
        
        let label: UILabel = {
            let label = UILabel()
            label.text = viewTitle
            label.textColor = .black
            label.font = UIFont(name: "Futura", size: 18)
            return label
        }()
        
        mainView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.size.equalTo(45)
        }
        
        subView.addSubview(image)
        image.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview().inset(10)
        }
        
        mainView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(subView.snp.right).offset(20)
            make.centerY.equalTo(image.snp.centerY)
        }
        
        return mainView
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
            make.top.equalTo(userImage.snp.top).offset(5)
        }
        
        view.addSubview(userName)
        userName.snp.makeConstraints { make in
            make.left.equalTo(userImage.snp.right).offset(20)
            make.bottom.equalTo(userImage.snp.bottom).offset(-5)
        }
        
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(userImage.snp.centerY)
            make.size.equalTo(40)
        }
        
        view.addSubview(transactionReport)
        transactionReport.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(userImage.snp.bottom).offset(30)
        }
        
        view.addSubview(settingsView)
        settingsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(transactionReport.snp.bottom).offset(10)
        }
        
        view.addSubview(statisticsView)
        statisticsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(settingsView.snp.bottom).offset(10)
        }
        
        view.addSubview(logOutView)
        logOutView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(statisticsView.snp.bottom).offset(10)
        }
    }
    
}

extension ProfileViewController: ProfileViewProtocol {
    func showReportError() {
        AlertManager.absenceTransactionData(on: self)
    }
    
    func showError(with model: ErrorModel) {
        
    }
    
    func setUsername(_ name: String) {
        self.userName.text = name
    }
    
    func didReceiveUserTransactionReport(_ transactionData: [TransactionModel]?) {
        self.navigationController?.pushViewController(ReportViewController(transactionData: transactionData!), animated: true)
    }
    
    func showLoader() {
        view.addSubview(loaderView)
        loaderView.backgroundColor = .white
        loaderView.frame = view.bounds
        loaderView.addSubview(loader)
        loader.startAnimating()
        loader.center = loaderView.center
    }
    
    func hideLoader() {
        loader.stopAnimating()
        loader.removeFromSuperview()
        loaderView.removeFromSuperview()
    }
    
    func logOut() {
        if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
            sceneDelegate.checkAuthentication()
        }
    }
}
