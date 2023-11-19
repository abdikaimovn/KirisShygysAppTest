//
//  FilterModel.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 18.11.2023.
//

import Foundation

struct FilterModel {
    var filterBy: FilterByEnum?
    var sortBy: SortByEnum?
    var period: PeriodEnum?
}

enum FilterByEnum {
    case income, expense
}

enum SortByEnum {
    case highest, lowest, newest, oldest
}

enum PeriodEnum {
    case week, month, halfyear, year
}
