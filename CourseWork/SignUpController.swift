import UIKit
import FirebaseAuth
import Firebase

class SignUpController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var surnameField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var createAccount: UIButton!
    
    @IBOutlet weak var signUp: UIButton!
    
    @IBAction func singUpActionButton(_ sender: Any) {
    
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty, let firstName = firstNameField.text, !firstName.isEmpty, let surname = surnameField.text, !surname.isEmpty, let city = cityField.text, !city.isEmpty else {
            errorLabel.text = "Остались незаполненные поля"
            errorLabel.isHidden = false
            return
        }
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {
            result, error in guard error == nil else {
                self.errorLabel.text = "Ошибка при создании аккаунта: \(string(error?.localizedDescription))"
                print(error?.localizedDescription)
                self.errorLabel.isHidden = false
                return
            }
            self.errorLabel.isHidden = true
            self.signUp.isEnabled = false
            
            let city = self.cityField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let firstName = self.firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let surname = self.surnameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let submittedApplications: [String] = []
            
            let db = Firestore.firestore()
            
            db.collection("users").document(email).setData([
                "first name":firstName,
                "surname":surname,
                "city":city,
                "email":email,
                "status":"Выбирает стажировку",
                "Submitted applications":submittedApplications
            ]) { err in
                if let err = err {
                    self.errorLabel.text = "Ошибка при записи данных: \(error?.localizedDescription)"
                    self.errorLabel.isHidden = false
                }
            }
            
            Auth.auth().currentUser?.sendEmailVerification()
            
            self.hintLabel.isHidden = false
            self.createAccount.isEnabled = false
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
