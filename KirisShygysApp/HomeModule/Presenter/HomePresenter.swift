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
}

extension HomePresenter: HomeViewControllerDelegate {
    
}
