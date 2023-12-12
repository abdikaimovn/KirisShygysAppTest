//
//  AuthorizationPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 09.10.2023.
//

import Foundation

protocol AuthViewProtocol: AnyObject {
    func didFail(with error: Error)
    func didSuccess()
}

final class AuthorizationPresenter {
    weak var view: AuthViewProtocol?
    
    public func authorize(with data: AuthorizationModel) {
        AuthService.shared.signIn(with: data) { error in
            if let error = error {
                self.view?.didFail(with: error)
                return
            }
            
            self.view?.didSuccess()
        }
    }
    
    func didSignIn(with data: AuthorizationModel) {
        self.authorize(with: data)
    }
    
}
