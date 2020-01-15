import UIKit

class BodyJointCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    func setup(name: String) {
        nameLabel.text = name
    }
    
    func clicked() {
        nameLabel.backgroundColor = .red
    }
    
    func unClicked() {
        nameLabel.backgroundColor = .clear
    }
}
