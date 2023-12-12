//
//  UserDataManager.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 12.11.2023.
//

import Foundation
import Firebase

protocol UserInfoProtocol {
    func getCurrentUserName(completion: @escaping (String?) -> Void)
    func fetchTransactionData(completion: @escaping ([TransactionModel]?) -> Void)
}

protocol UserProfileProtocol {
    func getCurrentUserName(completion: @escaping (String?) -> Void)
    func fetchLastMonthTransactionData(completion: @escaping ([TransactionModel]?) -> Void)
}

final class UserDataManager: UserProfileProtocol, UserInfoProtocol {
    static let shared = UserDataManager()
    private let transactions = "Transactions"
    private let incomes = "Incomes"
    private let expenses = "Expenses"
    private let username = "username"
    
    func getCurrentUserName(completion: @escaping (String?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("User is not found")
            completion(nil)
            return
        }
        
        let ref = Firestore.firestore().collection("users").document(currentUserUID)
        ref.getDocument { snapshot, error in
            if let snapshot = snapshot, let userData = snapshot.data(), let name = userData[self.username] as? String {
                completion(name)
            } else {
                completion(nil)
            }
        }
        
    }
    
    func fetchTransactionData(completion: @escaping ([TransactionModel]?) -> Void) {
        var transactionData: [TransactionModel] = []
        
        let db = Firestore.firestore()
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("User is not found")
            completion(nil)
            return
        }
        
        // Example query to retrieve data from the "Incomes" collection
        db.collection("users").document(currentUserUID).collection(transactions).order(by: "date").getDocuments { [weak self] (querySnapshot, error) in
            guard self != nil else { return }
            
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil)
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
                
                completion(transactionData)
            }
        }
    }
    
    func fetchLastMonthTransactionData(completion: @escaping ([TransactionModel]?) -> Void) {
        var transactionData: [TransactionModel] = []
        //Check if user is registered
        let db = Firestore.firestore()
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("User is not found")
            completion(nil)
            return
        }
        
        // Calculate the start and end date for the last month
        let currentDate = Date()
        let lastMonthStartDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate)!
        let lastMonthEndDate = currentDate
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
        
        db.collection("users").document(currentUserUID).collection(transactions).order(by: "date")
            .getDocuments { [weak self] (querySnapshot, error) in
                guard self != nil else { return }
                
                if let error = error {
                    print("Error getting documents: \(error)")
                    completion(nil)
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
    
                    completion(lastMonthTransactions)
                }
            }
    }
}
