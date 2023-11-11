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

    // Инициализатор для преобразования данных из Firebase
    init(data: [String: Any]) {
        self.transactionAmount = data["amount"] as? Int ?? 0
        self.transactionType = TransactionType(rawValue: data["type"] as? String ?? "") ?? .income
        self.transactionName = data["name"] as? String ?? ""
        self.transactionDescription = data["description"] as? String ?? ""
        self.transactionDate = data["date"] as? String ?? ""
    }

    // Инициализатор для создания объекта из явных параметров
    init(amount: Int, type: TransactionType, name: String, description: String, date: String) {
        self.transactionAmount = amount
        self.transactionType = type
        self.transactionName = name
        self.transactionDescription = description
        self.transactionDate = date
    }
}

enum TransactionType: String {
    case income = "income"
    case expense = "expense"
}

