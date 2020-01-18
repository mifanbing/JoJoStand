import UIKit

class TransformViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup(bodyImageDict: [BodyVector: CGImage]) {
        let josukeBodyConfiguration = StandData.JosukeStand
        
        let imageWidth = Double(view.frame.width)
        let imageHeight = Double(view.frame.height)
        
        let notRender: [BodyVector] = [.neck2ShoulderLeft, .neck2ShoulderRight]
        
        bodyImageDict.forEach { bodyVector, image in
            if !notRender.contains(bodyVector) {
                let tibiHeadImage = UIImage(cgImage: image)
                let tibiVector = josukeBodyConfiguration.bodyVectors[bodyVector]!
                let tibiImageView = UIImageView(frame: CGRect(x: 0,
                                                                  y: 0,
                                                                  width: tibiVector.width * imageWidth,
                                                                  height: imageHeight*tibiVector.norm))
                tibiImageView.image = tibiHeadImage
                var tibiAngle = atan(tibiVector.yComponent/tibiVector.xComponent)
                if tibiVector.xComponent < 0 {
                    tibiAngle = tibiAngle + Double.pi
                }
                //rotate angle
                tibiAngle = -Double.pi/2 + tibiAngle
                
                let xCenter = ((tibiVector.start.xNormalized + tibiVector.end.xNormalized)/2 + 0.5) * imageWidth
                let yCenter = ((tibiVector.start.yNormalized + tibiVector.end.yNormalized)/2 + 0.5) * imageHeight
                var t = CGAffineTransform.identity
                t = t.translatedBy(x: CGFloat(xCenter) - tibiHeadImage.size.width/2, y: CGFloat(yCenter) - tibiHeadImage.size.height/2)
                t = t.rotated(by: CGFloat(tibiAngle))
                tibiImageView.transform = t
                
                view.addSubview(tibiImageView)
            }
        }
    }
    
}
