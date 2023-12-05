import Foundation
import FirebaseFirestore

protocol HomePresenterDelegate: AnyObject {
    func setUsername(username: String)
    func didReceiveTransactionData(data: [TransactionModel])
    func showLoader()
    func hideLoader()
}

class HomePresenter {
    weak var view: HomePresenterDelegate?
    private let userManager: UserInfoProtocol
    
    init(userManager: UserInfoProtocol) {
        self.userManager = userManager
    }
    
    deinit {
        print("HomePresenter was deinited")
    }
    
    func setUsername() {
        UserDataManager.shared.getCurrentUserName {[weak self] username in
            self?.view?.setUsername(username: username ?? "Couldn't receive username")
        }
    }
    
    func updateView() {
        view?.showLoader()
        UserDataManager.shared.fetchTransactionData {[weak self] transactionData in
            self?.view?.hideLoader()
            if let transactionData = transactionData {
                self?.view?.didReceiveTransactionData(data: transactionData)
            }
        }
    }
    
    func viewDidLoaded() {
        view?.showLoader()
        setUsername()
        UserDataManager.shared.fetchTransactionData {[weak self] transactionData in
            self?.view?.hideLoader()
            if let transactionData = transactionData {
                self?.view?.didReceiveTransactionData(data: transactionData)
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
