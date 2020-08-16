
import UIKit

class disclaimerVC: UIViewController {
    
    @IBOutlet weak var disclaimerVCBtn: UIButton!
    @IBOutlet weak var disclaimerLbl: UILabel!
    @IBOutlet weak var info1: UITextView!
    @IBOutlet weak var info2: UITextView!
    
    @IBOutlet weak var dSwitch: UISwitch!
    @IBAction func disclaimerSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            prefs.set(false, forKey: Keys.disclaimer)
            
        }else{
            prefs.set(true, forKey: Keys.disclaimer)
        }
    }
    
    @IBAction func disclaimer(_ sender: Any) {
        let sb = UIStoryboard(name: "Disclaimer", bundle: nil)
        let popup = sb.instantiateInitialViewController()!
        self.present(popup, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("DisclaimerTitle", comment: "Title")
        
        setUpLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if prefs.bool(forKey: Keys.disclaimer) {
            dSwitch.setOn(false, animated: true);
        }else{
            dSwitch.setOn(true, animated: true);
        }
    }
    
    func setUpLanguage() {
        disclaimerLbl.text = NSLocalizedString("DisclaimerLbl", comment: "Disclaimer label")
        info1.text = NSLocalizedString("Dinfo1", comment: "Info 1")
        disclaimerVCBtn.setTitle((NSLocalizedString("DisclaimerVCBtn", comment: "Disclaimer Button content")), for: UIControlState.normal)
        
        info2.text = NSLocalizedString("Dinfo2", comment: "Info 2")
    }
    
}

