//
//  SectionTitleModel.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 07.12.2023.
//

import Foundation

struct SectionTitleModel {
    var fullDate: String
    
    var sectionTitleDate: String {
        return String(fullDate.prefix(10))
    }
}
