import UIKit

class TransformViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setup(headImage: UIImage) {
        let headView = UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        headView.image = headImage
        
        view.addSubview(headView)
    }
    
}
