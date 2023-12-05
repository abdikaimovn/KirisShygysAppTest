import Foundation

protocol ProfileViewProtocol: AnyObject {
    func setUsername(_ name: String)
    func didReceiveUserTransactionReport(_ transactionData: [TransactionModel]?)
    func showLoader()
    func hideLoader()
    func showError(with model: ErrorModel)
    func showReportError()
    func logOut()
}

class ProfilePresenter {
    weak var view: ProfileViewProtocol?
    
    private let service: AuthServiceProfileProtocol
    private let userManager: UserProfileProtocol
    
    init(service: AuthServiceProfileProtocol, userManager: UserProfileProtocol) {
        self.service = service
        self.userManager = userManager
    }
    
    func viewDidLoaded() {
        view?.showLoader()
        userManager.getCurrentUserName { [weak self] username in
            self?.view?.hideLoader()
            self?.view?.setUsername(username ?? "Couldn't receive username")
        }
    }
    
    func reportTransactionDidTapped() {
        view?.showLoader()
        UserDataManager.shared.fetchLastMonthTransactionData { [weak self] transactionData in
            self?.view?.hideLoader()
            if let safeTransactionData = transactionData, !safeTransactionData.isEmpty {
                self?.view?.didReceiveUserTransactionReport(safeTransactionData)
            } else {
                self?.view?.showReportError()
            }
        }
    }
    
    func logOutDidTapped() {
        view?.showLoader()
        
        service.signOut { [weak self] error in
            self?.view?.hideLoader()
            if let error = error {
                let model = ErrorModel(error: error)
                self?.view?.showError(with: model)
                return
            }
            
            self?.view?.logOut()
        }
    }
    
    deinit {
        print("Profile Presenter deinit")
    }
}

struct ErrorModel {
    let error: Error
    
    var text: String {
        error.localizedDescription
    }
}
