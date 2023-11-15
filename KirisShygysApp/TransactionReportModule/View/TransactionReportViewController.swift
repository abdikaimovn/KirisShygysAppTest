//
//  TransactionReportViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 14.11.2023.
//

import UIKit

class TransactionReportViewController: UIViewController {
    var transactionData: [TransactionModel]?
    var groupedTransactions: [String: [TransactionModel]] = [:]
    var sectionTitles: [String] = []
    
    private var headerView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.shared.Brown
        view.layer.cornerRadius = 30
        view.layer.cornerCurve = .continuous
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        return view
    }()
    
    private var periodView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private var backButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.backgroundColor = .clear
        btn.tintColor = .white
        return btn
    }()
    
    private var periodLabel: UILabel = {
        var label = UILabel()
        label.text = "Month"
        label.font = UIFont(name: "Futura", size: 17)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var reportView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(hex: "#f9f7f4")
        view.layer.cornerRadius = 5
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private var reportLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.shared.Brown
        label.text = "See your financial report"
        label.font = UIFont(name: "Futura", size: 17)
        return label
    }()
    
    private var rightArrow: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(systemName: "arrow.right.square")
        image.backgroundColor = .clear
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.shared.Brown
        return image
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: "TransactionTableViewCell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupedTransactions = Dictionary(grouping: transactionData ?? [], by: { $0.transactionDate })
        sectionTitles = groupedTransactions.keys.sorted(by: >)
        
        setupView()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    init(transactionData: [TransactionModel]) {
        self.transactionData = transactionData
        print(transactionData.prefix(10))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Transaction REPORT View Controler deinited")
    }
    
    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        headerView.addSubview(periodView)
        periodView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        headerView.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalTo(periodView.snp.centerY)
            make.size.equalTo(20)
        }
        
        periodView.addSubview(periodLabel)
        periodLabel.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().inset(10)
        }
        
        headerView.addSubview(reportView)
        reportView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(periodView.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        reportView.addSubview(reportLabel)
        reportLabel.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview().inset(15)
        }
        
        reportView.addSubview(rightArrow)
        rightArrow.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(20)
        }
    }
}

extension TransactionReportViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        return groupedTransactions[sectionTitle]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionTitle = sectionTitles[section]
        
        switch sectionTitle {
        case Date.now.formatted().prefix(10):
            return "Today"
        case Date().yesterday.formatted().prefix(10):
            return "Yesterday"
        default:
            return sectionTitle
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        
        let sectionTitle = sectionTitles[indexPath.section]
        if let transactions = groupedTransactions[sectionTitle] {
            let transaction = transactions[indexPath.row]
            cell.configure(transactionData: transaction, isHiddenPeriod: true)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? self
    }
}
