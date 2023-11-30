//
//  UserDataManager.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 12.11.2023.
//

import Foundation
import Firebase

class UserDataManager {
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
        var transactionData: [TransactionModel]?
        
        let db = Firestore.firestore()
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            print("User is not found")
            completion(nil)
            return
        }
        
        // Example query to retrieve data from the "Incomes" collection
        db.collection("users").document(currentUserUID).collection(transactions).order(by: "date", descending: true).getDocuments { [weak self] (querySnapshot, error) in
            guard self != nil else { return }
            
            if let error = error {
                print("Error getting documents: \(error)")
                completion(nil)
            } else {
                let transactions = querySnapshot?.documents.compactMap { document in
                    return TransactionModel(data: document.data())
                } ?? []
                transactionData = transactions
                completion(transactionData)
            }
        }
    }
    
}
