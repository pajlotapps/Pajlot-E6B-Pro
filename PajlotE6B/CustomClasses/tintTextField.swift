import UIKit

class TintTextField: UITextField {
    
    var tintedClearImage: UIImage?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setupTintColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTintColor()
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    func setupTintColor() {
        clearButtonMode = UITextFieldViewMode.whileEditing
//            borderStyle = UITextBorderStyle.roundedRect
//            layer.cornerRadius = 10.0
//            layer.masksToBounds = true
//            layer.borderColor = tintColor.cgColor
//            layer.borderWidth = 0
        backgroundColor = UIColor.clear
        textColor = UIColor.white
        //tintColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tintClearImage()
    }
    
    private func tintClearImage() {
        for view in subviews {
            if view is UIButton {
                let button = view as! UIButton
                if let uiImage = button.image(for: .highlighted) {
                    if tintedClearImage == nil {
                        tintedClearImage = tintImage(image: uiImage, color: tintColor)
                    }
                    button.setImage(tintedClearImage, for: .normal)
                    button.setImage(tintedClearImage, for: .highlighted)
                }
            }
        }
    }

}


func tintImage(image: UIImage, color: UIColor) -> UIImage {
    let size = image.size
    
    UIGraphicsBeginImageContextWithOptions(size, false, image.scale)
    let context = UIGraphicsGetCurrentContext()
    image.draw(at: CGPoint.zero, blendMode: CGBlendMode.normal, alpha: 1.0)
    
    context!.setFillColor(clearColor.cgColor)
    context!.setBlendMode(CGBlendMode.sourceIn)
    context!.setAlpha(1.0)
    
    let rect = CGRect(
        CGPoint.zero.x,
        CGPoint.zero.y,
        image.size.width,
        image.size.height)
    UIGraphicsGetCurrentContext()!.fill(rect)
    let tintedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return tintedImage!
}
