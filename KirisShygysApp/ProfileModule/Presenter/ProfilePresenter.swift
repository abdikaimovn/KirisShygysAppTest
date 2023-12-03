import Foundation

protocol ProfilePresenterDelegate: AnyObject {
    func didReceiveUsername(name: String)
    func didReceiveUserTransactionReport(_ transactionData: [TransactionModel]?)
}

protocol ProfileViewControllerDelegate: AnyObject {
    
}

class ProfilePresenter {
    weak var delegate: ProfilePresenterDelegate?
    
    init(delegate: ProfilePresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func getUsername() {
        UserDataManager.shared.getCurrentUserName { username in
            self.delegate?.didReceiveUsername(name: username ?? "Couldn't receive username")
        }
    }
    
    func receiveUserTransactionReport() {
        UserDataManager.shared.fetchLastMonthTransactionData { transactionData in
            self.delegate?.didReceiveUserTransactionReport(transactionData)
        }
    }
    
    deinit {
        print("Profile Presenter deinit")
    }
}

extension ProfilePresenter: ProfileViewControllerDelegate {

}
