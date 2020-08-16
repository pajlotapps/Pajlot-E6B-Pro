
import UIKit

class welcomeGuideONVC: UIViewController {
    
    //MARK: IBOutlets declarations
    @IBOutlet weak var welcomeGuideBtn: UIButton!
    @IBOutlet weak var welcomeGuideLbl: UILabel!
    @IBOutlet weak var info1: UITextView!
    @IBOutlet weak var info2: UITextView!
    @IBOutlet weak var wgSwitch: UISwitch!
    
    //MARK: IBActions declarations
    @IBAction func welcomeGuideSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            prefs.set(true, forKey: Keys.showWelcome)
        }else{
            prefs.set(false, forKey: Keys.showWelcome)
        }
    }
    
    @IBAction func showWelcomePages(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Welcome", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "WelcomeVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: App Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("WelcomeGuideTitle", comment: "Title")
        
        setUpLanguage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if prefs.bool(forKey: Keys.showWelcome) {
            wgSwitch.setOn(true, animated: true);
        }else{
            wgSwitch.setOn(false, animated: true);
        }
    }
    
    //MARK: Additional functions
    func setUpLanguage() {
        welcomeGuideLbl.text = NSLocalizedString("GuideLbl", comment: "Guide label")
        info1.text = NSLocalizedString("WGinfo1", comment: "Info 1")
        welcomeGuideBtn.setTitle((NSLocalizedString("WelcomeGuideBtn", comment: "WG Button content")), for: UIControlState.normal)
        
        info2.text = NSLocalizedString("WGinfo2", comment: "Info 2")
    }
    
}
