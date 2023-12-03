//
//  ReportPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 29.11.2023.
//

import Foundation

protocol ReportPresenterDelegate: AnyObject {
    func didCalculateTransactionData(_ incomeInfo: ReportInfo, _ expenseInfo: ReportInfo)
}

class ReportPresenter {
    weak var delegate: ReportPresenterDelegate?
    
    init(delegate: ReportPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func calculateData(transactionData: [TransactionModel]) {
        var incomeSumma = 0
        var expenseSumma = 0
        var maxIncome = Int.min
        var maxExpense = Int.min
        var maxIncomeTitle = ""
        var maxExpenseTitle = ""
        
        for transaction in transactionData {
            if transaction.transactionType == .income {
                incomeSumma += transaction.transactionAmount
                if maxIncome < transaction.transactionAmount {
                    maxIncome = transaction.transactionAmount
                    maxIncomeTitle = transaction.transactionName
                }
            } else {
                expenseSumma += transaction.transactionAmount
                if maxExpense < transaction.transactionAmount {
                    maxExpense = transaction.transactionAmount
                    maxExpenseTitle = transaction.transactionName
                }
            }
        }
        
        var incomeInfo = ReportInfo(summa: incomeSumma, maxValue: maxIncome, maxValueTitle: maxIncomeTitle)
        
        var expenseInfo = ReportInfo(summa: expenseSumma, maxValue: maxExpense, maxValueTitle: maxExpenseTitle)
        
        self.delegate?.didCalculateTransactionData(incomeInfo, expenseInfo)
    }
}
