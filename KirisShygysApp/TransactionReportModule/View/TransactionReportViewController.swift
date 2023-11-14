//
//  TransactionReportViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 14.11.2023.
//

import UIKit

class TransactionReportViewController: UIViewController {
    var transactionData: [TransactionModel]?
    
    init(transactionData: [TransactionModel]) {
        self.transactionData = transactionData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var periodView: UIView = {
        var view = UIView()
        view.backgroundColor = .clear
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        view.layer.borderColor = UIColor.shared.Brown.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private var backButton: UIButton = {
        var btn = UIButton()
        btn.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.backgroundColor = .clear
        btn.tintColor = UIColor.shared.Brown
        return btn
    }()
    
    private var periodLabel: UILabel = {
        var label = UILabel()
        label.text = "Month"
        label.font = UIFont(name: "Futura", size: 17)
        label.textColor = .black
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
        
        setupView()
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }

    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(periodView)
        periodView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalTo(periodView.snp.centerY)
            make.size.equalTo(30)
        }
        
        periodView.addSubview(periodLabel)
        periodLabel.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview().inset(10)
        }
        
        view.addSubview(reportView)
        reportView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.equalTo(periodView.snp.bottom).offset(15)
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
            make.top.equalTo(reportView.snp.bottom).offset(20)
        }
    }
}

extension TransactionReportViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.transactionData!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        cell.configure(transactionData: transactionData![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
