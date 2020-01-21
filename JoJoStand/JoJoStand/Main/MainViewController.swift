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
    var bodyImageDict: [BodyVector: CGImage]!
    let slideGaugeWidth: Double = 100
    let slideGaugeHeight: Double = 20
    var targetSize: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        modelImage.isUserInteractionEnabled = true
        modelImage.addGestureRecognizer(tapGestureRecognizer)
        modelImage.image = UIImage(named: "tibi")
        //modelImage.image = UIImage(named: "Josuke")
        //headView.image = UIImage(named: "Josuke")
        let headImage = UIImage(named: "tibi")
        let targetSizeCGFloat = min(headImage!.size.width, headImage!.size.height)
        headView.image = headImage!.resizeImage(targetSize: CGSize(width: targetSizeCGFloat, height: targetSizeCGFloat))
        targetSize = Double(targetSizeCGFloat)
        
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
        
        bodyImageDict = [:]
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let transformViewController = segue.destination as? TransformViewController {
            transformViewController.setup(bodyImageDict: bodyImageDict)
        }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let tapLocation = tapGestureRecognizer.location(in: tappedImage)
        
        //Will rotate w.r.t center
        let frame = tappedImage.frame
        let xNormalized = Double(tapLocation.x / frame.width) - 0.5
        let yNormalized = Double(tapLocation.y / frame.height) - 0.5
        
        let viewHit = modelImage.hitTest(CGPoint(x: tapLocation.x, y: tapLocation.y), with: nil)
        if viewHit == modelImage {
            dropPin(image: tappedImage, x: tapLocation.x, y: tapLocation.y)
            
            let shouldAddSlideGauge = bodyConfiguration.bodyLocations[currentBodyJoint] == nil
            bodyConfiguration.update(bodyJoint: currentBodyJoint, normalizedLocation: NormalizedLocation(xNormalized: xNormalized, yNormalized: yNormalized))
            
            adjustSlideGauge(image: tappedImage, x: tapLocation.x, y: tapLocation.y, shouldAddSlideGauge: shouldAddSlideGauge)
        } else {
            return
        }
        
    }

