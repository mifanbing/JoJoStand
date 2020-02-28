import UIKit

class RefineViewController: UIViewController {

    @IBOutlet weak var inputImageView: UIImageView!
    @IBOutlet weak var maskImageView: UIImageView!
    @IBOutlet weak var outputImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let inputImage = UIImage(named: "vernonTransform")!
        inputImageView.image = inputImage
                
        let maskImage = UIImage(named: "mask")!
        maskImageView.image = maskImage
        
        let outputImage = OpenCVWrapper.cvInpaint(inputImage, maskImage: maskImage)
        outputImageView.image = outputImage
    }


}
