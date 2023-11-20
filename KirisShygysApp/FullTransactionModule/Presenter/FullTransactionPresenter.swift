//
//  FullTransactionPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 19.11.2023.
//

import Foundation

protocol FullTransactionViewControllerDelegate: AnyObject {
    func didReceiveFilterSettings(_ filterSettings: FilterModel, transactionData: [TransactionModel])
}

protocol FullTransactionPresenterDelegate: AnyObject {
    func didFilteredTransactionData(filteredData: [TransactionModel])
}

class FullTransactionPresenter {
    weak var delegate: FullTransactionPresenterDelegate?
    
    init(delegate: FullTransactionPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    private func didApplyFilter(filterSettings: FilterModel, transactionData: [TransactionModel]) {
        var resultOfFilteredData = transactionData
        
        if let filterBy = filterSettings.filterBy {
            resultOfFilteredData = applyFilterBy(filterBy: filterBy, transactionData: resultOfFilteredData)
        }
        
        if let sortBy = filterSettings.sortBy {
            resultOfFilteredData = applySortBy(sortBy: sortBy, transactionData: resultOfFilteredData)
        }
        
        if let period = filterSettings.period {
            resultOfFilteredData = applyTransactionsByPeriod(period: period, transactionData: resultOfFilteredData)
        }
        
        self.delegate?.didFilteredTransactionData(filteredData: resultOfFilteredData)
    }
    
    private func applySortBy(sortBy: SortByEnum, transactionData: [TransactionModel]) -> [TransactionModel] {
        var sortedTransactionData = [TransactionModel]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        switch sortBy {
        case .highest:
            sortedTransactionData = transactionData.sorted(by: { $0.transactionAmount > $1.transactionAmount })
        case .lowest:
            sortedTransactionData = transactionData.sorted(by: { $0.transactionAmount < $1.transactionAmount })
        case .newest:
            sortedTransactionData = transactionData.sorted(by: {
                guard let date1 = dateFormatter.date(from: $0.transactionDate),
                      let date2 = dateFormatter.date(from: $1.transactionDate) else {
                    return false
                }
                return date1 > date2
            })
        case .oldest:
            sortedTransactionData = transactionData.sorted(by: {
                guard let date1 = dateFormatter.date(from: $0.transactionDate),
                      let date2 = dateFormatter.date(from: $1.transactionDate) else {
                    return false
                }
                return date1 < date2
            })
        }
        
        return sortedTransactionData
    }

    private func applyTransactionsByPeriod(period: PeriodEnum?, transactionData: [TransactionModel]) -> [TransactionModel] {
        var sortedTransactionData = [TransactionModel]()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        // Function to check if a transaction falls within the specified period
        func isTransactionInPeriod(_ transaction: TransactionModel, periodStartDate: Date, periodEndDate: Date) -> Bool {
            guard let transactionDate = dateFormatter.date(from: transaction.transactionDate) else {
                return false
            }
            return transactionDate >= periodStartDate && transactionDate <= periodEndDate
        }
        
        // Filter transactions based on the specified period
        var filteredTransactions: [TransactionModel]
        if let period = period {
            let currentDate = Date()
            var periodStartDate: Date
            var periodEndDate: Date
            
            switch period {
            case .week:
                periodStartDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate) ?? currentDate
            case .month:
                periodStartDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
            case .halfyear:
                periodStartDate = Calendar.current.date(byAdding: .month, value: -6, to: currentDate) ?? currentDate
            case .year:
                periodStartDate = Calendar.current.date(byAdding: .year, value: -1, to: currentDate) ?? currentDate
            }
            
            periodEndDate = currentDate
            
            filteredTransactions = transactionData.filter { isTransactionInPeriod($0, periodStartDate: periodStartDate, periodEndDate: periodEndDate) }
        } else {
            // If no specific period is specified, include all transactions
            filteredTransactions = transactionData
        }
        
        // Include any additional logic needed for sorting or processing the filtered transactions
        
        return filteredTransactions
    }

    
    private func applyFilterBy(filterBy: TransactionType, transactionData: [TransactionModel]) -> [TransactionModel] {
        var filteredTransactionData = [TransactionModel]()
        
        switch filterBy {
        case .income:
            for transaction in transactionData {
                if transaction.transactionType == .income {
                    filteredTransactionData.append(transaction)
                }
            }
        case .expense:
            for transaction in transactionData {
                if transaction.transactionType == .expense {
                    filteredTransactionData.append(transaction)
                }
            }
        }
        
        return filteredTransactionData
    }
}

extension FullTransactionPresenter: FullTransactionViewControllerDelegate {
    func didReceiveFilterSettings(_ filterSettings: FilterModel, transactionData: [TransactionModel]) {
        didApplyFilter(filterSettings: filterSettings , transactionData: transactionData)
    }
}
