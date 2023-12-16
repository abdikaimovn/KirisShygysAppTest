//
//  DetailTransactionViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 28.11.2023.
//

import UIKit

final class DetailTransactionView: UIView {
    private var transactionInfo: TransactionModel!
    
    init(frame: CGRect, transactionInfo: TransactionModel) {
        super.init(frame: frame)
        
        self.transactionInfo = transactionInfo
        self.setupView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let logoImage: UIImageView = {
        var image = UIImageView()
        image.image = UIImage(named: "logo")
        image.layer.cornerRadius = 20
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private let infoView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let titleLabel: UILabel = {
        var label = UILabel()
        label.text = "Transaction Info"
        label.font = UIFont.defaultBoldFont(25)
        label.textColor = .black
        return label
    }()
    
    private lazy var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "DetailTableViewCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        return tableView
    }()
    
    private func setupView() {
        self.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalToSuperview()
        }
        
        infoView.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.size.equalTo(50)
            make.top.equalToSuperview().inset(15)
        }
        
        infoView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImage.snp.centerY)
            make.leading.equalTo(logoImage.snp.trailing).offset(15)
        }
        
        infoView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(logoImage.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}

extension DetailTransactionView: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        cell.selectionStyle = .none
        
        switch indexPath.row {
        case 0:
            cell.configure(transactionKey: "Type:", transactionValue: transactionInfo.transactionType.rawValue)
        case 1:
            cell.configure(transactionKey: "Name:", transactionValue: transactionInfo.transactionName)
        case 2:
            cell.configure(transactionKey: "Amount:", transactionValue: "$ \(transactionInfo.transactionAmount)")
        case 3:
            cell.configure(transactionKey: "Date:", transactionValue: transactionInfo.transactionDate)
        case 4:
            let description = transactionInfo.transactionDescription
            cell.configure(transactionKey: "Description:", transactionValue: description)
        default:
            break
        }
        
        return cell
    }
}
