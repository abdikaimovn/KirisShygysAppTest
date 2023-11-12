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
    let userUID = Auth.auth().currentUser?.uid
    private let transactions = "Transactions"
    private let incomes = "Incomes"
    private let expenses = "Expenses"
    private let username = "username"
    
    func getCurrentUserName(completion: @escaping (String?) -> Void) {
        if let uid = userUID {
            let ref = Firestore.firestore().collection("users").document(uid)
            ref.getDocument { snapshot, error in
                if let snapshot = snapshot, let userData = snapshot.data(), let name = userData[self.username] as? String {
                    completion(name)
                } else {
                    completion(nil)
                }
            }
        } else {
            completion(nil)
        }
    }
    
    func fetchTransactionData(completion: @escaping ([TransactionModel]?) -> Void) {
        var transactionData: [TransactionModel]?

        let db = Firestore.firestore()
        guard let currentUserUID = userUID else {
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
