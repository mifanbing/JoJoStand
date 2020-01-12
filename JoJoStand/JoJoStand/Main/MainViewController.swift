import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var modelImage: UIImageView!
    @IBOutlet weak var bodyJointCollectionView: UICollectionView!
    
    let allBodyJoints: [String] = BodyJoint.allCases.map { $0.rawValue }
    var currentBodyJoint: BodyJoint!
    var currentBodyJointIndex: Int!
    var bodyLocations: BodyLocation = BodyLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        modelImage.isUserInteractionEnabled = true
        modelImage.addGestureRecognizer(tapGestureRecognizer)
        modelImage.image = UIImage(named: "Josuke")
        
        bodyJointCollectionView.delegate = self
        bodyJointCollectionView.dataSource = self
        //cell layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 40)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        bodyJointCollectionView.collectionViewLayout = layout
        
        currentBodyJoint = .head
        currentBodyJointIndex = 0
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let tapLocation = tapGestureRecognizer.location(in: tappedImage)
        
        let frame = tappedImage.frame
        let xNormalized = Double(tapLocation.x / frame.width)
        let yNormalized = Double(tapLocation.y / frame.height)
        
        bodyLocations.update(bodyJoint: currentBodyJoint, normalizedLocation: NormalizedLocation(xNormalized: xNormalized, yNormalized: yNormalized))
        //print("\(xNormalized) \(yNormalized) \(currentBodyJoint)")
        dropPin(image: tappedImage, x: tapLocation.x, y: tapLocation.y)
    }
    
    func dropPin(image: UIImageView, x: CGFloat, y: CGFloat) {
        if bodyLocations.bodyLocations[currentBodyJoint] != nil {
            for subView in image.subviews {
                if subView.tag == currentBodyJointIndex {
                    subView.removeFromSuperview()
                }
            }
        }
        
        let pinImage = UIImageView(frame: CGRect(x: x, y: y, width: CGFloat(20), height: CGFloat(20)))
        pinImage.backgroundColor = .green
        pinImage.tag = currentBodyJointIndex
        
        image.addSubview(pinImage)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        let index = section * 4 + row
        currentBodyJoint = BodyJoint(rawValue: allBodyJoints[index])!
        currentBodyJointIndex = index
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

class BodyLocation {
    var bodyLocations: [BodyJoint: NormalizedLocation?]
 
    init() {
        var bodyLocationsTemp = [BodyJoint: NormalizedLocation]()
        BodyJoint.allCases.forEach {
            bodyLocationsTemp[$0] = nil //NormalizedLocation(xNormalized: 0, yNormalized: 0)
        }
        bodyLocations = bodyLocationsTemp
    }
    
    func update(bodyJoint: BodyJoint, normalizedLocation: NormalizedLocation) {
        bodyLocations[bodyJoint] = normalizedLocation
    }
}

struct NormalizedLocation {
    let xNormalized: Double
    let yNormalized: Double
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
