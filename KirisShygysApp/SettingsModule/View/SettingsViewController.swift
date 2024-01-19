//
//  SettingsViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 11.01.2024.
//

import UIKit

final class SettingsViewController: UIViewController {
    private let presenter: SettingsPresenter

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
    
    init(presenter: SettingsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .black
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backBarButtonItem
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = "settings_label".localized
        
        view.addSubview(menuTableView)
        menuTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
        }
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
        switch indexPath.row {
        case 0:
            cell.configure(with: UIImage(systemName: "textformat")!,
                           and: "language_label".localized)
            return cell
        case 1:
            cell.configure(with: UIImage(systemName: "tengesign")!, 
                           and: "currency_label".localized)
            return cell
        case 2:
            cell.configure(with: UIImage(systemName: "person.text.rectangle")!, 
                           and: "personalInfo_label".localized)
            return cell
        default:
            return cell
        }
    }
    
    
}

extension SettingsViewController: SettingsViewProtocol {
    
}
