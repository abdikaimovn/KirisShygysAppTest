//
//  DetailTransactionViewController.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 28.11.2023.
//

import UIKit

class DetailTransactionViewController: UIViewController {
    private var priceView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private var priceLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Futura-Bold", size: 40)
        return label
    }()
    
    private var purchasedDataLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        var label = UILabel()
        label.textColor = .white
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 50)
        label.numberOfLines = 0
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    private func setupView() {
        view.addSubview(priceView)
        priceView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(40)
        }
        
        priceView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(40)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        view.addSubview(purchasedDataLabel)
        purchasedDataLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(priceView.snp.bottom).offset(30)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(purchasedDataLabel.snp.bottom).offset(30)
        }
    }

    func configure(transactionInfo: TransactionModel) {
        self.view.backgroundColor = transactionInfo.transactionType == .income ? UIColor.shared.IncomeColor : UIColor.shared.ExpenseColor
        self.priceLabel.text = "$ \(transactionInfo.transactionAmount)"
        self.purchasedDataLabel.text = transactionInfo.transactionDate
        
        if transactionInfo.transactionDescription.isEmpty {
            self.descriptionLabel.text = "Transaction description not specified"
        } else {
            self.descriptionLabel.text = transactionInfo.transactionDescription
        }
    }
}
