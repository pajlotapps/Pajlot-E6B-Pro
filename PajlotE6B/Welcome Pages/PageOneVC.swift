
import UIKit

class PageOneVC: UIViewController {
    
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage ()
    }
    
    func setUpLanguage () {
        
        headerLbl.text = NSLocalizedString("WelcomeGuideH1", comment: "WelcomeGuide headline")
        
        detailLbl.text = NSLocalizedString("WelcomeGuideP1", comment: "WelcomeGuide Paragraph")
    }
}

