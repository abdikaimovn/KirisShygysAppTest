//
//  StatisticsPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 21.12.2023.
//

import Foundation
import DGCharts
import UIKit

protocol StatisticsViewProtocol: AnyObject {
    func setupChart(with model: ChartModel)
    func updateView(with color: UIColor)
    func setupMoneyFlow(with moneyFlowModel: [FlowModel])
    func showAbsenceDataView(withColor color: UIColor)
}

final class StatisticsPresenter {
    weak var view: StatisticsViewProtocol?
    
    func setChart(with transactionData: [TransactionModel], and index: Int) {
        let type: TransactionType = index == 0 ? .income : .expense

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: endDate)!
        
        var groupedTransactions = [String: Int]()
        var countOfTransactionType = 0
        for i in transactionData {
            if type == i.transactionType {
                let transactionDate = String(i.transactionDate.prefix(10))
                
                if let transactionValue = groupedTransactions[transactionDate] {
                    groupedTransactions[transactionDate] = transactionValue + i.transactionAmount
                } else {
                    groupedTransactions[transactionDate] = i.transactionAmount
                }
                countOfTransactionType += 1
            }
        }
        
        guard countOfTransactionType != 0 else {
            let color = type == .income ? UIColor.shared.IncomeColor : UIColor.shared.ExpenseColor
            view?.showAbsenceDataView(withColor: color)
            return
        }
        
        var lastMonthDates = [String]()
        var currentDate = startDate
        
        while currentDate <= endDate {
            lastMonthDates.append(dateFormatter.string(from: currentDate))
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        var entries = [BarChartDataEntry]()
        for (index, element) in lastMonthDates.enumerated() {
            if let safeValue = groupedTransactions[element] {
                entries.append(BarChartDataEntry(x: Double(index), y: Double(safeValue)))
            } else {
                entries.append(BarChartDataEntry(x: Double(index), y: 0))
            }
        }
        
        let dataSet = BarChartDataSet(entries: entries)
        
        let xValues = lastMonthDates.map {
            "\($0.prefix(2))"
        }
        
        let chartColor = type == .income ? UIColor.shared.IncomeColor : UIColor.shared.ExpenseColor
        dataSet.setColor(chartColor)
        view?.setupChart(with: ChartModel(xAxisTitles: xValues, chartData: dataSet))
        view?.updateView(with: chartColor)
    }
    
    func setMoneyFlow(with transactionData: [TransactionModel]) {
        var incomes = 0
        var expenses = 0
        var total = 0
        
        for transaction in transactionData {
            let transactionType = transaction.transactionType
            let transactionAmount = transaction.transactionAmount
            
            switch transactionType {
            // Counting expenses and total
            case .expense:
                expenses += transactionAmount
                total -= transactionAmount
            // Counting incomes and total
            case .income:
                incomes += transactionAmount
                total += transactionAmount
            }
            
        }
        
        var flowModel = [FlowModel]()
        flowModel.append(FlowModel(value: incomes, flowImage: .income))
        flowModel.append(FlowModel(value: expenses, flowImage: .expense))
        flowModel.append(FlowModel(value: total, flowImage: .total))
        
        view?.setupMoneyFlow(with: flowModel)
    }
}
