//
//  Network.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 12.10.2023.
//

import FirebaseAuth
import FirebaseFirestore

protocol ProfileServiceProtocol {
    func signOut(completion: @escaping (Result<(), Error>) -> ())
}

protocol RegistrationServiceProtocol: AnyObject {
    func registerUser(with user: RegistrationModel, completion: @escaping (Result<(), Error>) -> ())
}

protocol AuthorizationServiceProtocol: AnyObject {
    func signIn(with user: AuthorizationModel, completion: @escaping (Result<(), ErrorModelInfo>) -> ())
}

final class AuthService: ProfileServiceProtocol, RegistrationServiceProtocol, AuthorizationServiceProtocol {
    static let shared = AuthService()
    
    public func registerUser(with user: RegistrationModel, completion: @escaping (Result<(), Error>) -> ()) {
        
        let username = user.name
        let email = user.email
        let password = user.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let resultUser = result?.user else {
                completion(.failure(NSError(domain: "AuthService", code: 1, userInfo: [NSLocalizedDescriptionKey: "User not authenticated"])))
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
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(()))
                }
        }
    }
    
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
    
    public func signIn(with user: AuthorizationModel, completion: @escaping (Result<(), ErrorModelInfo>) -> ()) {
        let email = user.email
        let password = user.password
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                let errorCode = AuthErrorCode(_nsError: error as NSError)
                switch errorCode.code {
                case .invalidCredential:
                    completion(.failure(ErrorModelInfo(
                        title: "Authorization Error", error: error,
                        text: error.localizedDescription,
                        localizedDescription: NSLocalizedString(SignInError.invalidCredential.rawValue,
                                                                comment: ""))))
                case .networkError:
                    completion(.failure(ErrorModelInfo(
                        title: "Authorization Error",
                        error: error,
                        text: error.localizedDescription,
                        localizedDescription: NSLocalizedString(SignInError.networkError.rawValue,
                                                                comment: ""))))
                default:
                    completion(.failure(ErrorModelInfo(
                        title: "Authorization Error",
                        error: error,
                        text: error.localizedDescription,
                        localizedDescription: NSLocalizedString(SignInError.unknownError.rawValue,
                                                                comment: ""))))
                }
            } else {
                completion(.success(()))
            }
        }
    }
    
    public func signOut(completion: @escaping (Result<(), Error>) -> ()) {
        do {
            try Auth.auth().signOut()
            completion(.success(()))
        } catch let error {
            completion(.failure(error))
        }
    }
}
