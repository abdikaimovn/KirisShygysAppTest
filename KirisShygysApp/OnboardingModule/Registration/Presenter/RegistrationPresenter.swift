import Foundation

protocol RegistrationViewProtocol: AnyObject {
    func checkAuthentication()
    func showRegistrationError(with error: Error)
    func showInvalidEmailError() 
    func showInvalidUsernameError()
    func showInvalidPasswordError()
    func showLoader()
    func hideLoader()
}

final class RegistrationPresenter {
    weak var view: RegistrationViewProtocol?
    private let registrationService: RegistrationServiceProtocol
    
    init(service: RegistrationServiceProtocol) {
        self.registrationService = service
    }
    
    func signUpPressed(with data: RegistrationModel) {
        
        //Username check
        if !Validator.isValidUsername(for: data.name) {
            view?.showInvalidUsernameError()
            return
        }
        
        //Email check
        if !Validator.isValidEmail(for: data.email) {
            view?.showInvalidEmailError()
            return
        }
        
        //Password check
        if !Validator.isValidPassword(for: data.password) {
            view?.showInvalidPasswordError()
            return
        }
        
        view?.showLoader()
        registrationService.registerUser(with: data) {[weak self] result in
            self?.view?.hideLoader()
            
            switch result {
            case .success():
                self?.view?.checkAuthentication()
            case .failure(let error):
                self?.view?.showRegistrationError(with: error)
            }
        }

    }
}
