//
//  UIColorExtension.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 05.10.2023.
//

import Foundation
import UIKit

// Extensing UIColor class to adopt HEX colors
extension UIColor {
    static var shared = UIColor()
    convenience init?(hex: String) {
        var formattedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgbValue: UInt64 = 0
        
        Scanner(string: formattedHex).scanHexInt64(&rgbValue)
        
        if formattedHex.count == 6 {
            formattedHex = "FF" + formattedHex
        }
        
        if let red = UInt8(exactly: (rgbValue & 0xFF0000) >> 16),
           let green = UInt8(exactly: (rgbValue & 0x00FF00) >> 8),
           let blue = UInt8(exactly: (rgbValue & 0x0000FF) >> 0) {
                self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        } else {
            return nil
        }
    }
    
    var Brown: UIColor {
        UIColor(hex: "#C7B08E")!
    }
    
    var ExpenseColor: UIColor {
        UIColor(hex: "#E94D58")!
    }
    
    var IncomeColor: UIColor {
        UIColor(hex: "#2BA478")!
    }
    
    var LightGray: UIColor {
        UIColor(hex: "#f9f9f9")!
    }
    
    var Gray: UIColor {
        UIColor(hex: "#e0e0e0")!
    }
    
    var LightBrown: UIColor {
        UIColor(hex: "#ddd0bb")!
    }

}
