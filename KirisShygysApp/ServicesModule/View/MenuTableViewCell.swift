//
//  MenuTableViewCell.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 16.12.2023.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    private let mainView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor.shared.LightGray
        view.layer.cornerRadius = 10
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let subView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.tintColor = .black
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.defaultFont(18)
        return label
    }()
    
    private let rightArrow: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "right.arrow")
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage, and title: String) {
        self.image.image = image
        self.title.text = title
    }
    
    private func setupView() {
        self.selectionStyle = .none
        contentView.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(5)
        }
        
        mainView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.size.equalTo(45)
        }
        
        subView.addSubview(image)
        image.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(10)
        }
        
        mainView.addSubview(title)
        title.snp.makeConstraints { make in
            make.leading.equalTo(subView.snp.trailing).offset(20)
            make.centerY.equalTo(image.snp.centerY)
        }
        
        mainView.addSubview(rightArrow)
        rightArrow.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(title.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalTo(subView)
            make.size.equalTo(20)
        }
    }
}
