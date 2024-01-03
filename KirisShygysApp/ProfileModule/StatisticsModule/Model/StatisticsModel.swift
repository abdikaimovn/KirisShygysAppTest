//
//  StatisticsModel.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 02.01.2024.
//

import Foundation

enum FlowImageEnum: String {
    case income = "square.and.arrow.down"
    case expense = "square.and.arrow.up"
    case total = "dollarsign.square.fill"
}

struct FlowModel {
    let value: Int
    let flowImage: FlowImageEnum
}
