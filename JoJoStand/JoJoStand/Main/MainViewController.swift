import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var modelImage: UIImageView!
    @IBOutlet weak var headView: UIImageView!
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
        
        let pinImage = UIImageView(frame: CGRect(x: x, y: y, width: CGFloat(20), height: CGFloat(20)))
        pinImage.backgroundColor = .green
        pinImage.tag = currentBodyJointIndex
        
        image.addSubview(pinImage)
    }
    
    @IBAction func drawIt(_ sender: Any) {
        let head2Neck = bodyConfiguration.bodyVectors[.head2Neck]
        let headLocation = bodyConfiguration.bodyLocations[.head]
       
//        let croppedHeadView = modelImage.image!.cgImage!.cropping(to: CGRect(x: 50, y: 50, width: 50, height: 50))
//        headView.image = UIImage(cgImage: croppedHeadView!)
        
        let whiteView = UIView(frame: headView.bounds)
        let maskLayer = CAShapeLayer() //create the mask layer

        let headViewWidth = headView.frame.width
        let headViewHeight = headView.frame.height

        let point1X = Double(headViewWidth) * headLocation!.xNormalized + 0.3 * Double(headViewHeight) * head2Neck!.yComponent
        let point1Y = Double(headViewHeight) * headLocation!.yNormalized + 0.3 * Double(headViewWidth) * head2Neck!.xComponent

        let point2X = Double(headViewWidth) * headLocation!.xNormalized
                    - 0.3 * Double(headViewHeight) * head2Neck!.yComponent
                
        let point2Y = Double(headViewHeight) * headLocation!.yNormalized
                    + 0.3 * Double(headViewWidth) * head2Neck!.xComponent
                    
        
        let point3X = Double(headViewWidth) * headLocation!.xNormalized
                    + Double(headViewWidth) * head2Neck!.xComponent
                    - 0.3 * Double(headViewHeight) * head2Neck!.yComponent
                    
        let point3Y = Double(headViewHeight) * headLocation!.yNormalized
                    + Double(headViewHeight) * head2Neck!.yComponent
                    + 0.3 * Double(headViewWidth) * head2Neck!.xComponent
                    

        let point4X = Double(headViewWidth) * headLocation!.xNormalized
                    + Double(headViewWidth) * head2Neck!.xComponent
                    + 0.3 * Double(headViewHeight) * head2Neck!.yComponent
                    
        let point4Y = Double(headViewHeight) * headLocation!.yNormalized
                    + Double(headViewHeight) * head2Neck!.yComponent
                    + 0.3 * Double(headViewWidth) * head2Neck!.xComponent
                    


        // Create a path with the rectangle in it.
        let path = UIBezierPath(rect: headView.bounds)
        path.addLine(to: CGPoint(x: point1X, y: point1Y))
        path.addLine(to: CGPoint(x: point2X, y: point2Y))
        path.addLine(to: CGPoint(x: point3X, y: point3Y))
        path.addLine(to: CGPoint(x: point4X, y: point4Y))
        path.addLine(to: CGPoint(x: point1X, y: point1Y))

        // Give the mask layer the path you just draw
        maskLayer.path = path.cgPath
        // Fill rule set to exclude intersected paths
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd

        // By now the mask is a rectangle with a circle cut out of it. Set the mask to the view and clip.
        whiteView.layer.mask = maskLayer
        whiteView.clipsToBounds = true

        whiteView.alpha = 0.8
        whiteView.backgroundColor = UIColor.red

        //If you are in a VC add to the VC's view (over the image)
        headView.addSubview(whiteView)
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
