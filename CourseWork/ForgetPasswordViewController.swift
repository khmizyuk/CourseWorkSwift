import UIKit
import Firebase
import FirebaseAuth

class ForgetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetPassword: UIButton!
    
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBAction func resetPasswordAction(_ sender: UIButton) {
        let email = emailField.text!
        if email.isEmpty {
            errorLabel.text = "Остались незаполненные поля"
            errorLabel.isHidden = false
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.errorLabel.text = "Ошибка восстановления пароля: \(error.localizedDescription)"
                self.errorLabel.isHidden = false
            } else {
                self.errorLabel.isHidden = true
                self.resetPassword.isEnabled = false
                self.hintLabel.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.text = Auth.auth().currentUser?.email
    }

}
