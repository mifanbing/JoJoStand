import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var modelImage: UIImageView!
    @IBOutlet weak var bodyJointCollectionView: UICollectionView!
    let allBodyJoints: [String] = BodyJoint.allCases.map { $0.rawValue }
    var currentBodyIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        modelImage.isUserInteractionEnabled = true
        modelImage.addGestureRecognizer(tapGestureRecognizer)
        
        bodyJointCollectionView.delegate = self
        bodyJointCollectionView.dataSource = self
        
        //cell layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        bodyJointCollectionView.collectionViewLayout = layout
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView

        let tapLocation = tapGestureRecognizer.location(in: tappedImage)
        
        print("\(tapLocation.x) \(tapLocation.y)")
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        currentBodyIndex = section * 4 + row
        
        print(currentBodyIndex)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(allBodyJoints.count / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row
        let section = indexPath.section
        let realIndex = section * 4 + row
        
        guard realIndex < allBodyJoints.count else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyCell", for: indexPath) as! BodyJointEmptyCollectionViewCell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BodyCell", for: indexPath) as! BodyJointCollectionViewCell
        cell.setup(name: allBodyJoints[realIndex])
        
        return cell
    }
    
    
}

struct BodyLocation {
    var bodyLocations: [BodyJoint: NormalizedLocation]
 
    init() {
        var bodyLocationsTemp = [BodyJoint: NormalizedLocation]()
        BodyJoint.allCases.forEach {
            bodyLocationsTemp[$0] = NormalizedLocation(xNormalized: 0, yNormalized: 0)
        }
        bodyLocations = bodyLocationsTemp
    }
    
    struct NormalizedLocation {
        let xNormalized: Double
        let yNormalized: Double
    }
    
}

enum BodyJoint: String, CaseIterable {
    case head
    case neck
    case shoulderLeft
    case shoulderRight
    case elbowLeft
    case elbowRight
    case handLeft
    case handRight
}
