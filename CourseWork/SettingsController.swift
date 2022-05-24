import UIKit
import Firebase
import FirebaseAuth

class SettingsController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var update: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBAction func SignOutAction(_ sender: UIButton) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "WelcomeController") as! WelcomeNavigationController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func saveDataAction(_ sender: Any) {
        saveData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
    }
    
    func updateData() {
        let db = Firestore.firestore()
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                self.firstNameField.text = data?["first name"] as? String ?? ""
                self.surnameField.text = data?["surname"] as? String ?? ""
                self.cityField.text = data?["city"] as? String ?? ""
                self.emailLabel.text = data?["email"] as? String ?? ""
            }
        }
    }
    
    func saveData() {
        let city = self.cityField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let firstName = self.firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let surname = self.surnameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if surname.isEmpty || firstName.isEmpty || city.isEmpty {
            errorLabel.text = "Остались незаполненные поля"
            errorLabel.isHidden = false
            return
        }
        
        errorLabel.isHidden = true
        
        let db = Firestore.firestore()
        db.collection("users").document((Auth.auth().currentUser?.email)!).updateData([
            "first name":firstName,
            "surname":surname,
            "city":city
        ]) { err in
            if let err = err {
                self.errorLabel.text = "Ошибка сохранения данных: \(err.localizedDescription)"
                self.errorLabel.isHidden = false
            } else {
                self.update.isEnabled = false
                self.errorLabel.isHidden = true
                self.hintLabel.isHidden = false
            }
        }
    }
}
