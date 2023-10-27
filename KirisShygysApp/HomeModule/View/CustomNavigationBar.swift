//
//  CustomNavigationBar.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 26.10.2023.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    private var welcomeLabel: UILabel = {
        var label = UILabel()
        label.text = "Welcome Back!"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
