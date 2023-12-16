import Foundation
import FirebaseFirestore

protocol HomeViewProtocol: AnyObject {
    func setUsername(username: String)
    func updateTransactionsData(data: [TransactionModel])
    func showLoader()
    func hideLoader()
    func pushAllTransactionsView()
    func showAbsenseDataAlert()
    func updateCardViewValues(cardViewModel: CardViewModel)
}

final class HomePresenter {
    weak var view: HomeViewProtocol?
    private let userManager: UserInfoProtocol
    
    init(userManager: UserInfoProtocol) {
        self.userManager = userManager
    }
    
    deinit {
        print("HomePresenter was deinited")
    }
    
    func updateView() {
        view?.showLoader()
        userManager.fetchTransactionData {[weak self] transactionData in
            self?.view?.hideLoader()
            if let transactionData = transactionData {
                self?.view?.updateTransactionsData(data: transactionData)
            }
        }
    }
    
    func viewDidLoaded() {
        view?.showLoader()
        
        userManager.getCurrentUserName {[weak self] username in
            self?.view?.setUsername(username: username ?? "Couldn't receive username")
        }
        
        userManager.fetchTransactionData {[weak self] transactionData in
            self?.view?.hideLoader()
            if let transactionData = transactionData {
                self?.view?.updateTransactionsData(data: transactionData)
            }
        }
    }
    
    func showAllTrasactionsTapped(data: [TransactionModel]) {
        if data.isEmpty {
            view?.showAbsenseDataAlert()
        } else {
            view?.pushAllTransactionsView()
        }
    }
    
    func calculateCardViewValues(data: [TransactionModel]?) {
        if let data = data {
            var incomes = 0
            var expenses = 0
            var total = 0
            
            for transaction in data {
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
            
            view?.updateCardViewValues(cardViewModel: CardViewModel(incomes: incomes, expenses: expenses, total: total))
        }
    }
}