//    func imagePanned(panGestureRecognizer: UIPanGestureRecognizer) {
//        if panGestureRecognizer.state == .ended {
//            guard let slideGauge = panGestureRecognizer.view as? SlideGauge else { return }
//
//            guard let bodyVector = BodyVector(rawValue: slideGauge.tag) else { return }
//
//            bodyConfiguration.bodyVectors[bodyVector]!.width = Double(slideGauge.normalizedValue) * slideGaugeWidth / Double(modelImage.frame.width)
//        }
//    }
    
    func dropPin(image: UIImageView, x: CGFloat, y: CGFloat) {
        for subView in image.subviews {
            if subView.tag == currentBodyJointIndex && !(subView is SlideGauge) {
                subView.removeFromSuperview()
            }
        }
        
        let pinImage = UIImageView(frame: CGRect(x: x, y: y, width: CGFloat(5), height: CGFloat(5)))
        pinImage.backgroundColor = .green
        pinImage.tag = currentBodyJointIndex
        
        image.addSubview(pinImage)
    }
    
    func adjustSlideGauge(image: UIImageView, x: CGFloat, y: CGFloat, shouldAddSlideGauge: Bool) {
        let frame = image.frame
        let xNormalized = Double(x / frame.width) - 0.5
        let yNormalized = Double(y / frame.height) - 0.5
        
        
        //add slide gauge
        
        let connectedBodyVector = BodyJoint.connectedBodyVector(bodyJoint: currentBodyJoint)
        
        connectedBodyVector.forEach { bodyVector in
            guard bodyVector != .neck2ShoulderLeft, bodyVector != .neck2ShoulderRight else { return }
            
            if let vector = bodyConfiguration.bodyVectors[bodyVector] {
                var angle = atan(vector.yComponent / vector.xComponent)
                if vector.xComponent < 0 {
                    angle = angle + Double.pi
                }
                let angle2Rotate = angle - Double.pi / 2
                let xCenter = (vector.start.xNormalized == xNormalized) ?
                            x + CGFloat(vector.xComponent)/2 * frame.width :
                            x - CGFloat(vector.xComponent)/2 * frame.width
                    
                let yCenter = (vector.start.yNormalized == yNormalized) ?
                            y + CGFloat(vector.yComponent)/2 * frame.height :
                            y - CGFloat(vector.yComponent)/2 * frame.height
                let slideGauge = SlideGauge(frame: CGRect(x: 0,
                                                          y: 0 ,
                                                          width: CGFloat(slideGaugeWidth),
                                                          height: CGFloat(slideGaugeHeight)))
                var t = CGAffineTransform.identity
                t = t.translatedBy(x: xCenter - CGFloat(slideGaugeWidth/2), y: yCenter - CGFloat(slideGaugeHeight/2))
                t = t.rotated(by: CGFloat(angle2Rotate))
                slideGauge.transform = t
                if shouldAddSlideGauge {
                    slideGauge.tag = bodyVector.rawValue
                    slideGauge.delegate = self
                    image.addSubview(slideGauge)
                } else {
                    image.subviews.forEach {
                        if $0.tag == bodyVector.rawValue {
                            $0.transform = t
                        }
                    }
                }
            }
        }

    }
    
    @IBAction func drawIt(_ sender: Any) {
        bodyConfiguration.bodyVectors.forEach {
            var location1, location2: NormalizedLocation
            
            switch $0.key {
            case .head2Neck:
                location1 = bodyConfiguration.bodyLocations[.head]!
                location2 = bodyConfiguration.bodyLocations[.neck]!
            case .neck2ShoulderLeft:
                location1 = bodyConfiguration.bodyLocations[.neck]!
                location2 = bodyConfiguration.bodyLocations[.shoulderLeft]!
            case .neck2ShoulderRight:
                location1 = bodyConfiguration.bodyLocations[.neck]!
                location2 = bodyConfiguration.bodyLocations[.shoulderRight]!
            case .neck2Butt:
                location1 = bodyConfiguration.bodyLocations[.neck]!
                location2 = bodyConfiguration.bodyLocations[.butt]!
            case .shoulderLeft2ElbowLeft:
                location1 = bodyConfiguration.bodyLocations[.shoulderLeft]!
                location2 = bodyConfiguration.bodyLocations[.elbowLeft]!
            case .shoulderRight2ElbowRight:
                location1 = bodyConfiguration.bodyLocations[.shoulderRight]!
                location2 = bodyConfiguration.bodyLocations[.elbowRight]!
            case .elbowLeft2HandLeft:
                location1 = bodyConfiguration.bodyLocations[.elbowLeft]!
                location2 = bodyConfiguration.bodyLocations[.handLeft]!
            case .elbowRight2HandRight:
                location1 = bodyConfiguration.bodyLocations[.elbowRight]!
                location2 = bodyConfiguration.bodyLocations[.handRight]!
            case .butt2KneeLeft:
                location1 = bodyConfiguration.bodyLocations[.butt]!
                location2 = bodyConfiguration.bodyLocations[.kneeLeft]!
            case .butt2KneeRight:
                location1 = bodyConfiguration.bodyLocations[.butt]!
                location2 = bodyConfiguration.bodyLocations[.kneeRight]!
            case .kneeLeft2FootLeft:
                location1 = bodyConfiguration.bodyLocations[.kneeLeft]!
                location2 = bodyConfiguration.bodyLocations[.footLeft]!
            case .kneeRight2FootRight:
                location1 = bodyConfiguration.bodyLocations[.kneeRight]!
                location2 = bodyConfiguration.bodyLocations[.footRight]!
            }
            
            let bodyVector = $0.value
            let bodyAngle = atan(bodyVector.yComponent / bodyVector.xComponent)
            
            var angle2Rotate: Double
            if bodyVector.xComponent > 0 {
                angle2Rotate = Double.pi / 2 - bodyAngle
            } else if bodyVector.xComponent < 0 {
                angle2Rotate = -Double.pi / 2 - bodyAngle
            } else {
                if bodyVector.yComponent > 0 {
                    angle2Rotate = 0
                } else {
                    angle2Rotate = Double.pi
                }
            }
            
            headView.image = modelImage.image?.rotate(radians: CGFloat(angle2Rotate))
            let headImageWidth = Double(headView.image!.size.width)
            let headImageHeight = Double(headView.image!.size.height)
            let scale = headImageWidth / targetSize
            
            let location1X = (location1.xNormalized) * headImageWidth / scale
            let location1Y = (location1.yNormalized) * headImageHeight / scale
            let location2X = (location2.xNormalized) * headImageWidth / scale
            let location2Y = (location2.yNormalized) * headImageHeight / scale
            
            let location1Rotated = Location(x: location1X, y: location1Y).rotated(by: angle2Rotate)
            location1Rotated.x = location1Rotated.x + headImageWidth/2
            location1Rotated.y = location1Rotated.y + headImageHeight/2
            
            let location2Rotated = Location(x: location2X, y: location2Y).rotated(by: angle2Rotate)
            location2Rotated.x = location2Rotated.x + headImageWidth/2
            location2Rotated.y = location2Rotated.y + headImageHeight/2
            
            let croppedWidth = bodyVector.width * headImageWidth
            
            let croppedImage = headView.image?.cgImage?.cropping(to: CGRect(x: location1Rotated.x - croppedWidth/2,
                                                                            y: location1Rotated.y,
                                                                            width: croppedWidth,
                                                                            height: location2Rotated.y - location1Rotated.y))
            bodyImageDict[$0.key] = croppedImage
            
            let headImageRot = UIImageView(frame: CGRect(x: location1Rotated.x/Double(headImageWidth)*Double(headView.frame.width),
                                                      y: location1Rotated.y/Double(headImageHeight)*Double(headView.frame.height),
                                                      width: 5, height: 5))
            headImageRot.backgroundColor = .green
            headView.addSubview(headImageRot)
    
            let headImage = UIImageView(frame: CGRect(x: (location1X + headImageWidth/2)/Double(headImageWidth)*Double(headView.frame.width),
                                                      y: (location1Y + headImageHeight/2)/Double(headImageHeight)*Double(headView.frame.height),
                                                      width: 5, height: 5))
            headImage.backgroundColor = .red
            headView.addSubview(headImage)
    
            let neckImageRot = UIImageView(frame: CGRect(x: location2Rotated.x/Double(headImageWidth)*Double(headView.frame.width),
                                                      y: location2Rotated.y/Double(headImageHeight)*Double(headView.frame.height),
                                                      width: 5, height: 5))
            neckImageRot.backgroundColor = .green
            headView.addSubview(neckImageRot)
    
            let neckImage = UIImageView(frame: CGRect(x: (location2X + headImageWidth/2)/Double(headImageWidth)*Double(headView.frame.width),
                                                      y: (location2Y + headImageHeight/2)/Double(headImageHeight)*Double(headView.frame.height),
                                                      width: 5, height: 5))
            neckImage.backgroundColor = .red
            headView.addSubview(neckImage)
            
            cropHeadView.image = UIImage(cgImage: croppedImage!)
        }
    }
}

extension MainViewController: SlideGaugeDelegate {
    func valueChanged(normalizedValue: Double, tag: Int) {
        guard let bodyVector = BodyVector(rawValue: tag) else { return }
        
        bodyConfiguration.bodyVectors[bodyVector]!.width = normalizedValue * slideGaugeWidth / Double(modelImage.frame.width)
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
        return Int(allBodyJoints.count / 4) + 1
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
