
import UIKit

class densityAltInfo: UIViewController {
    
    @IBOutlet weak var paragraf1: UITextView!
    @IBOutlet weak var paragraf2: UITextView!
    @IBOutlet weak var paragraf3: UITextView!
    @IBOutlet weak var paragraf4: UITextView!
    @IBOutlet weak var paragraf5: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("DensityAltLabel", comment: "Density Altitude Title")
        paragraf1.text = NSLocalizedString("DensityAltInfo1", comment: "paragraf 1")
        paragraf2.text = NSLocalizedString("DensityAltInfo2", comment: "paragraf 2")
        paragraf3.text = NSLocalizedString("DensityAltInfo3", comment: "paragraf 3")
        paragraf4.text = NSLocalizedString("DensityAltInfo4", comment: "paragraf 4")
        paragraf5.text = NSLocalizedString("DensityAltInfo5", comment: "paragraf 5")
    }
}
