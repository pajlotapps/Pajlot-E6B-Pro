
import UIKit

class fuelConvInfo: UIViewController {

    @IBOutlet weak var paragraf1: UITextView!
    @IBOutlet weak var paragraf2: UITextView!
    @IBOutlet weak var paragraf3: UITextView!
    @IBOutlet weak var paragraf4: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("FuelTypeLabel", comment: "Fuel type Title").localiz()
        paragraf1.text = NSLocalizedString("FuelP1", comment: "paragraf 1").localiz()
        paragraf2.text = NSLocalizedString("FuelP2", comment: "paragraf 2").localiz()
        paragraf3.text = NSLocalizedString("FuelP3", comment: "paragraf 3").localiz()
        paragraf4.text = NSLocalizedString("FuelP4", comment: "paragraf 4").localiz()
    }
}
