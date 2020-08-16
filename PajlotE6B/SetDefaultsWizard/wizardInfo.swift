
import UIKit

class wizardInfo: UIViewController {
    
    //MARK: - HIDE STATUS BAR
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet weak var disclaimerHeadline: UITextView!
    @IBOutlet weak var p1: UITextView!
    @IBOutlet weak var p2: UITextView!
    @IBOutlet weak var p3: UITextView!
    @IBOutlet weak var p4: UITextView!
    @IBOutlet weak var okBtn: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        UIApplication.shared.isStatusBarHidden = true
//    }
    
//    override open func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        UIApplication.shared.isStatusBarHidden = true
//    }
    
//    override open func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        UIApplication.shared.isStatusBarHidden = false
//    }
    
//    override open var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    @IBAction func dissmissInformation(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpLanguage () {
        disclaimerHeadline.text = NSLocalizedString("InfoHeadline", comment: "Info headline")
        p1.text = NSLocalizedString("WizardInfoP1", comment: "Content of paragraf 1")
        p2.text = NSLocalizedString("WizardInfoP2", comment: "Content of paragraf 2")
        p3.text = NSLocalizedString("WizardInfoP3", comment: "Content of paragraf 3")
        p4.text = NSLocalizedString("WizardInfoP4", comment: "Content of paragraf 4")
        okBtn.setTitle({NSLocalizedString("OKBtn", comment: "OK button label")}(), for: .normal)
    }
}


