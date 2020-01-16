import UIKit

class TransformViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup(bodyImageDict: [BodyVector: CGImage]) {
        let josukeBodyConfiguration = StandData.JosukeStand
        
        let imageWidth = Double(view.frame.width)
        let imageHeight = Double(view.frame.height)
        
        let tibiHeadLocation = josukeBodyConfiguration.bodyLocations[.head]!
        let tibiHeadImage = UIImage(cgImage: bodyImageDict[.head2Neck]!)
        let tibiHead2NeckVector = josukeBodyConfiguration.bodyVectors[.head2Neck]!
        let tibiHeadImageView = UIImageView(frame: CGRect(x: (tibiHeadLocation.xNormalized + 0.5) * imageWidth,
                                                          y: (tibiHeadLocation.yNormalized + 0.5) * imageHeight,
                                                          width: 50,
                                                          height: imageHeight*tibiHead2NeckVector.norm))
        tibiHeadImageView.image = tibiHeadImage
        var tibiHead2NeckAngle = atan(tibiHead2NeckVector.yComponent/tibiHead2NeckVector.xComponent)
        if tibiHead2NeckVector.xComponent < 0 {
            tibiHead2NeckAngle = tibiHead2NeckAngle + Double.pi/2
        }
        tibiHeadImageView.transform = CGAffineTransform(rotationAngle: CGFloat(tibiHead2NeckAngle - Double.pi/2))
        
        view.addSubview(tibiHeadImageView)
        
        let tibiNeckLocation = josukeBodyConfiguration.bodyLocations[.neck]!
        let tibiNeckImage = UIImage(cgImage: bodyImageDict[.neck2Butt]!)
        let tibiNeck2ButtVector = josukeBodyConfiguration.bodyVectors[.neck2Butt]!
        let tibiNeckImageView = UIImageView(frame: CGRect(x: (tibiNeckLocation.xNormalized + 0.5) * imageWidth,
                                                          y: (tibiNeckLocation.yNormalized + 0.5) * imageHeight,
                                                          width: 50,
                                                          height: imageHeight*tibiNeck2ButtVector.norm))
        tibiNeckImageView.image = tibiNeckImage
        var tibiNeck2ButtAngle = atan(tibiNeck2ButtVector.yComponent/tibiNeck2ButtVector.xComponent)
        if tibiNeck2ButtVector.xComponent < 0 {
            tibiNeck2ButtAngle = tibiNeck2ButtAngle + Double.pi/2
        }
        tibiNeckImageView.transform = CGAffineTransform(rotationAngle: CGFloat(tibiNeck2ButtAngle - Double.pi/2))
        
        view.addSubview(tibiNeckImageView)
        
        let tibiNeck2ShoulderLeftImage = UIImage(cgImage: bodyImageDict[.neck2ShoulderLeft]!)
        let tibiNeck2ShoulderLeftVector = josukeBodyConfiguration.bodyVectors[.shoulderLeft2ElbowLeft]!
        let tibiNeck2ShoulderLeftImageView = UIImageView(frame: CGRect(x: (tibiNeckLocation.xNormalized + 0.5) * imageWidth,
                                                                       y: (tibiNeckLocation.yNormalized + 0.5) * imageHeight,
                                                                       width: 50,
                                                                       height: imageHeight*tibiNeck2ShoulderLeftVector.norm))
        tibiNeck2ShoulderLeftImageView.image = tibiNeck2ShoulderLeftImage
        var tibiNeck2ShoulderLeftAngle = atan(tibiNeck2ShoulderLeftVector.yComponent/tibiNeck2ShoulderLeftVector.xComponent)
        if tibiNeck2ShoulderLeftVector.xComponent < 0 {
            tibiNeck2ShoulderLeftAngle = tibiNeck2ShoulderLeftAngle + Double.pi/2
        }
        tibiNeck2ShoulderLeftImageView.transform = CGAffineTransform(rotationAngle: CGFloat(tibiNeck2ShoulderLeftAngle - Double.pi/2))
        
        view.addSubview(tibiNeck2ShoulderLeftImageView)
        
