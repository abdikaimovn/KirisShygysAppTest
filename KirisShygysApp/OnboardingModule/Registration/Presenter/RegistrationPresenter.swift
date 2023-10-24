//
//  RegistrationPresenter.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 09.10.2023.
//

import Foundation
//enum SignUpErrorType {
//    case
//}


class RegistrationPresenter {
    
}

extension RegistrationPresenter: RegistrationViewControllerDelegate {
    func didRegister(with data: RegistrationModel) {
        Network.shared.registerUser(with: data) { wasRegistered, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            Network.shared.signIn(with: AuthorizationModel(email: data.name, password: data.password)) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
            }
        }
    }
}
