
import UIKit

class wizard: UIViewController {
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var loadDefaults: CustomButton!
    @IBOutlet weak var jumpToWizardBtn: CustomButton!
    @IBOutlet weak var moreInfoBtn: CustomButton!
    @IBOutlet weak var wizardInfoTF: UILabel!
    
    @IBAction func loadDefaultsAction(_ sender: Any) {
        
        selectedUnits = defUnits
        setValues = defValues
        
        let filledWizard = true
        prefs.set(filledWizard, forKey: Keys.wizard)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenTitle.text = NSLocalizedString("TitleOFTheScreenWizard", comment: "Title Of The Screen Wizard")
        
        jumpToWizardBtn.setTitle(NSLocalizedString("jumpToWizardBtn", comment: "JUMP INTO SETTINGS WIZARD"), for: UIControlState.normal)
        
        loadDefaults.setTitle(NSLocalizedString("loadDefaultsBtn", comment: "LOAD DEFAULT PRESET"), for: UIControlState.normal)
        
        moreInfoBtn.setTitle(NSLocalizedString("MoreInfoBtn", comment: "MORE INFO"), for: UIControlState.normal)

        
        wizardInfoTF.text = NSLocalizedString("WizardInfo", comment: "Wizsrd info")
    }
}

