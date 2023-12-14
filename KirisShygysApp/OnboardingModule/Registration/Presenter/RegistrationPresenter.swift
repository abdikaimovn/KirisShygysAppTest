import Foundation

protocol RegistrationViewProtocol: AnyObject {
    func checkAuthentication(answer: Bool)
    func showRegistrationError(with error: Error)
    func showInvalidEmailError() 
    func showInvalidUsernameError()
    func showInvalidPasswordError()
    func showLoader()
    func hideLoader()
}

final class RegistrationPresenter {
    weak var view: RegistrationViewProtocol?
    
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
        AuthService.shared.registerUser(with: data) { wasRegistered, error in
            self.view?.hideLoader()
            
            if let error = error {
                self.view?.showRegistrationError(with: error)
                return
            }
            
            if wasRegistered {
                self.view?.checkAuthentication(answer: true)
            } else {
                self.view?.checkAuthentication(answer: false)
            }
        }

    }
}
