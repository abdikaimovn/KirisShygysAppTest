//
//  StatisticsPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 21.12.2023.
//

import Foundation

protocol StatisticsViewProtocol: AnyObject {
    func showLoader()
    func hideLoader()
    
}

final class StatisticsPresenter {
    weak var view: StatisticsViewProtocol?
    
    func setupInitialChart(with data: [TransactionModel]) {
        
    }
}
