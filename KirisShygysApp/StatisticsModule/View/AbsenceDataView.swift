//
//  AbsenceDataView.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 10.01.2024.
//

import UIKit
import SnapKit

class AbsenceDataView: UIView {
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        view.contentMode = .scaleAspectFit
        view.image = UIImage(systemName: "chart.bar.xaxis")
        return view
    }()
    
    private let noDataLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.defaultFont(14)
        label.text = "noTransaction".localized
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    init(withColor color: UIColor) {
        imageView.tintColor = color
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.backgroundColor = .white
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalToSuperview().dividedBy(4)
        }
        
        addSubview(noDataLabel)
        noDataLabel.snp.makeConstraints { make in
            make.centerX.equalTo(imageView.snp.centerX)
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
    }
}
