import UIKit
import Firebase
import FirebaseAuth

class UpdatePasswordViewController: UIViewController {
    
    @IBOutlet weak var newPasswordField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBOutlet weak var saveInfo: UIButton!
    
    @IBAction func saveInfoAction(_ sender: UIButton) {
        let newPassword = newPasswordField.text!
        
        if newPassword.isEmpty {
            errorLabel.text = "Остались незаполненные поля"
            errorLabel.isHidden = false
            return
        }
        
        Auth.auth().currentUser?.updatePassword(to: newPassword) { error in
            if let error = error {
                self.errorLabel.text = "Ошибка изменения пароля: \(error.localizedDescription)"
                self.errorLabel.isHidden = false
            } else {
                self.saveInfo.isEnabled = false
                self.errorLabel.isHidden = true
                self.hintLabel.isHidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
