import UIKit
import Firebase
import FirebaseAuth

class CollectionViewController: UICollectionViewController {
    
    var dataSource = [ApplicationCard]()
    
    var interships = DataSource().dataSource
    
    var appliedCards: [String] = []
    
    var globalIndexPath: IndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interships.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        if let positionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? CollectionViewCell {
            positionCell.configure(position: interships[indexPath.row].position, company: interships[indexPath.row].company, city: interships[indexPath.row].city, period: interships[indexPath.row].period)
            positionCell.contentView.layer.cornerRadius = 20
            positionCell.contentView.layer.borderWidth = 0.5
            positionCell.contentView.layer.borderColor = UIColor.lightGray.cgColor
            cell = positionCell
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected position is \(interships[indexPath.row].position)")
        globalIndexPath = indexPath
        performSegue(withIdentifier: "CardInfo", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CardInfo",
            let secondViewController = segue.destination as? ApplicationInfoViewController {
            secondViewController.card = interships[globalIndexPath.row]
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 60, height: 175)
    }
}
