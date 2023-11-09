import Foundation
import FirebaseFirestore

protocol HomePresenterDelegate {
    func didGetUserData()
}

class HomePresenter {
    func getNameForUser(uid: String, completion: @escaping (String?) -> Void) {
        let ref = Firestore.firestore().collection("users").document(uid)
        ref.addSnapshotListener { snapshot, error in
            if let snapshot = snapshot, let userData = snapshot.data(),
               let name = userData["username"] as? String {
                completion(name)
            } else {
                completion(nil)
            }
        }
    }
}
