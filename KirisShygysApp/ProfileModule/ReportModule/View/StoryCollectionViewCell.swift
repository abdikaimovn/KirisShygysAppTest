//
//  StoryCollectionViewCell.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 29.11.2023.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    private var thisMonthLabel: UILabel = {
        var label = UILabel()
        label.text = "This Month"
        label.textColor = UIColor(hex: "#F2F2F2")
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        return label
    }()
    
    private var transactionType: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var amountLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 35)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        return view
    }()
    
    private var biggestTransactionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 25)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var biggestTransactionView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor(hex: "#CCCCCC")
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private var biggestTransactionName: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 25)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var biggestTransactionAmount: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 30)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addSubview(thisMonthLabel)
        thisMonthLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(transactionType)
        transactionType.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(thisMonthLabel.snp.bottom).offset(60)
        }
        
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(transactionType.snp.bottom).offset(10)
        }
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
        
        containerView.addSubview(biggestTransactionLabel)
        biggestTransactionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(biggestTransactionView)
        biggestTransactionView.snp.makeConstraints { make in
            make.top.equalTo(biggestTransactionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        biggestTransactionView.addSubview(biggestTransactionName)
        biggestTransactionName.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(15)
        }
        
        containerView.addSubview(biggestTransactionAmount)
        biggestTransactionAmount.snp.makeConstraints { make in
            make.top.equalTo(biggestTransactionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    public func configure(reportModel: ReportModel) {
        self.transactionType.text = reportModel.transactionType
        self.amountLabel.text = reportModel.amount
        self.biggestTransactionLabel.text = reportModel.biggestTransactionLabel
        self.biggestTransactionName.text = reportModel.biggestTransactionName
        self.biggestTransactionAmount.text = reportModel.biggestTransactionAmount
    }
}
