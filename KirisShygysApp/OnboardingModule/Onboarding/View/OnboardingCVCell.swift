//
//  OnboardingCVCell.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.10.2023.
//

import UIKit
import SnapKit

final class OnboardingCVCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        var imgView = UIImageView()
        return imgView
    }()
    
    private let titleLabel: UILabel = {
        var title = UILabel()
        title.font = UIFont(name: "Helvetica", size: 32)
        title.textColor = .black
        title.textAlignment = .center
        title.numberOfLines = 0
        return title
    }()
    
    private var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont(name: "Helvetica", size: 16)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(onboardingModel: OnboardingModel) {
        self.imageView.image = onboardingModel.image
        self.titleLabel.text = onboardingModel.title
        self.descriptionLabel.text = onboardingModel.description
    }
    
    private func setupUI() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(300)
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(30)
        }
        
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
    }
}