        let tibiElbowLeftLocation = josukeBodyConfiguration.bodyLocations[.elbowLeft]!
        let tibiElbowLeft2HandLeftImage = UIImage(cgImage: bodyImageDict[.elbowLeft2HandLeft]!)
        let tibiElbowLeft2HandLeftVector = josukeBodyConfiguration.bodyVectors[.elbowLeft2HandLeft]!
        let tibiElbowLeft2HandLeftImageView = UIImageView(frame: CGRect(x: (tibiElbowLeftLocation.xNormalized + 0.5) * imageWidth,
                                                                        y: (tibiElbowLeftLocation.yNormalized + 0.5) * imageHeight,
                                                                        width: 50,
                                                                        height: imageHeight*tibiElbowLeft2HandLeftVector.norm))
        tibiElbowLeft2HandLeftImageView.image = tibiElbowLeft2HandLeftImage
        var tibiElbowLeft2HandLeftAngle = atan(tibiElbowLeft2HandLeftVector.yComponent/tibiElbowLeft2HandLeftVector.xComponent)
        if tibiElbowLeft2HandLeftVector.xComponent < 0 {
            tibiElbowLeft2HandLeftAngle = tibiElbowLeft2HandLeftAngle + Double.pi/2
        }
        tibiElbowLeft2HandLeftImageView.transform = CGAffineTransform(rotationAngle: CGFloat(tibiElbowLeft2HandLeftAngle - Double.pi/2))
        
        view.addSubview(tibiElbowLeft2HandLeftImageView)
        
        let tibiNeck2ShoulderRightImage = UIImage(cgImage: bodyImageDict[.neck2ShoulderRight]!)
        let tibiNeck2ShoulderRightVector = josukeBodyConfiguration.bodyVectors[.neck2ShoulderRight]!
        let tibiNeck2ShoulderRightImageView = UIImageView(frame: CGRect(x: (tibiNeckLocation.xNormalized + 0.5) * imageWidth,
                                                                        y: (tibiNeckLocation.yNormalized + 0.5) * imageHeight,
                                                                        width: 50,
                                                                        height: imageHeight*tibiNeck2ShoulderRightVector.norm))
        tibiNeck2ShoulderRightImageView.image = tibiNeck2ShoulderRightImage
        var tibiNeck2ShoulderRightAngle = atan(tibiNeck2ShoulderRightVector.yComponent/tibiNeck2ShoulderRightVector.xComponent)
        if tibiNeck2ShoulderRightVector.xComponent < 0 {
            tibiNeck2ShoulderRightAngle = tibiNeck2ShoulderRightAngle + Double.pi/2
        }
        tibiNeck2ShoulderRightImageView.transform = CGAffineTransform(rotationAngle: CGFloat(tibiNeck2ShoulderRightAngle - Double.pi/2))
        
        view.addSubview(tibiNeck2ShoulderRightImageView)
        
        let tibiElbowRightLocation = josukeBodyConfiguration.bodyLocations[.elbowRight]!
        let tibiElbowRight2HandRightImage = UIImage(cgImage: bodyImageDict[.elbowRight2HandRight]!)
        let tibiElbowRight2HandRightVector = josukeBodyConfiguration.bodyVectors[.elbowRight2HandRight]!
        let tibiElbowRight2HandRightImageView = UIImageView(frame: CGRect(x: (tibiElbowRightLocation.xNormalized + 0.5) * imageWidth,
                                                                          y: (tibiElbowRightLocation.yNormalized + 0.5) * imageHeight,
                                                                          width: 50,
                                                                          height: imageHeight*tibiElbowRight2HandRightVector.norm))
        tibiElbowRight2HandRightImageView.image = tibiElbowRight2HandRightImage
        var tibiElbowRight2HandLeftAngle = atan(tibiElbowRight2HandRightVector.yComponent/tibiElbowRight2HandRightVector.xComponent)
        if tibiElbowRight2HandRightVector.xComponent < 0 {
            tibiElbowRight2HandLeftAngle = tibiElbowRight2HandLeftAngle + Double.pi/2
        }
        tibiElbowRight2HandRightImageView.transform = CGAffineTransform(rotationAngle: CGFloat(tibiElbowRight2HandLeftAngle - Double.pi/2))
        
        view.addSubview(tibiElbowRight2HandRightImageView)
        
    }
    
}
