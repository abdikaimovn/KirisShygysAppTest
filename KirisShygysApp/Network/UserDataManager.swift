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
    func fetchCurrentUsername(completion: @escaping (Result<String, FetchingUsernameError>) -> Void)
    func fetchTransactionData(completion: @escaping (Result<[TransactionModel], FetchingTransactionsError>) -> Void)
}

protocol UserProfileProtocol {
    func fetchCurrentUsername(completion: @escaping (Result<String, FetchingUsernameError>) -> Void)
    func fetchLastMonthTransactionData(completion: @escaping (Result<[TransactionModel], FetchingTransactionsError>) -> Void)
    func fetchTransactionData(completion: @escaping (Result<[TransactionModel], FetchingTransactionsError>) -> Void)
}

protocol TransactionPresenterService {
    func insertNewTransaction(transactionData: TransactionModel, completion: @escaping (Result<(), ErrorModel>) -> Void)
}

protocol FullTransactionPresenterService {
    func deleteTransaction(transactionData: TransactionModel, completion: @escaping (Result<(), ErrorModel>) -> Void)
}

final class UserDataManager: UserProfileProtocol, UserInfoProtocol, TransactionPresenterService {
    static let shared = UserDataManager()
    
    func fetchCurrentUsername(completion: @escaping (Result<String, FetchingUsernameError>) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            completion(.failure(.userNotFound))
            return
        }
        
        let ref = Firestore.firestore().collection(DocumentTypeName.users.rawValue).document(currentUserUID)
        ref.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(.customError(error)))
            }
            
            if let snapshot = snapshot, let userData = snapshot.data(), let name = userData[DocumentTypeName.username.rawValue] as? String {
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
        
        db.collection(DocumentTypeName.users.rawValue).document(currentUserUID).collection(DocumentTypeName.transactions.rawValue).getDocuments { [weak self] (querySnapshot, error) in
            guard self != nil else { return }
            
            if let error = error {
                completion(.failure(.gettingDocumentError(error)))
                return
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
        
        db.collection(DocumentTypeName.users.rawValue).document(currentUserUID).collection(DocumentTypeName.transactions.rawValue)
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
    
    func insertNewTransaction(transactionData: TransactionModel, completion: @escaping (Result<(), ErrorModel>) -> Void) {
        let db = Firestore.firestore()
        
        let collectionName: String
        switch transactionData.transactionType {
        case .income:
            collectionName = "Incomes"
        case .expense:
            collectionName = "Expenses"
        }
        
        // Creating an unique identifier for a transaction
        let transactionId = UUID().uuidString
        
        // Создайте словарь для данных транзакции
        let transactionDataDict: [String: Any] = [
            "id": transactionId,
            "name": transactionData.transactionName,
            "type": collectionName,
            "description": transactionData.transactionDescription,
            "amount": transactionData.transactionAmount,
            "date": transactionData.transactionDate
        ]
        
        // Добаление транзакции в коллекцию "Incomes" или "Expenses"
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection(collectionName)
            .document(transactionId)
            .setData(transactionDataDict) { error in
                if let error = error {
                    completion(.failure(ErrorModel(error: error)))
                    return
                }
            }
        
        // Добавления транзакции в коллекцию "Transactions"
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection("Transactions")
            .document(transactionId)
            .setData(transactionDataDict) { error in
                if let error = error {
                    completion(.failure(ErrorModel(error: error)))
                    return
                }
            }
        
        completion(.success(()))
    }
    
    func deleteTransaction(transactionData: TransactionModel, completion: @escaping (Result<(), ErrorModel>) -> Void) {
        let db = Firestore.firestore()
        
        let collectionName: String
        switch transactionData.transactionType {
        case .income:
            collectionName = "Incomes"
        case .expense:
            collectionName = "Expenses"
        }
        
        guard let transactionId = transactionData.id else {
            return
        }
        
        // Удаление транзакции из коллекции "Incomes" или "Expenses"
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection(collectionName)
            .document(transactionId)
            .delete { error in
                if let error = error {
                    completion(.failure(ErrorModel(error: error)))
                    return
                }
            }
        
        // Удаление транзакции из коллекции "Transactions"
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection("Transactions")
            .document(transactionId)
            .delete { error in
                if let error = error {
                    completion(.failure(ErrorModel(error: error)))
                    return
                }
            }
        
        completion(.success(()))
    }
}
