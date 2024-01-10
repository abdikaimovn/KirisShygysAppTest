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
    private let networkService: TransactionPresenterService
    
    init (service: TransactionPresenterService) {
        self.networkService = service
    }
    
    func didReceiveTransactionData(transactionData: TransactionModel) {
        networkService.insertNewTransaction(transactionData: transactionData) { result in
            switch result {
            case .success():
                return
            case .failure(let error):
                self.view?.showError(with: error)
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

