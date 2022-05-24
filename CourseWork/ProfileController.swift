import UIKit
import Firebase
import FirebaseAuth

class ProfileController: UIViewController {
    
    @IBOutlet weak var mainInfoCard: UIStackView!
    @IBOutlet weak var companyCard: UIStackView!
    @IBOutlet weak var applicationCard: UIStackView!
    @IBOutlet weak var infoCard: UIStackView!
    @IBOutlet weak var applicationContentStack: UIStackView!
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var appliesLabel: UILabel!
    
    var globalIndex: Int?
    
    let interships = DataSource().dataSource
    
    override func viewDidAppear(_ animated: Bool) {
        updateData()
    }
    
    override func viewDidLoad() {
        updateData()
        super.viewDidLoad()
        mainInfoCard.layer.cornerRadius = 20
        mainInfoCard.layer.borderWidth = 0.5
        mainInfoCard.layer.borderColor = UIColor.lightGray.cgColor
        companyCard.layer.cornerRadius = 20
        companyCard.layer.borderWidth = 0.5
        companyCard.layer.borderColor = UIColor.lightGray.cgColor
        applicationCard.layer.cornerRadius = 20
        applicationCard.layer.borderWidth = 0.5
        applicationCard.layer.borderColor = UIColor.lightGray.cgColor
        infoCard.layer.cornerRadius = 20
        infoCard.layer.borderWidth = 0.5
        infoCard.layer.borderColor = UIColor.lightGray.cgColor
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
                self.statusLabel.text = data?["status"] as? String ?? ""
            } else {
                print("Document does not exist")
            }
        }
        
        let emptyArray: [String] = []
        db.collection("users").document((Auth.auth().currentUser?.email)!).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let submittedApplications = data?["Submitted applications"] as? [String] ?? emptyArray
                
                self.applicationContentStack.subviews.forEach { (view) in
                    view.removeFromSuperview()
                }
                var add = false
                for (index, intership) in self.interships.enumerated() {
                    for id in submittedApplications {
                        if intership.id == id {
                            add = true
                            
                            let label = UILabel()
                            label.text = intership.id
                            label.textColor = UIColor(rgb: 0x505050)
                            label.numberOfLines = 0
                            label.tag = index
                            label.font = label.font.withSize(15)
                            self.applicationContentStack.addArrangedSubview(label)
                        }
                    }
                }
                if add == false {
                    let label = UILabel()
                    label.text = "У Вас нет заявок на рассмотрении"
                    label.textColor = UIColor(rgb: 0x7D7D7D)
                    label.numberOfLines = 0
                    
                    self.applicationContentStack.addArrangedSubview(label)
                }
                
                self.applicationContentStack.subviews.forEach { (view) in
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapFunction))
                    view.isUserInteractionEnabled = true
                    view.addGestureRecognizer(tap)
                }
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        globalIndex = Int(sender.view!.tag)
        performSegue(withIdentifier: "appliedCardInfo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "appliedCardInfo",
            let secondViewController = segue.destination as? ApplicationInfoViewController {
            secondViewController.card = interships[globalIndex!]
        }
    }
    
}
