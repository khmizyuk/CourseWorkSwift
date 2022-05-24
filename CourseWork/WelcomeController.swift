import UIKit
import FirebaseAuth

class WelcomeController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var signIn: UIButton!
    
    @IBAction func goToMainWindowButton(_ sender: UIButton) {

        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            errorLabel.text = "Остались незаполненные поля"
            errorLabel.isHidden = false
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {
            result, error in guard error == nil else {
                self.errorLabel.text = "Неверный Email и/или пароль"
                self.errorLabel.isHidden = false
                return
            }
            self.errorLabel.isHidden = true
            self.signIn.isEnabled = false
            if Auth.auth().currentUser?.isEmailVerified == true {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! TabBarController
                newViewController.modalPresentationStyle = .fullScreen
                self.present(newViewController, animated: true, completion: nil)
            }
            else {
                self.errorLabel.text = "Ваш Email не подтвержден"
                self.errorLabel.isHidden = false
                self.signIn.isEnabled = true
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
