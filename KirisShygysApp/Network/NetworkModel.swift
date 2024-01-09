//
//  NetworkModel.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 09.01.2024.
//

import Foundation

enum FetchingTransactionsError: Error {
    case gettingDocumentError(Error)
    case userNotFoundError
}

enum FetchingUsernameError: Error {
    case userNotFound
    case customError(Error)
}

enum DocumentTypeName: String {
    case users = "users"
    case transactions = "Transactions"
    case incomes = "Incomes"
    case expenses = "Expenses"
    case username = "username"
}

enum RegistrationError: Error {
    case userAlreadyExists
    case lackOfInternet
    case unknownError
}
