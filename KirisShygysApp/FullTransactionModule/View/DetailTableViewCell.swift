//
//  DetailTableViewCell.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 07.12.2023.
//

import UIKit

final class DetailTableViewCell: UITableViewCell {
    private var transactionKeyLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.numberOfLines = 1
        label.font = UIFont.defaultBoldFont(16)
        return label
    }()
    
    private var transactionValueLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont.defaultFont(16)
        label.numberOfLines = 0
        return label
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    func configure(transactionKey: String, transactionValue: String) {
        self.transactionKeyLabel.text = transactionKey
        self.transactionValueLabel.text = transactionValue.isEmpty ? "Transaction description not specified" : transactionValue
    }
    
    private func setupCell() {
        contentView.backgroundColor = .clear
        contentView.addSubview(transactionKeyLabel)
        transactionKeyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
        }
        
        transactionKeyLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        contentView.addSubview(transactionValueLabel)
        transactionValueLabel.snp.makeConstraints { make in
            make.left.equalTo(transactionKeyLabel.snp.right).offset(10)
            make.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
        }
        
        transactionValueLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        transactionValueLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }

}
