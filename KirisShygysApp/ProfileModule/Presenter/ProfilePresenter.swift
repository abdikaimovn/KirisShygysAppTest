import Foundation

protocol ProfileViewProtocol: AnyObject {
    func setUsername(_ name: String)
    func showTransactionReport(with transactionData: [TransactionModel])
    func showStatistics(with transactionData: [TransactionModel])
    func showSettings()
    func logOut()
    func showLoader()
    func hideLoader()
    func showLogoutError(with model: ErrorModel)
    func showReportError(with model: ErrorModel)
    func showUnknownError(with model: ErrorModel)
    func showAbsenseDataError()
    func showStatisticsError()
}

final class ProfilePresenter {
    weak var view: ProfileViewProtocol?
    
    private let profileAuthService: ProfileServiceProtocol
    private let userManager: UserProfileProtocol
    
    init(profileAuthService: ProfileServiceProtocol, userManager: UserProfileProtocol) {
        self.profileAuthService = profileAuthService
        self.userManager = userManager
    }
    
    func viewDidLoaded() {
        view?.showLoader()
        userManager.fetchCurrentUsername { [weak self] result in
            self?.view?.hideLoader()
            switch result {
            case .success(let username):
                self?.view?.setUsername(username)
            case .failure(let failure):
                switch failure {
                case .userNotFound:
                    self?.view?.setUsername("Error")
                case .customError(let error):
                    self?.view?.showUnknownError(with: ErrorModel(error: error))
                }
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
        userManager.fetchLastMonthTransactionData { [weak self] result in
            self?.view?.hideLoader()
            
            switch result {
            case .success(let transactionData):
                if !transactionData.isEmpty {
                    self?.view?.showStatistics(with: transactionData)
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
    
    func settingsDidTapped() {
        view?.showSettings()
    }
    
    func logOutDidTapped() {
        view?.showLoader()
        
        profileAuthService.signOut { [weak self] result in
            self?.view?.hideLoader()
            
            switch result {
            case .success():
                self?.view?.logOut()
            case .failure(let error):
                let model = ErrorModel(error: error)
                self?.view?.showLogoutError(with: model)
            }
        }
    }
    
    deinit {
        print("Profile Presenter deinit")
    }
}
