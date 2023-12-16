//
//  ReportPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 29.11.2023.
//

import Foundation

protocol ReportViewProtocol: AnyObject {
    func didCalculateTransactionData(_ incomeInfo: ReportInfo, _ expenseInfo: ReportInfo)
}

final class ReportPresenter {
    weak var view: ReportViewProtocol?
    
    func calculateData(transactionData: [TransactionModel]) {
        var incomeSum = 0
        var expenseSum = 0
        var maxIncome = 0
        var maxExpense = 0
        var maxIncomeTitle = "Null"
        var maxExpenseTitle = "Null"
        
        for transaction in transactionData {
            if transaction.transactionType == .income {
                incomeSum += transaction.transactionAmount
                if maxIncome < transaction.transactionAmount {
                    maxIncome = transaction.transactionAmount
                    maxIncomeTitle = transaction.transactionName
                }
            } else {
                expenseSum += transaction.transactionAmount
                if maxExpense < transaction.transactionAmount {
                    maxExpense = transaction.transactionAmount
                    maxExpenseTitle = transaction.transactionName
                }
            }
        }
        
        let incomeInfo = ReportInfo(summa: incomeSum, maxValue: maxIncome, maxValueTitle: maxIncomeTitle)
        
        let expenseInfo = ReportInfo(summa: expenseSum, maxValue: maxExpense, maxValueTitle: maxExpenseTitle)
        
        self.view?.didCalculateTransactionData(incomeInfo, expenseInfo)
    }
}
