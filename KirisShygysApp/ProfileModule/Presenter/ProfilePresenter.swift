import Foundation

protocol ProfilePresenterDelegate: AnyObject {
    func didReceiveUsername(name: String)
}

protocol ProfileViewControllerDelegate: AnyObject {
    
}

class ProfilePresenter {
    weak var delegate: ProfilePresenterDelegate?
    
    init(delegate: ProfilePresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    func getUsername() {
        UserDataManager.shared.getCurrentUserName { username in
            self.delegate?.didReceiveUsername(name: username ?? "Couldn't receive username")
        }
    }
    
    func receiveUserTransactionReport() {
        
    }
    
    deinit {
        print("Profile Presenter deinit")
    }
}

extension ProfilePresenter: ProfileViewControllerDelegate {

}
