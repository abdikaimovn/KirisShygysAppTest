//
//  UIFont+Extension.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 06.12.2023.
//

import UIKit

extension UIFont {
    static func defaultFont(_ sizeOf: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: sizeOf)!
    }
    
    static func defaultBoldFont(_ sizeOf: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica-Bold", size: sizeOf)!
    }
    
    static func defaultItalicFont(_ sizeOf: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica-Oblique", size: sizeOf)!
    }
}
