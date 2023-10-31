//
//  TransactionTableViewCell.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 01.11.2023.
//

import UIKit
import SnapKit

class TransactionTableViewCell: UITableViewCell {
    private var transImage: UIImageView = {
        var image = UIImageView()
        image.layer.cornerRadius = 10
        image.layer.masksToBounds = true
        image.layer.cornerCurve = .continuous
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "cart")
        image.backgroundColor = UIColor(hex: "#eeeeee")
        image.tintColor = .black
        return image
    }()
    
    private var transName: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16)
        label.text = "Galmart"
        label.textColor = .black
        return label
    }()
    
    private var purchasedData: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 14)
        label.text = "Today"
        label.textColor = .black
        return label
    }()
    
    private var priceLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "HelveticaNeue", size: 16)
        label.text = "+ $ 12.00"
        label.textColor = .green
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        contentView.addSubview(transImage)
        transImage.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(transName)
        transName.snp.makeConstraints { make in
            make.left.equalTo(transImage.snp.right).offset(10)
            make.top.equalTo(transImage.snp.top).offset(5)
        }
        
        contentView.addSubview(purchasedData)
        purchasedData.snp.makeConstraints { make in
            make.left.equalTo(transImage.snp.right).offset(10)
            make.bottom.equalTo(transImage.snp.bottom).offset(-5)
        }
        
        contentView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-5)
            make.centerY.equalToSuperview()
        }
    }
}
