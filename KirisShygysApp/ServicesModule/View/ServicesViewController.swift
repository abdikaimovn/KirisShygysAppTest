//
//  ProfileViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.11.2023.
//

import UIKit

final class ServicesViewController: UIViewController {
    private let presenter: ServicesPresenter
    
    private let loader = UIActivityIndicatorView()
    private let loaderView = UIView()

    private let menuLabel: UILabel = {
        var label = UILabel()
        label.text = "menu_label".localized
        label.textColor = .black
        label.font = UIFont.defaultBoldFont(30)
        return label
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
    
    init(presenter: ServicesPresenter) {
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
    
    private func createSettingsModule() -> UIViewController{
        let presenter = SettingsPresenter()
        let view = SettingsViewController(presenter: presenter)
        presenter.view = view
        return view
    }
    
    private func setupView() {
        view.backgroundColor = .white
    
        view.addSubview(menuLabel)
        menuLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(20)
        }
        
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(menuLabel.snp.bottom).offset(10)
        }
    }
}

extension ServicesViewController: ServicesViewProtocol {
    func showReportAbsenceDataAlert(with model: ErrorModelInfo) {
        AlertManager.showAbsenceTransactionData(on: self, with: model)
    }
    
    func showSettings() {
        self.navigationController?.pushViewController(createSettingsModule(), animated: true)
    }
    
    func showUnknownError(with model: ErrorModel) {
        AlertManager.showUnknownError(on: self, message: model.text)
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
    
    func showStatisticsAbsenceDataAlert(with model: ErrorModelInfo) {
        AlertManager.showAbsenceTransactionData(on: self, with: model)
    }
    
    func showLogoutError(with model: ErrorModel) {
        AlertManager.showLogOutErrorAlert(on: self, with: model.error)
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

extension ServicesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            presenter.reportTransactionDidTapped()
        case 1:
            presenter.settingsDidTapped()
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
            cell.configure(with: UIImage(systemName: "doc")!, 
                           and: "transactionReport_label".localized)
        case 1:
            cell.configure(with: UIImage(systemName: "gear")!, 
                           and: "settings_label".localized)
        case 2:
            cell.configure(with: UIImage(systemName: "chart.bar.xaxis")!, 
                           and: "statisctics_label".localized)
        case 3:
            cell.configure(with: UIImage(systemName: "rectangle.portrait.and.arrow.right")!, 
                           and: "logout_label".localized)
        default:
            return cell
        }
        
        return cell
    }
}
