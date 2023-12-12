import Foundation

final class RegistrationPresenter {
    weak var delegate: RegistrationPresenterDelegate?
    init(delegate: RegistrationPresenterDelegate? = nil) {
        self.delegate = delegate
    }
}

extension RegistrationPresenter: RegistrationViewControllerDelegate {
    func didRegister(with data: RegistrationModel) {
        AuthService.shared.registerUser(with: data) { wasRegistered, error in
            if let error = error {
                self.delegate?.didFail(with: error)
                return
            }
            
            if wasRegistered {
                self.delegate?.didCheckAuthorization(answer: true)
            } else {
                self.delegate?.didCheckAuthorization(answer: false)
            }
        }

    }
}
