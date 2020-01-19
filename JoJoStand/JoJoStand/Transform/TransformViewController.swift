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
                t = t.translatedBy(x: CGFloat(xCenter) - tibiImageView.frame.width/2, y: CGFloat(yCenter) - tibiImageView.frame.height/2)
                //t = t.translatedBy(x: CGFloat(xCenter) , y: CGFloat(yCenter) )
                t = t.rotated(by: CGFloat(tibiAngle))
                tibiImageView.transform = t
                
                tibiImageView.layer.borderColor = .init(srgbRed: 1, green: 0, blue: 0, alpha: 1)
                tibiImageView.layer.borderWidth = 1
                view.addSubview(tibiImageView)
                
                let mark1 = UIImageView(frame: CGRect(x: (tibiVector.start.xNormalized + 0.5) * imageWidth,
                                                      y: (tibiVector.start.yNormalized + 0.5) * imageHeight,
                                                          width: 5, height: 5))
                mark1.backgroundColor = .green
                view.addSubview(mark1)
                view.bringSubviewToFront(mark1)
                
                let mark2 = UIImageView(frame: CGRect(x: (tibiVector.end.xNormalized + 0.5) * imageWidth,
                                                      y: (tibiVector.end.yNormalized + 0.5) * imageHeight,
                                                          width: 5, height: 5))
                mark2.backgroundColor = .green
                view.addSubview(mark2)
                view.bringSubviewToFront(mark2)
            }
        }
    }
    
}
