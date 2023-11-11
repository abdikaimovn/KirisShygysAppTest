//
//  TransactionPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 11.11.2023.
//

import Foundation
import UIKit
import Firebase

protocol TransactionViewControllerDelegate: AnyObject{
    func didReceiveTransactionData(transactionData: TransactionModel)
}

protocol TransactionPresenterDelegate: AnyObject {
    
}

class TransactionPresenter {
    weak var delegate: TransactionPresenterDelegate?
    
    init(delegate: TransactionPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    deinit {
        print("TransactionPresenter was deinited")
    }
}

extension TransactionPresenter: TransactionViewControllerDelegate {
    func didReceiveTransactionData(transactionData: TransactionModel) {
        let db = Firestore.firestore()
        
        let collectionName: String
        switch transactionData.transactionType {
        case .income:
            collectionName = "Incomes"
        case .expense:
            collectionName = "Expenses"
        }
        
        let transactionData: [String: Any] = [
            "name": transactionData.transactionName,
            "type": collectionName,
            "description": transactionData.transactionDescription,
            "amount": transactionData.transactionAmount,
            "date": transactionData.transactionDate
        ]
        
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection(collectionName)
            .addDocument(data: transactionData) { error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
            }
        
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection("Transactions")
            .addDocument(data: transactionData) { error in
                if let error = error {
                    print("ERROR: \(error.localizedDescription)")
                    return
                }
            }
    }
}


