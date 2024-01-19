//
//  Network.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 12.10.2023.
//

import FirebaseAuth
import FirebaseFirestore

protocol ProfileServiceProtocol {
    func signOut(completion: @escaping (Result<(), ErrorModelInfo>) -> ())
}

protocol RegistrationServiceProtocol: AnyObject {
    func registerUser(with user: RegistrationModel, completion: @escaping (Result<(), ErrorModelInfo>) -> ())
}

protocol AuthorizationServiceProtocol: AnyObject {
    func authorizeUser(with user: AuthorizationModel, completion: @escaping (Result<(), ErrorModelInfo>) -> ())
}

final class AuthService: ProfileServiceProtocol, RegistrationServiceProtocol, AuthorizationServiceProtocol {
    static let shared = AuthService()
    
    public func registerUser(with user: RegistrationModel, completion: @escaping (Result<(), ErrorModelInfo>) -> ()) {
        
        let username = user.name
        let email = user.email
        let password = user.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                let errorCode = AuthErrorCode(_nsError: error as NSError)
                print(errorCode)
                switch errorCode.code {
                case .emailAlreadyInUse:
                    completion(.failure(ErrorModelInfo(title: NSLocalizedString("registration_error_title", comment: ""),
                                                       error: error,
                                                       text: error.localizedDescription,
                                                       localizedDescription: NSLocalizedString("credentialAlreadyInUse_error", comment: ""))))
                case .networkError:
                    completion(.failure(ErrorModelInfo(
                        title: NSLocalizedString("registration_error_title", comment: ""),
                        error: error,
                        text: error.localizedDescription,
                        localizedDescription: NSLocalizedString(RegistrationError.networkError.rawValue,
                                                                comment: ""))))
                default:
                    completion(.failure(ErrorModelInfo(
                        title: NSLocalizedString("registration_error_title", comment: ""),
                        error: error,
                        text: error.localizedDescription,
                        localizedDescription: NSLocalizedString(RegistrationError.unknownError.rawValue,
                                                                comment: ""))))
                }
                return
            }
            
            guard let resultUser = result?.user else {
                completion(.failure(ErrorModelInfo(title: NSLocalizedString("registration_error_title", comment: ""),
                                                   error: nil,
                                                   text: nil,
                                                   localizedDescription: NSLocalizedString(RegistrationError.unknownError.rawValue, comment: ""))))
                return
            }
            
            let db = Firestore.firestore()
            db.collection(DocumentTypeName.users.rawValue)
                .document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email
                ]) { error in
                    if let error = error {
                        completion(.failure(ErrorModelInfo(title: NSLocalizedString("registration_error_title", comment: ""),
                                                           error: error,
                                                           text: error.localizedDescription,
                                                           localizedDescription: NSLocalizedString(RegistrationError.unknownError.rawValue, comment: ""))))
                        return
                    }
                    
                    completion(.success(()))
                }
        }
    }
    
    //So far this function doesn't work and not in use anywhere
    public func changeUsername(with newUsername: String, completion: @escaping (Result<(), Error>) -> ()) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(NSError(domain: "AuthService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
            return
        }
        
        let newUsername = newUsername
        
        // Update the username in Firestore
        let db = Firestore.firestore()
        db.collection(DocumentTypeName.users.rawValue)
            .document(currentUser.uid)
            .updateData(["username": newUsername]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    public func authorizeUser(with user: AuthorizationModel, completion: @escaping (Result<(), ErrorModelInfo>) -> ()) {
        let email = user.email
        let password = user.password
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                let errorCode = AuthErrorCode(_nsError: error as NSError)
                switch errorCode.code {
                case .invalidCredential:
                    completion(.failure(ErrorModelInfo(
                        title: NSLocalizedString("authorization_error", comment: ""),
                        error: error,
                        text: error.localizedDescription,
                        localizedDescription: NSLocalizedString(AuthorizationError.invalidCredential.rawValue,
                                                                comment: ""))))
                case .networkError:
                    completion(.failure(ErrorModelInfo(
                        title: NSLocalizedString("authorization_error", comment: ""),
                        error: error,
                        text: error.localizedDescription,
                        localizedDescription: NSLocalizedString(AuthorizationError.networkError.rawValue,
                                                                comment: ""))))
                default:
                    completion(.failure(ErrorModelInfo(
                        title: NSLocalizedString("authorization_error", comment: ""),
                        error: error,
                        text: error.localizedDescription,
                        localizedDescription: NSLocalizedString(AuthorizationError.unknownError.rawValue,
                                                                comment: ""))))
                }
            } else {
                completion(.success(()))
            }
        }
    }
    
    public func signOut(completion: @escaping (Result<(), ErrorModelInfo>) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(ErrorModelInfo(title: NSLocalizedString("authorization_error_title", comment: ""),
                                               error: error,
                                               text: error.localizedDescription,
                                               localizedDescription: AuthorizationError.unknownError.rawValue)))
        }
    }
}
