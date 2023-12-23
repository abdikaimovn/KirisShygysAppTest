//
//  ProfileViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.11.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private let presenter: ProfilePresenter
    
    private let loader = UIActivityIndicatorView()
    private let loaderView = UIView()
    
    private let userImage: UIImageView = {
        var image = UIImageView()
        image.clipsToBounds = true
        image.layer.cornerRadius = 20
        image.layer.cornerCurve = .continuous
        image.image = UIImage(systemName: "person.crop.circle")
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor.shared.LightGray
        image.tintColor = UIColor.shared.Brown
        return image
    }()
   
    private let userNameLabel: UILabel = {
        var label = UILabel()
        label.text = "Username"
        label.textColor = .black
        label.font = UIFont.defaultFont(16)
        return label
    }()
    
    private let userName: UILabel = {
        var label = UILabel()
        label.text = "Loading..."
        label.textColor = .black
        label.font = UIFont.defaultBoldFont(22)
        return label
    }()
    
    private let editButton: UIButton = {
        var btn = UIButton()
        btn.tintColor = .black
        btn.setImage(UIImage(systemName: "pencil"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.backgroundColor = .clear
        return btn
    }()
    
    private lazy var menuTableView: UITableView = {
        let tableView = CustomTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.isScrollEnabled = false
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "MenuTableViewCell")
        return tableView
    }()
    
    init(presenter: ProfilePresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        presenter.viewDidLoaded()
    }
    
    deinit {
        print("Profile VC deinit")
    }
    
    private func createTransactionReportModule(with data: [TransactionModel]) -> UIViewController {
        let presenter = ReportPresenter()
        let view = ReportViewController(transactionData: data, presenter: presenter)
        presenter.view = view
        return view
    }
    
    private func createStatisticsModule(with data: [TransactionModel]) -> UIViewController {
        let presenter = StatisticsPresenter()
        let view = StatisticsViewController(transactionData: data, presenter: presenter)
        presenter.view = view
        return view
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(userImage)
        
        userImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            make.size.equalTo(60)
        }
        
        view.addSubview(userNameLabel)
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImage.snp.trailing).offset(20)
            make.top.equalTo(userImage.snp.top).offset(5)
        }
        
        view.addSubview(userName)
        userName.snp.makeConstraints { make in
            make.leading.equalTo(userImage.snp.trailing).offset(20)
            make.bottom.equalTo(userImage.snp.bottom).offset(-5)
        }
        
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalTo(userImage.snp.centerY)
            make.size.equalTo(40)
        }
        
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(userImage.snp.bottom).offset(30)
        }
    }
}

extension ProfileViewController: ProfileViewProtocol {
    func showUnknownError(with model: ErrorModel) {
        AlertManager.showUnknownError(on: self, message: model.text)
    }
    
    func showAbsenseDataError() {
        AlertManager.showAbsenceTransactionData(on: self)
    }
    
    func showReportError(with model: ErrorModel) {
        AlertManager.showReportError(on: self, with: model)
    }
    
    func showTransactionReport(with transactionData: [TransactionModel]) {
        self.navigationController?.pushViewController(createTransactionReportModule(with: transactionData), animated: true)
    }
    
    func showStatistics(with transactionData: [TransactionModel]) {
        self.navigationController?.pushViewController(createStatisticsModule(with: transactionData), animated: true)
    }
    
    func showStatisticsError() {
        AlertManager.showAbsenceTransactionData(on: self)
    }
    
    func showLogoutError(with model: ErrorModel) {
        AlertManager.showLogOutErrorAlert(on: self, with: model.error)
    }
    
    func setUsername(_ name: String) {
        self.userName.text = name
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            presenter.reportTransactionDidTapped()
        case 1:
            break
        case 2:
            presenter.statisticsDidTapped()
        case 3:
            presenter.logOutDidTapped()
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        
        switch indexPath.row {
        case 0:
            cell.configure(with: UIImage(systemName: "doc")!, and: "Transaction Report")
        case 1:
            cell.configure(with: UIImage(systemName: "gear")!, and: "Settings")
        case 2:
            cell.configure(with: UIImage(systemName: "chart.bar.xaxis")!, and: "Statistics")
        case 3:
            cell.configure(with: UIImage(systemName: "rectangle.portrait.and.arrow.right")!, and: "Logout")
        default:
            return cell
        }
        
        return cell
    }
}
