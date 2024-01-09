import Foundation
import FirebaseFirestore

protocol HomeViewProtocol: AnyObject {
    func setUsername(username: String)
    func updateTransactionsData(with data: [TransactionModel])
    func showLoader()
    func hideLoader()
    func pushAllTransactionsView()
    func showAbsenseDataAlert()
    func updateCardViewValues(cardViewModel: CardViewModel)
    func showUnknownError(with model: ErrorModel)
    func showUpdatingError(with error: Error)
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
        userManager.fetchTransactionData {[weak self] result in
            self?.view?.hideLoader()
            
            switch result {
            case .success(let transactionData):
                self?.view?.updateTransactionsData(with: transactionData)
            case .failure(let error):
                switch error {
                case .gettingDocumentError(let error):
                    self?.view?.showUpdatingError(with: error)
                case .userNotFoundError:
                    self?.view?.showUpdatingError(with: error)
                }
            }
        }
    }
    
    func viewDidLoaded() {
        view?.showLoader()
        
        userManager.fetchCurrentUsername { [weak self] result in
            switch result {
            case .success(let username):
                self?.view?.setUsername(username: username)
            case .failure(let failure):
                switch failure {
                case .userNotFound:
                    self?.view?.setUsername(username: "Error")
                case .customError(let error):
                    self?.view?.showUnknownError(with: ErrorModel(error: error))
                }
            }
        }
        
        userManager.fetchTransactionData {[weak self] result in
            self?.view?.hideLoader()
            
            switch result {
            case .success(let transactionData):
                self?.view?.updateTransactionsData(with: transactionData)
            case .failure(let error):
                self?.view?.showUpdatingError(with: error)
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
