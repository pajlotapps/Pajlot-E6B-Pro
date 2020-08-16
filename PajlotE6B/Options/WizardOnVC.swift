
import UIKit

class wizardONVC: UIViewController {
    
    //MARK: IBOutlets declarations
    @IBOutlet weak var settingWizardBtn: UIButton!
    @IBOutlet weak var settingWizzardLbl: UILabel!
    @IBOutlet weak var info1: UITextView!
    @IBOutlet weak var info2: UITextView!
    
    @IBOutlet weak var wSwitch: UISwitch!
    
    //MARK: IBActions declarations
    @IBAction func wizardSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            prefs.set(true, forKey: Keys.showWizard)
        }else{
            prefs.set(false, forKey: Keys.showWizard)
        }
    }
    
    @IBAction func showWizardPages(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "set_speed") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: App Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("SettingWizzardTitle", comment: "Title")
        
        setUpLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if prefs.bool(forKey: Keys.showWizard) {
            wSwitch.setOn(true, animated: true);
        }else{
            wSwitch.setOn(false, animated: true);
        }
    }
    
    //MARK: Additioanl functions
    func setUpLanguage() {
        settingWizzardLbl.text = NSLocalizedString("WizzardLbl", comment: "Guide label")
        info1.text = NSLocalizedString("SWinfo1", comment: "Info 1")
        settingWizardBtn.setTitle((NSLocalizedString("SettingWizzardBtn", comment: "SW Button content")), for: UIControlState.normal)
        
        info2.text = NSLocalizedString("SWinfo2", comment: "Info 2")
    }
}
