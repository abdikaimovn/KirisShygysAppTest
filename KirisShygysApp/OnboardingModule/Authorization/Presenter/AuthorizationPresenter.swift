//
//  AuthorizationPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 09.10.2023.
//

import Foundation

protocol AuthorizationViewProtocol: AnyObject {
    func showAuthorizationError(with error: ErrorModelInfo)
    func checkAuthentication()
    func showLoader()
    func hideLoader()
    func showInvalidEmailError()
    func showInvalidPasswordError()
}

final class AuthorizationPresenter {
    weak var view: AuthorizationViewProtocol?
    private let authorizationService: AuthorizationServiceProtocol
    
    init(authorizationService: AuthorizationServiceProtocol) {
        self.authorizationService = authorizationService
    }
    
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
        authorizationService.authorizeUser(with: data) {[weak self] result in
            self?.view?.hideLoader()
            
            switch result {
            case .success():
                self?.view?.checkAuthentication()
            case .failure(let errorModel):
                self?.view?.showAuthorizationError(with: errorModel)
            }
        }
    }
    
}
