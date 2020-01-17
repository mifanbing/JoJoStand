import UIKit

class SlideGauge: UIView {
    @IBOutlet weak var sliderLeft: UISlider!
    @IBOutlet weak var sliderRight: UISlider!
    @IBOutlet var contentView: UIView!
    
    var normalizedValue: Float!
    
    @IBAction func slided(_ sender: Any) {
        guard let slider = sender as? UISlider else { return }
        
        if slider.accessibilityIdentifier == "sliderLeft" {
            normalizedValue = 1 - slider.value
            sliderRight.value = normalizedValue
        }
        if slider.accessibilityIdentifier == "sliderRight" {
            normalizedValue = slider.value
            sliderLeft.value = 1 - normalizedValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("SlideGauge", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        let width = self.frame.width
        let widthConstrainSliderLeft = NSLayoutConstraint(item: sliderLeft!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width / 2)
        let topConstrainSliderLeft = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal, toItem: sliderLeft, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstrainSliderLeft = NSLayoutConstraint(item: contentView!, attribute: .bottom, relatedBy: .equal, toItem: sliderLeft, attribute: .bottom, multiplier: 1, constant: 0)
        let leadingConstrainSliderLeft = NSLayoutConstraint(item: contentView!, attribute: .leading, relatedBy: .equal, toItem: sliderLeft, attribute: .leading, multiplier: 1, constant: 0)
        sliderLeft.addConstraints([widthConstrainSliderLeft])
        contentView.addConstraints([topConstrainSliderLeft, bottomConstrainSliderLeft, leadingConstrainSliderLeft])
        
        let widthConstrainSliderRight = NSLayoutConstraint(item: sliderRight!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width / 2)
        let topConstrainSliderRight = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal, toItem: sliderRight, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstrainSliderRight = NSLayoutConstraint(item: contentView!, attribute: .bottom, relatedBy: .equal, toItem: sliderRight, attribute: .bottom, multiplier: 1, constant: 0)
        let trailingConstrainSliderRight = NSLayoutConstraint(item: contentView!, attribute: .trailing, relatedBy: .equal, toItem: sliderRight, attribute: .trailing, multiplier: 1, constant: 0)
        sliderRight.addConstraints([widthConstrainSliderRight])
        contentView.addConstraints([topConstrainSliderRight, bottomConstrainSliderRight, trailingConstrainSliderRight])
        
        sliderLeft.thumbTintColor = .green
        //sliderLeft.setThumbImage(UIImage(named: "arrowRight")!.resizeImage(targetSize: CGSize(width: 30, height: 30)), for: .normal)
        sliderRight.thumbTintColor = .green
        //sliderRight.setThumbImage(UIImage(named: "arrowLeft")!.resizeImage(targetSize: CGSize(width: 30, height: 30)), for: .normal)
        
        sliderLeft.minimumValue = 0
        sliderLeft.maximumValue = 1
        sliderRight.minimumValue = 0
        sliderRight.maximumValue = 1
        sliderLeft.minimumTrackTintColor = .clear
        sliderLeft.maximumTrackTintColor = .green
        sliderRight.minimumTrackTintColor = .green
        sliderRight.maximumTrackTintColor = .clear
        sliderLeft.value = 0.25
        sliderRight.value = 0.75
        normalizedValue = 0.5
        
    }
    
}
