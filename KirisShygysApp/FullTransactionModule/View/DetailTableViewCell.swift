//
//  DetailTableViewCell.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 07.12.2023.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    private var transactionKeyLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.font = UIFont.defaultBoldFont(18)
        return label
    }()
    
    private var transactionValueLabel: UILabel = {
        var label = UILabel()
        label.textColor = .black
        label.font = UIFont.defaultFont(18)
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
        self.transactionValueLabel.text = transactionValue
        print("\(transactionKey) - \(transactionValue)")
    }
    
    private func setupCell() {
        contentView.addSubview(transactionKeyLabel)
        transactionKeyLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(10)
        }
        
        contentView.addSubview(transactionValueLabel)
        transactionValueLabel.snp.makeConstraints { make in
            make.left.equalTo(transactionKeyLabel.snp.left).offset(10)
            make.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
}
