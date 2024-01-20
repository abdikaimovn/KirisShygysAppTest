//
//  ErrorModel.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 09.12.2023.
//

import Foundation

struct ErrorModel: Error{
    let error: Error
    
    var text: String {
        error.localizedDescription
    }
}
