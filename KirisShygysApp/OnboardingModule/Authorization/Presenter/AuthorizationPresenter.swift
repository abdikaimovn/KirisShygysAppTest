//
//  AuthorizationPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 09.10.2023.
//

import Foundation

protocol AuthVCDelegate: AnyObject {
    func didSignIn(with data: AuthorizationModel)
}

protocol AuthPresenterDelegate: AnyObject {
    func didFail(with error: Error)
    func didSuccess()
}

class AuthorizationPresenter {
    var delegate: AuthPresenterDelegate?
    
    init(delegate: AuthPresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    public func authorize(with data: AuthorizationModel) {
        AuthService.shared.signIn(with: data) { error in
            if let error = error {
                self.delegate?.didFail(with: error)
                return
            }
            
            self.delegate?.didSuccess()
        }
    }
    
}

extension AuthorizationPresenter: AuthVCDelegate {
    func didSignIn(with data: AuthorizationModel) {
        self.authorize(with: data)
    }
}
