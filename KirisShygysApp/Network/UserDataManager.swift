//
//  UserDataManager.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 12.11.2023.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol UserInfoProtocol {
    func fetchCurrentUsername(completion: @escaping (Result<String, Error>) -> Void)
    func fetchTransactionData(completion: @escaping (Result<[TransactionModel], FetchingTransactionsError>) -> Void)
}

protocol UserProfileProtocol {
    func fetchCurrentUsername(completion: @escaping (Result<String, Error>) -> Void)
    func fetchLastMonthTransactionData(completion: @escaping (Result<[TransactionModel], FetchingTransactionsError>) -> Void)
}

enum FetchingTransactionsError: Error {
    case gettingDocumentError(Error)
    case userNotFoundError
}

final class UserDataManager: UserProfileProtocol, UserInfoProtocol {
    static let shared = UserDataManager()
    private let transactions = "Transactions"
    private let incomes = "Incomes"
    private let expenses = "Expenses"
    private let username = "username"
    
    func fetchCurrentUsername(completion: @escaping (Result<String, Error>) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(.success("Username is not found"))
            return
        }
        
        let ref = Firestore.firestore().collection("users").document(currentUserUID)
        ref.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let snapshot = snapshot, let userData = snapshot.data(), let name = userData[self.username] as? String {
                completion(.success(name))
            }
        }
        
    }
    
    func fetchTransactionData(completion: @escaping (Result<[TransactionModel], FetchingTransactionsError>) -> Void) {
        var transactionData: [TransactionModel] = []
        
        let db = Firestore.firestore()
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(.failure(.userNotFoundError))
            return
        }
        
        // Example query to retrieve data from the "Incomes" collection
        db.collection("users").document(currentUserUID).collection(transactions).order(by: "date").getDocuments { [weak self] (querySnapshot, error) in
            guard self != nil else { return }
            
            if let error = error {
                completion(.failure(.gettingDocumentError(error)))
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
                
                let transactions = querySnapshot?.documents.compactMap { document in
                    return TransactionModel(data: document.data())
                } ?? []
                
                transactionData = transactions.sorted{ (transaction1: TransactionModel, transaction2: TransactionModel) -> Bool in
                    if let date1 = dateFormatter.date(from: transaction1.transactionDate), let date2 = dateFormatter.date(from: transaction2.transactionDate) {
                        return date1 > date2
                    }
                    return false
                }
                
                completion(.success(transactionData))
            }
        }
    }
    
    func fetchLastMonthTransactionData(completion: @escaping (Result<[TransactionModel], FetchingTransactionsError>) -> Void) {
        var transactionData: [TransactionModel] = []
        //Check if user is registered
        let db = Firestore.firestore()
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(.failure(.userNotFoundError))
            return
        }
        
        // Calculate the start and end date for the last month
        let currentDate = Date()
        let lastMonthStartDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        let lastMonthEndDate = currentDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        db.collection("users").document(currentUserUID).collection(transactions)
            .getDocuments { [weak self] (querySnapshot, error) in
                guard self != nil else { return }
                
                if let error = error {
                    completion(.failure(.gettingDocumentError(error)))
                } else {
                    let transactions = querySnapshot?.documents.compactMap { document in
                        return TransactionModel(data: document.data())
                    } ?? []
                    //Sort data in descending order
                    transactionData = transactions.sorted { (transaction1, transaction2) in
                        if let date1 = dateFormatter.date(from: transaction1.transactionDate),
                           let date2 = dateFormatter.date(from: transaction2.transactionDate) {
                            return date1 > date2
                        }
                        return false
                    }
                    // Retrieving only last month transactions
                    var lastMonthTransactions = [TransactionModel]()
                    for i in transactionData {
                        if let date = dateFormatter.date(from: i.transactionDate) {
                            if date >= lastMonthStartDate && date <= lastMonthEndDate {
                                lastMonthTransactions.append(i)
                            }
                        }
                    }
    
                    completion(.success(lastMonthTransactions))
                }
            }
    }
}
