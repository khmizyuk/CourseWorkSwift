import UIKit
import Firebase
import FirebaseAuth
import MessageUI

class ApplicationInfoViewController: UIViewController {

    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var positionCard: UIStackView!
    @IBOutlet weak var statusCard: UIStackView!
    @IBOutlet weak var firstStepCard: UIStackView!
    @IBOutlet weak var QACard: UIStackView!
    @IBOutlet weak var taskCard: UIStackView!
    
    var card: ApplicationCard?
    
    @IBAction func openApplyWindowButton(_ sender: Any) {
        performSegue(withIdentifier: "openApplyWindow", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openApplyWindow",
            let secondViewController = segue.destination as? ApplyViewController {
                secondViewController.card = card
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskCard.layer.cornerRadius = 20
        taskCard.layer.borderWidth = 0.5
        taskCard.layer.borderColor = UIColor.lightGray.cgColor
        QACard.layer.cornerRadius = 20
        QACard.layer.borderWidth = 0.5
        QACard.layer.borderColor = UIColor.lightGray.cgColor
        firstStepCard.layer.cornerRadius = 20
        firstStepCard.layer.borderWidth = 0.5
        firstStepCard.layer.borderColor = UIColor.lightGray.cgColor
        positionCard.layer.cornerRadius = 20
        positionCard.layer.borderWidth = 0.5
        positionCard.layer.borderColor = UIColor.lightGray.cgColor
        statusCard.layer.cornerRadius = 10
        statusCard.layer.borderWidth = 0.5
        statusCard.layer.borderColor = UIColor.lightGray.cgColor
        cityLabel.text = card?.city
        companyLabel.text = card?.company
        positionLabel.text = card?.position
        positionLabel.numberOfLines = 2
        periodLabel.text = card?.period
        descriptionLabel.text = card?.description
        descriptionLabel.numberOfLines = 0
        taskLabel.text = card?.tasks
        taskLabel.numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.openMailApp))
        QACard.isUserInteractionEnabled = true
        QACard.addGestureRecognizer(tap)
    }
    
    @objc func openMailApp() {
        let email: String = card!.emailAddress
        if let url = URL(string: "mailto:\(email)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            } else {
                print("Cannot open URL")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var emptyArray: [String] = []
        let db = Firestore.firestore()
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                var submittedApplications = data?["Submitted applications"] as? [String] ?? emptyArray
                var consistFlag = false
                for id in submittedApplications {
                    if self.card?.id == id {
                        print((self.card?.id)! + "==" + id)
                        consistFlag = true
                        break
                    }
                }
                if consistFlag {
                    self.statusLabel.text = "Заявка подана"
                    self.statusLabel.textColor = .white
                    let blueColor = UIColor(rgb: 0x04809F)
                    self.statusCard.backgroundColor = blueColor
                    self.firstStepCard.isHidden = false
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
}
