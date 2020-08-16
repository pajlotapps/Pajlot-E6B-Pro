
import UIKit

class PageThreeVC: UIViewController {

    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage ()
    }
    
    func setUpLanguage () {
        
        headerLbl.text = NSLocalizedString("WelcomeGuideH3", comment: "WelcomeGuide headline")
        
        detailLbl.text = NSLocalizedString("WelcomeGuideP3", comment: "WelcomeGuide Paragraph")
    }
}
