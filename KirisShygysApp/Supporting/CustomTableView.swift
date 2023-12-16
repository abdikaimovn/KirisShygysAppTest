//
//  CustomTableView.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 16.12.2023.
//

import UIKit

import UIKit

class CustomTableView: UITableView {

    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    override public var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return contentSize
    }

}
