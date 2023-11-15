//
//  Date+Extension.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 15.11.2023.
//

import Foundation

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? self
    }
}
