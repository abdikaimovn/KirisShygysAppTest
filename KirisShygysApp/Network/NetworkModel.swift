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

enum RegistrationError: String {
    case userAlreadyExists = "userAlreadyExists_error"
    case networkError = "network_error"
    case unknownError = "unknown_error"
}

enum AuthorizationError: String {
    case invalidCredential = "invalidCredential_error"
    case networkError = "network_error"
    case unknownError = "unknown_error"
}

struct ErrorModelInfo: Error {
    let title: String?
    let error: Error?
    let text: String?
    let localizedDescription: String
}
