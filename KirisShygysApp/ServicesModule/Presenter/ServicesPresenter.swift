import Foundation

protocol ServicesViewProtocol: AnyObject {
    func showTransactionReport(with transactionData: [TransactionModel])
    func showStatistics(with transactionData: [TransactionModel])
    func showSettings()
    func logOut()
    func showLoader()
    func hideLoader()
    func showLogoutError(with model: ErrorModel)
    func showReportError(with model: ErrorModel)
    func showUnknownError(with model: ErrorModel)
    func showReportAbsenceDataAlert(with model: ErrorModelInfo)
    func showStatisticsAbsenceDataAlert(with model: ErrorModelInfo)
}

final class ServicesPresenter {
    weak var view: ServicesViewProtocol?
    
    private let profileAuthService: ProfileServiceProtocol
    private let userManager: UserProfileProtocol
    
    init(profileAuthService: ProfileServiceProtocol, userManager: UserProfileProtocol) {
        self.profileAuthService = profileAuthService
        self.userManager = userManager
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
                    self?.view?.showReportAbsenceDataAlert(with:
                                                        ErrorModelInfo(title: nil,
                                                                       error: nil,
                                                                       text: nil,
                                                                       localizedDescription: "reportLackDataAlert_message".localized))
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
                    self?.view?.showStatisticsAbsenceDataAlert(with: 
                                                        ErrorModelInfo(title: nil,
                                                                       error: nil,
                                                                       text: nil,
                                                                       localizedDescription: "statisticsLackDataAlert_message".localized))
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
