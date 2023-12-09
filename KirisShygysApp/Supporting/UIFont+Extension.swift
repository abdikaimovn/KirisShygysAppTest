//
//  UIFont+Extension.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 06.12.2023.
//

import UIKit

extension UIFont {
    static func defaultFont(_ sizeOf: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue", size: sizeOf)!
    }
    
    static func defaultBoldFont(_ sizeOf: CGFloat) -> UIFont {
        return UIFont(name: "HelveticaNeue-Bold", size: sizeOf)!
    }
}