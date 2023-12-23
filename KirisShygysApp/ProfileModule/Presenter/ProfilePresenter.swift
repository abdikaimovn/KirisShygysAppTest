import Foundation

protocol ProfileViewProtocol: AnyObject {
    func setUsername(_ name: String)
    func showTransactionReport(with transactionData: [TransactionModel])
    func showLoader()
    func hideLoader()
    func showLogoutError(with model: ErrorModel)
    func showAbsenseDataError()
    func showReportError(with model: ErrorModel)
    func showStatistics()
    func showUnknownError(with model: ErrorModel)
    func showStatisticsError()
    func logOut()
}

final class ProfilePresenter {
    weak var view: ProfileViewProtocol?
    
    private let service: AuthServiceProfileProtocol
    private let userManager: UserProfileProtocol
    
    init(service: AuthServiceProfileProtocol, userManager: UserProfileProtocol) {
        self.service = service
        self.userManager = userManager
    }
    
    func viewDidLoaded() {
        view?.showLoader()
        userManager.fetchCurrentUsername { [weak self] result in
            self?.view?.hideLoader()
            
            switch result {
            case .success(let username):
                self?.view?.setUsername(username)
            case .failure(let error):
                self?.view?.showUnknownError(with: ErrorModel(error: error))
            }
        }
    }
    
    func reportTransactionDidTapped() {
        view?.showLoader()
        userManager.fetchLastMonthTransactionData { [weak self] result in
            self?.view?.hideLoader()
            switch result {
            case .success(let transactionData):
                if !transactionData.isEmpty {
                    self?.view?.showTransactionReport(with: transactionData)
                } else {
                    self?.view?.showAbsenseDataError()
                }
            case .failure(let error):
                switch error {
                case .gettingDocumentError(let error):
                    self?.view?.showReportError(with: ErrorModel(error: error))
                case .userNotFoundError:
                    self?.view?.showReportError(with: ErrorModel(error: error))
                }
            }
        }
    }
    
    func statisticsDidTapped() {
        view?.showLoader()
        view?.showStatistics()
        view?.hideLoader()
    }
    
    func logOutDidTapped() {
        view?.showLoader()
        
        service.signOut { [weak self] error in
            self?.view?.hideLoader()
            if let error = error {
                let model = ErrorModel(error: error)
                self?.view?.showLogoutError(with: model)
                return
            }
            
            self?.view?.logOut()
        }
    }
    
    deinit {
        print("Profile Presenter deinit")
    }
}
