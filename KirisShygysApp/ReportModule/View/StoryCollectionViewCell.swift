//
//  StoryCollectionViewCell.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 29.11.2023.
//

import UIKit

final class StoryCollectionViewCell: UICollectionViewCell {
    private let thisMonthLabel: UILabel = {
        var label = UILabel()
        label.text = "thisMonthTitle_label".localized
        label.textColor = UIColor.shared.LightGray
        label.font = UIFont.defaultFont(20)
        return label
    }()
    
    private let transactionType: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultBoldFont(35)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let amountLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultBoldFont(35)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let containerView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        view.layer.masksToBounds = true
        return view
    }()
    
    private let biggestTransactionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultFont(25)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let biggestTransactionView: UIView = {
        var view = UIView()
        view.backgroundColor = UIColor.shared.LightGray
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let biggestTransactionName: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultFont(25)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let biggestTransactionAmount: UILabel = {
        var label = UILabel()
        label.font = UIFont.defaultFont(30)
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
        thisMonthLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        thisMonthLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(transactionType)
        transactionType.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(thisMonthLabel.snp.bottom).offset(60)
        }
        transactionType.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(amountLabel)
        amountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(transactionType.snp.bottom).offset(10)
        }
        amountLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(amountLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(30)
        }
        
        containerView.addSubview(biggestTransactionLabel)
        biggestTransactionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        containerView.addSubview(biggestTransactionView)
        biggestTransactionView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        biggestTransactionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(biggestTransactionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        biggestTransactionView.addSubview(biggestTransactionName)
        biggestTransactionName.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(15)
        }
   
        containerView.addSubview(biggestTransactionAmount)
        biggestTransactionAmount.snp.makeConstraints { make in
            make.top.equalTo(biggestTransactionView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
        biggestTransactionAmount.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    public func configure(reportModel: ReportModel) {
        //hide container if there is an empty amount of money
        containerView.isHidden = reportModel.isEmptyAmount
        self.transactionType.text = reportModel.transactionType
        self.amountLabel.text = reportModel.amount
        self.biggestTransactionLabel.text = reportModel.biggestTransactionLabel
        self.biggestTransactionName.text = reportModel.biggestTransactionName
        self.biggestTransactionAmount.text = reportModel.biggestTransactionAmount
    }
}
