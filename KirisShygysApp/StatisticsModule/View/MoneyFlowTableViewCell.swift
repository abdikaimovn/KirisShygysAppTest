//
//  MoneyFlowTableViewCell.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 02.01.2024.
//

import UIKit
import SnapKit

final class MoneyFlowTableViewCell: UITableViewCell {
    private let viewImage: UIView = {
        var view = UIView()
        view.layer.cornerRadius = 6
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let flowImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private let flowLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(14)
        label.textColor = .black
        return label
    }()
    
    private let flowValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(14)
        label.textColor = .black
        return label
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .clear
    
        contentView.addSubview(flowImage)
        flowImage.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(5)
            make.size.equalTo(25)
        }
        
        contentView.addSubview(flowLabel)
        flowLabel.snp.makeConstraints { make in
            make.leading.equalTo(flowImage.snp.trailing).offset(10)
            make.centerY.equalTo(flowImage.snp.centerY)
        }
        
        contentView.addSubview(flowValue)
        flowValue.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(flowLabel.snp.centerY)
        }
    }
    
    func configure(with model: FlowModel) {
        switch model.flowImage {
        case .income:
            self.flowImage.image = UIImage(systemName: model.flowImage.rawValue)
            self.flowLabel.text = "incomes_label".localized
            self.flowValue.text = "\("currency".localized) \(model.value)"
            self.flowValue.textColor = UIColor.shared.IncomeColor
        case .expense:
            self.flowImage.image = UIImage(systemName: model.flowImage.rawValue)
            self.flowLabel.text = "expenses_label".localized
            self.flowValue.text = "\("currency".localized) \(model.value)"
            self.flowValue.textColor = UIColor.shared.ExpenseColor
        case .total:
            self.flowImage.image = UIImage(systemName: model.flowImage.rawValue)
            self.flowLabel.text = "total_label".localized
            self.flowValue.text = "\("currency".localized) \(model.value)"
        }
    }
}
