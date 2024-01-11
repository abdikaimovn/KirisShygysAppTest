//
//  ReportModel.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 29.11.2023.
//

import Foundation

struct ReportModel {
    var transactionType: String
    var amount: String
    var biggestTransactionLabel: String
    var biggestTransactionName: String
    var biggestTransactionAmount: String
}

struct QuoteModel {
    var quote: String
    var author: String
}

struct ReportInfo {
    var summa: Int
    var maxValue: Int
    var maxValueTitle: String
}
