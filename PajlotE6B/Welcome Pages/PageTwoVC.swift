
import UIKit

class PageTwoVC: UIViewController {
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage ()
    }
    
    func setUpLanguage () {
        
        headerLbl.text = NSLocalizedString("WelcomeGuideH2", comment: "WelcomeGuide headline")
        
        detailLbl.text = NSLocalizedString("WelcomeGuideP2", comment: "WelcomeGuide Paragraph")
    }
}
