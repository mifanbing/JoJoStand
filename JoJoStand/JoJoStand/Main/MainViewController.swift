import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var modelImage: UIImageView!
    @IBOutlet weak var headView: UIImageView!
    @IBOutlet weak var cropHeadView: UIImageView!
    @IBOutlet weak var bodyJointCollectionView: UICollectionView!
    
    let allBodyJoints: [String] = BodyJoint.allCases.map { $0.rawValue }
    var currentBodyJoint: BodyJoint!
    var currentBodyJointIndex: Int!
    var bodyConfiguration: BodyConfiguration = BodyConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        modelImage.isUserInteractionEnabled = true
        modelImage.addGestureRecognizer(tapGestureRecognizer)
        modelImage.image = UIImage(named: "Josuke")
        
        headView.image = UIImage(named: "Josuke")
        headView.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        headView.layer.borderWidth = 5
        
        cropHeadView.layer.borderColor = .init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        cropHeadView.layer.borderWidth = 5
        
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let transformViewController = segue.destination as? TransformViewController {
            transformViewController.setup(headImage: cropHeadView.image!)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let tapLocation = tapGestureRecognizer.location(in: tappedImage)
        
        //Will rotate w.r.t center
        let frame = tappedImage.frame
        let xNormalized = Double(tapLocation.x / frame.width) - 0.5
        let yNormalized = Double(tapLocation.y / frame.height) - 0.5
        
        bodyConfiguration.update(bodyJoint: currentBodyJoint, normalizedLocation: NormalizedLocation(xNormalized: xNormalized, yNormalized: yNormalized))
        //print("\(xNormalized) \(yNormalized) \(currentBodyJoint)")
        dropPin(image: tappedImage, x: tapLocation.x, y: tapLocation.y)
        bodyConfiguration.bodyVectors.forEach {
            print($0)
        }
    }

    func dropPin(image: UIImageView, x: CGFloat, y: CGFloat) {
        if bodyConfiguration.bodyLocations[currentBodyJoint] != nil {
            for subView in image.subviews {
                if subView.tag == currentBodyJointIndex {
                    subView.removeFromSuperview()
                }
            }
        }
        
        let pinImage = UIImageView(frame: CGRect(x: x, y: y, width: CGFloat(5), height: CGFloat(5)))
        pinImage.backgroundColor = .green
        pinImage.tag = currentBodyJointIndex
        
        image.addSubview(pinImage)
    }
    
    @IBAction func drawIt(_ sender: Any) {
        let head2Neck = bodyConfiguration.bodyVectors[.head2Neck]!
        let headLocation = bodyConfiguration.bodyLocations[.head]!
        let neckLocation = bodyConfiguration.bodyLocations[.neck]!
        
        let head2NeckAngle = atan(head2Neck.yComponent / head2Neck.xComponent)
        let angle2Rotate = Double.pi / 2 + head2NeckAngle
        
        //headView.transform = CGAffineTransform(rotationAngle: -CGFloat(angle2Rotate))
        headView.image = modelImage.image?.rotate(radians: -CGFloat(angle2Rotate))
        
        let headImageWidth = Double(headView.image!.size.width)
        let headImageHeight = Double(headView.image!.size.height)
        let headCenter = Location(x: headImageWidth/2, y: headImageHeight/2)
        
        let headX = (headLocation.xNormalized) * headImageWidth//modelImageWidth
        let headY = (headLocation.yNormalized) * headImageHeight//modelImageHeight
        let neckX = (neckLocation.xNormalized) * headImageWidth//modelImageWidth
        let neckY = (neckLocation.yNormalized) * headImageHeight//modelImageHeight
        
        let headRotated = Location(x: headX, y: headY).rotated(by: -angle2Rotate)
        headRotated.x = headRotated.x + headImageWidth/2
        headRotated.y = headRotated.y + headImageHeight/2
        
        let neckRotated = Location(x: neckX, y: neckY).rotated(by: -angle2Rotate)
        neckRotated.x = neckRotated.x + headImageWidth/2
        neckRotated.y = neckRotated.y + headImageHeight/2
        
//        let headImageRot = UIImageView(frame: CGRect(x: headRotated.x/Double(headImageWidth)*Double(headView.frame.width),
//                                                  y: headRotated.y/Double(headImageHeight)*Double(headView.frame.height),
//                                                  width: 5, height: 5))
//        headImageRot.backgroundColor = .green
//        headView.addSubview(headImageRot)
//
//        let headImage = UIImageView(frame: CGRect(x: (headX + headImageWidth/2)/Double(headImageWidth)*Double(headView.frame.width),
//                                                  y: (headY + headImageHeight/2)/Double(headImageHeight)*Double(headView.frame.height),
//                                                  width: 5, height: 5))
//        headImage.backgroundColor = .red
//        headView.addSubview(headImage)
//
//        let neckImageRot = UIImageView(frame: CGRect(x: neckRotated.x/Double(headImageWidth)*Double(headView.frame.width),
//                                                  y: neckRotated.y/Double(headImageHeight)*Double(headView.frame.height),
//                                                  width: 5, height: 5))
//        neckImageRot.backgroundColor = .green
//        headView.addSubview(neckImageRot)
//
//        let neckImage = UIImageView(frame: CGRect(x: (neckX + headImageWidth/2)/Double(headImageWidth)*Double(headView.frame.width),
//                                                  y: (neckY + headImageHeight/2)/Double(headImageHeight)*Double(headView.frame.height),
//                                                  width: 5, height: 5))
//        neckImage.backgroundColor = .red
//        headView.addSubview(neckImage)
        
        let croppedImage = headView.image?.cgImage?.cropping(to: CGRect(x: headRotated.x,
                                                                        y: headRotated.y,
                                                                        width: 50,
                                                                        height: neckRotated.y - headRotated.y))
        
        cropHeadView.image = UIImage(cgImage: croppedImage!)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let oldIndexPath = IndexPath(row: currentBodyJointIndex % 4, section: currentBodyJointIndex / 4)
        let oldCell = collectionView.cellForItem(at: oldIndexPath) as! BodyJointCollectionViewCell
        oldCell.unClicked()
        
        let row = indexPath.row
        let section = indexPath.section
        let index = section * 4 + row
        currentBodyJoint = BodyJoint(rawValue: allBodyJoints[index])!
        currentBodyJointIndex = index
        
        let newCell = collectionView.cellForItem(at: indexPath) as! BodyJointCollectionViewCell
        newCell.clicked()
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
