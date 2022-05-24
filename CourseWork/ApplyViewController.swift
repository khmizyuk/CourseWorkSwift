import UIKit
import Firebase
import FirebaseAuth

class ApplyViewController: UIViewController {

    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    
    var card: ApplicationCard?
    
    @IBOutlet weak var applyButton: UIButton!
    
    @IBAction func applyButtonAction(_ sender: Any) {
        apply()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var emptyArray: [String] = []
        let db = Firestore.firestore()
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var submittedApplications = data?["Submitted applications"] as? [String] ?? emptyArray
                var consistFlag = false
                for id in submittedApplications {
                    if self.card?.id == id {
                        consistFlag = true
                        break
                    }
                }
                if consistFlag {
                    self.applyButton.isEnabled = false
                }
            } else {
                print("Document does not exist")
            }
        }
        
        updateData()
        positionLabel.text = card?.position
    }
    
    func updateData() {
        let db = Firestore.firestore()
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.firstNameLabel.text = data?["first name"] as? String ?? ""
                self.surnameLabel.text = data?["surname"] as? String ?? ""
                self.cityLabel.text = data?["city"] as? String ?? ""
                self.emailLabel.text = data?["email"] as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func apply() {
        let emptyArray: [String] = []

        let db = Firestore.firestore()
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var submittedApplications = data?["Submitted applications"] as? [String] ?? emptyArray

                submittedApplications.append(self.card!.id)
                submittedApplications = Array(Set(submittedApplications))

                self.applyButton.isEnabled = false

                db.collection("users").document((Auth.auth().currentUser?.email)!).updateData([
                    "Submitted applications":submittedApplications
                ]) { err in
                    if let err = err {
                        print("Error updating document: \(err)")
                    } else {
                        print("Document successfully updated")
                    }
                }
            } else {
                print("Document does not exist")
                return
            }
        }
    }
}
