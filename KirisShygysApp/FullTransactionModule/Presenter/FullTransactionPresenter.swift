//
//  FullTransactionPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 19.11.2023.
//

import Foundation
import Firebase

protocol FullTransactionViewProtocol: AnyObject {
    func setupSectionsByDefault(_ groupedTransactions: [String: [TransactionModel]], _ sectionTitles: [SectionTitleModel])
    func setupFilteredSections(_ groupedSections: [String: [TransactionModel]], sectionTitles: [SectionTitleModel])
    func showLoader()
    func hideLoader()
    func showError(with model: ErrorModel)
}

final class FullTransactionPresenter {
    weak var view: FullTransactionViewProtocol?
    private let networkService: FullTransactionPresenterService
    
    init(service: FullTransactionPresenterService) {
        networkService = service
    }
    
    func deleteTransaction(with transactionData: TransactionModel) {
        networkService.deleteTransaction(transactionData: transactionData) { result in
            switch result {
            case .success():
                return
            case .failure(let error):
                self.view?.showError(with: ErrorModel(error: error))
            }
        }
    }
    
    private func applySortBy(sortBy: SortByEnum, transactionData: [TransactionModel]) -> [TransactionModel] {
        var sortedTransactionData = [TransactionModel]()
        
        switch sortBy {
        case .newest:
            sortedTransactionData = transactionData
        case .oldest:
            sortedTransactionData = transactionData.reversed()
        }
        
        return sortedTransactionData
    }
    
    private func applyTransactionsByPeriod(period: PeriodEnum?, transactionData: [TransactionModel]) -> [TransactionModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        // Function to check if a transaction falls within the specified period
        func isTransactionInPeriod(_ transaction: TransactionModel, periodStartDate: Date, periodEndDate: Date) -> Bool {
            guard let transactionDate = dateFormatter.date(from: String(transaction.transactionDate.prefix(10))) else {
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
            filteredTransactions = transactionData
        }
        
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

// Methods that uses the view of the presenter
extension FullTransactionPresenter {
    func identifySectionTitle(_ sectionTitle: String) -> String {
        switch sectionTitle {
        case Date.now.formatted().prefix(10):
            return "today_label".localized
        case Date().yesterday.formatted().prefix(10):
            return "yesterday_label".localized
        default:
            return sectionTitle
        }
    }
    
    func setFilteredSections(_ transactionData: [TransactionModel], _ filterModel: FilterModel) {
        view?.showLoader()
        
        var filteredTransactionData = transactionData
        
        if let filterBy = filterModel.filterBy {
            filteredTransactionData = applyFilterBy(filterBy: filterBy, transactionData: filteredTransactionData)
        }
        
        if let sortBy = filterModel.sortBy {
            filteredTransactionData = applySortBy(sortBy: sortBy, transactionData: filteredTransactionData)
        }
        
        if let period = filterModel.period {
            filteredTransactionData = applyTransactionsByPeriod(period: period, transactionData: filteredTransactionData)
        }
        
        let groupedTransactions: [String : [TransactionModel]] = Dictionary(
            grouping: filteredTransactionData,
            by: { String($0.transactionDate.prefix(10))})
        var sectionTitles = [SectionTitleModel]()
        var uniqueElementDate = Set<String>()
        for element in filteredTransactionData {
            if !uniqueElementDate.contains(String(element.transactionDate.prefix(10))) {
                sectionTitles.append(SectionTitleModel(fullDate: element.transactionDate))
            }
            uniqueElementDate.insert(String(element.transactionDate.prefix(10)))
        }
        
        view?.hideLoader()
        view?.setupFilteredSections(groupedTransactions, sectionTitles: sectionTitles)
    }
    
    func setSectionsByDefault(_ transactionData: [TransactionModel]) {
        view?.showLoader()
        let groupedTransactions: [String : [TransactionModel]] = Dictionary(
            grouping: transactionData,
            by: { String($0.transactionDate.prefix(10))})
        var sectionTitles = [SectionTitleModel]()
        var uniqueElementDate = Set<String>()
        for element in transactionData {
            if !uniqueElementDate.contains(String(element.transactionDate.prefix(10))) {
                sectionTitles.append(SectionTitleModel(fullDate: element.transactionDate))
            }
            uniqueElementDate.insert(String(element.transactionDate.prefix(10)))
        }
        
        view?.hideLoader()
        view?.setupSectionsByDefault(groupedTransactions, sectionTitles)
    }
}
