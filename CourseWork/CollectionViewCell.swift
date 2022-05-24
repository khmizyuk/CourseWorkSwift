import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    var applied = false
    
    func configure(position: String, company: String, city: String, period: String) {
        self.positionLabel.text = position
        positionLabel.numberOfLines = 2
        self.companyLabel.text = company
        self.cityLabel.text = city
        self.periodLabel.text = period
    }
    
}
