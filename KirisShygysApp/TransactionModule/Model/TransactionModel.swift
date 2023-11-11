//
//  TransactionModel.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 11.11.2023.
//

import Foundation

struct TransactionModel {
    var transactionAmount: Int
    var transactionType: TransactionType
    var transactionName: String
    var transactionDescription: String
    var transactionDate: String
}

enum TransactionType {
    case income
    case expense
}

