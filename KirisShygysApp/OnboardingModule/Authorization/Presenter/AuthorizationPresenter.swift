//
//  AuthorizationPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 09.10.2023.
//

import Foundation

protocol AuthorizationViewProtocol: AnyObject {
    func showAuthorizationError(with error: Error)
    func checkAuthentication()
    func showLoader()
    func hideLoader()
    func showInvalidEmailError()
    func showInvalidPasswordError()
}

final class AuthorizationPresenter {
    weak var view: AuthorizationViewProtocol?
    
    func signInButtonPressed(with data: AuthorizationModel) {
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
        AuthService.shared.signIn(with: data) { error in
            self.view?.hideLoader()
            
            if let error = error {
                self.view?.showAuthorizationError(with: error)
                return
            }
            
            self.view?.checkAuthentication()
        }
    }
    
}
