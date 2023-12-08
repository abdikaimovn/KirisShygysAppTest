//
//  DetailTransactionViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 28.11.2023.
//

import UIKit

class DetailTransactionView: UIView {
    private var transactionInfo: TransactionModel!
    
    init(frame: CGRect, transactionInfo: TransactionModel) {
        super.init(frame: frame)
        
        self.transactionInfo = transactionInfo
        self.setupView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var mainView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(hex: "#c0c0c0")!.withAlphaComponent(0.5)
        return view
    }()
    
    private var closeButton: UIButton = {
        var button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        return button
    }()
    
    private var logoImage: UIImageView = {
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
    
    private var tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: "DetailTableViewCell")
        return tableView
    }()
    
    @objc func closeButtonTapped() {
        self.removeFromSuperview()
    }
    
    private func setupView() {
        self.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }

        mainView.addSubview(closeButton)
        closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(100)
            make.left.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }
        
        mainView.addSubview(infoView)
        infoView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        infoView.addSubview(logoImage)
        logoImage.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.size.equalTo(50)
            make.top.equalToSuperview().inset(15)
        }
        
        infoView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoImage.snp.centerY)
            make.left.equalTo(logoImage.snp.right).offset(15)
        }
        
        infoView.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(logoImage.snp.bottom).offset(20)
            make.bottom.equalToSuperview().inset(20)
        }
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
}

extension DetailTransactionView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
        
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
