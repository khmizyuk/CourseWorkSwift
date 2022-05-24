import UIKit
import Firebase
import FirebaseAuth

class WelcomeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if Auth.auth().currentUser != nil {
            if Auth.auth().currentUser?.isEmailVerified == true {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeTabBar") as! TabBarController
                newViewController.modalPresentationStyle = .fullScreen
                self.present(newViewController, animated: false, completion: nil)
            }
            else {
                print("email is not verified")
            }
        }
        
    }
}
