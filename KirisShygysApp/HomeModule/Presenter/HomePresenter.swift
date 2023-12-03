import Foundation
import FirebaseFirestore

protocol HomePresenterDelegate: AnyObject {
    func didReceiveUsername(name: String?)
    func didReceiveTransactionData(data: [TransactionModel]?)
}

protocol HomeViewControllerDelegate: AnyObject {
    
}

class HomePresenter {
    weak var delegate: HomePresenterDelegate?
    
    init(delegate: HomePresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    deinit {
        print("HomePresenter was deinited")
    }
    
    func getUsername() {
        UserDataManager.shared.getCurrentUserName { username in
            self.delegate?.didReceiveUsername(name: username)
        }
    }
    
    func receiveTransactionData() {
        UserDataManager.shared.fetchTransactionData { transactionData in
            if let transactionData = transactionData {
                self.delegate?.didReceiveTransactionData(data: transactionData)
            }
        }
    }
    
    func calculateAmount(data: [TransactionModel]?, trasnsactionType: TransactionType?) -> Int {
        if trasnsactionType == .income {
            var incomes = 0
            if let data = data {
                for i in data {
                    if i.transactionType == .income {
                        incomes += i.transactionAmount
                    }
                }
            }
            return incomes
        } else if trasnsactionType == .expense {
            var expenses = 0
            if let data = data {
                for i in data {
                    if i.transactionType == .expense {
                        expenses += i.transactionAmount
                    }
                }
            }
            return expenses
        } else {
            var totalAmount = 0
            if let data = data {
                for i in data {
                    if i.transactionType == .expense {
                        totalAmount -= i.transactionAmount
                    } else {
                        totalAmount += i.transactionAmount
                    }
                }
            }
            return totalAmount
        }
    }
}

extension HomePresenter: HomeViewControllerDelegate {
    
}
