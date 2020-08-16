
import UIKit

class dRateMoreVC: UIViewController {
    
    @IBOutlet weak var paragraf1: UITextView!
    @IBOutlet weak var paragraf2: UITextView!
    @IBOutlet weak var paragraf3: UITextView!
    @IBOutlet weak var paragraf4: UITextView!
    
    @IBOutlet weak var formula1: UITextView!
    
    @IBOutlet weak var formula2: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("GPTitle", comment: "Glide path Title")
        paragraf1.text = NSLocalizedString("GPInfo1", comment: "paragraf 1")
        paragraf2.text = NSLocalizedString("GPInfo2", comment: "paragraf 2")
        paragraf3.text = NSLocalizedString("GPInfo3", comment: "paragraf 3")
        paragraf4.text = NSLocalizedString("GPInfo4", comment: "paragraf 4")

        formula1.text = NSLocalizedString("GPformula1", comment: "formula 1")

        formula2.text = NSLocalizedString("GPformula2", comment: "formula 2")

    }
}

