//
//  TransactionPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 11.11.2023.
//

import Foundation
import UIKit
import Firebase

protocol TransactionViewProtocol: AnyObject {
    func showError(with error: ErrorModel)
    func updateViewColors(with color: UIColor)
}

final class TransactionPresenter {
    weak var view: TransactionViewProtocol?
    
    deinit {
        print("TransactionPresenter was deinited")
    }
}

// Implemating view's methods
extension TransactionPresenter {
    func didReceiveTransactionData(transactionData: TransactionModel) {
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
        
        // Добавьте транзакцию в коллекцию "Incomes" или "Expenses"
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection(collectionName)
            .document(transactionId) // Используйте уникальный идентификатор как документ
            .setData(transactionDataDict) { [weak self] error in
                if let error = error {
                    self?.view?.showError(with: ErrorModel(error: error))
                    return
                }
            }
        
        // Добавьте транзакцию в коллекцию "Transactions"
        db.collection("users")
            .document(Auth.auth().currentUser!.uid)
            .collection("Transactions")
            .document(transactionId) // Используйте уникальный идентификатор как документ
            .setData(transactionDataDict) { [weak self] error in
                if let error = error {
                    self?.view?.showError(with: ErrorModel(error: error))
                    return
                }
            }
    }
    
    
    func segmentedControlChosen(index: Int) {
        if index == 0 {
            view?.updateViewColors(with: UIColor.shared.IncomeColor)
        } else {
            view?.updateViewColors(with: UIColor.shared.ExpenseColor)
        }
    }
}


