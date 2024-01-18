//
//  AlertManager.swift
//  KirisShygysApp
//
//  Created by Нурдаулет on 24.10.2023.
//

import Foundation
import UIKit

final class AlertManager {
    private static func showBasicAlert(on vc: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("alert_button_title_dismiss", comment: ""), style: .default, handler: nil))
            vc.present(alert, animated: true)
        }
    }
}

// MARK: - Show validation alerts
extension AlertManager {
    public static func showInvalidUsernameAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Username", message: "Please enter a valid Username!")
    }
    
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Email", message: "Please enter a valid email!")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Invalid Password", message: "Please enter a valid password!")
    }
}

// MARK: - Registration Errors
extension AlertManager {
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: ErrorModelInfo){
        self.showBasicAlert(on: vc, title: error.title ?? NSLocalizedString("registration_error_title", comment: ""), message: error.localizedDescription)
    }
}

// MARK: - Authorization Errors
extension AlertManager {
    public static func showAuthorizationErrorAlert(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Unknown Authorization Error", message: "Check your network connection")
    }
    
    public static func showAuthorizationErrorAlert(on vc: UIViewController, with error: ErrorModelInfo){
        self.showBasicAlert(on: vc, title: "Unknown Authorization Error", message: error.localizedDescription)
    }
}

// MARK: - Log out Errors
extension AlertManager {
    public static func showLogOutErrorAlert(on vc: UIViewController, with error: Error){
        self.showBasicAlert(on: vc, title: "Log Out Error", message: "\(error.localizedDescription)")
    }
}

// MARK: - Fetching User Errors
extension AlertManager {
    public static func showFetchingUserErrorAlert(on vc: UIViewController, with error: Error){
        self.showBasicAlert(on: vc, title: "Error Fetching User", message: "\(error.localizedDescription)")
    }
}

// MARK: - Transaction page alerts
extension AlertManager {
    public static func emptyAmountField(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Empty Amount Field", message: "Please specify the amount")
    }
    
    public static func emptyNameField(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Empty Name Field", message: "Please specify the name")
    }
}

//MARK: - Transaction Report Page Alerts
extension AlertManager {
    public static func showAbsenceTransactionData(on vc: UIViewController) {
        self.showBasicAlert(on: vc, title: "Absence of Data", message: "You haven't made any transactions yet")
    }
}

extension AlertManager {
    public static func showReportError(on vc: UIViewController, with error: ErrorModel) {
        self.showBasicAlert(on: vc, title: "Transaction Report Error", message: error.text)
    }
}

//MARK: - Adding new transaction error
extension AlertManager {
    public static func transactionError(on vc: UIViewController, message: String) {
        self.showBasicAlert(on: vc, title: "Transaction Error", message: message)
    }
}

//MARK: - Unknown error
extension AlertManager {
    public static func showUnknownError(on vc: UIViewController, message: String) {
        self.showBasicAlert(on: vc, title: "Unknown Error", message: message)
    }
}
