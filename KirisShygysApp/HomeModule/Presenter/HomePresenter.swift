import Foundation
import FirebaseFirestore

protocol HomePresenterDelegate: AnyObject {
    func didReceiveUsername(name: String?)
}

class HomePresenter {
    weak var delegate: HomePresenterDelegate?
    
    init(delegate: HomePresenterDelegate? = nil) {
        self.delegate = delegate
    }
    
    deinit {
        print("HomePresenter was deinited")
    }
    
    func getNameForUser(uid: String) {
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.addSnapshotListener { snapshot, error in
            if let snapshot = snapshot, let userData = snapshot.data(),
               let name = userData["username"] as? String {
                self.delegate?.didReceiveUsername(name: name)
            } else {
                self.delegate?.didReceiveUsername(name: nil)
            }
        }
    }
}
