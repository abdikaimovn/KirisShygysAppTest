//
//  FilterModel.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 18.11.2023.
//

import Foundation

struct FilterModel {
    var filterBy: TransactionType?
    var sortBy: SortByEnum?
    var period: PeriodEnum?
}

enum SortByEnum {
    case newest, oldest
}

enum PeriodEnum {
    case week, month, halfyear, year
}
