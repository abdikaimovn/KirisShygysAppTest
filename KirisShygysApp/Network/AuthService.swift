//
//  Network.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 12.10.2023.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol ProfileServiceProtocol {
    func signOut(completion: @escaping (Result<(), Error>) -> ())
}

protocol RegistrationServiceProtocol: AnyObject {
    func registerUser(with user: RegistrationModel, completion: @escaping (Result<Bool, Error>) -> ())
}

protocol AuthorizationServiceProtocol: AnyObject {
    func signIn(with user: AuthorizationModel, completion: @escaping (Result<(), Error>) -> ())
}

final class AuthService: ProfileServiceProtocol, RegistrationServiceProtocol, AuthorizationServiceProtocol {
    static let shared = AuthService()
    
    public func registerUser(with user: RegistrationModel, completion: @escaping (Result<Bool, Error>) -> ()) {
        
        let username = user.name
        let email = user.email
        let password = user.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let resultUser = result?.user else {
                completion(.failure(NSError()))
                return
            }
            
            let db = Firestore.firestore()
            db.collection("users")
                .document(resultUser.uid)
                .setData([
                    "username": username,
                    "email": email
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.success(true))
                }
        }
    }
    
    public func signIn(with user: AuthorizationModel, completion: @escaping (Result<(), Error>) -> ()) {
        let email = user.email
        let password = user.password
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
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
