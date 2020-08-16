
import UIKit

class disclaimerPopUpVC: UIViewController {
    
    
    //MARK: - HIDE STATUS BAR
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBOutlet var textViews: [UITextView]!
    
    @IBOutlet weak var disclaimerHeadline: UITextView!
    @IBOutlet weak var welcomeHeadline: UITextView!
    @IBOutlet weak var p1: UITextView!
    @IBOutlet weak var p2: UITextView!
    @IBOutlet weak var p3: UITextView!
    @IBOutlet weak var p4: UITextView!
    @IBOutlet weak var p5: UITextView!
    @IBOutlet weak var okBtn: CustomButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //UIApplication.shared.isStatusBarHidden = true
    }
        
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //UIApplication.shared.isStatusBarHidden = true
    }
        
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //UIApplication.shared.isStatusBarHidden = false
    }
    
    @IBAction func dissmissDisclaimer(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    func setUpLanguage () {
        disclaimerHeadline.text = NSLocalizedString("DisclaimerHeadline", comment: "Disclaimer headline")
        welcomeHeadline.text = NSLocalizedString("WelcomeHeadline", comment: "Welcome to headline")
        p1.text = NSLocalizedString("ParagrafOne", comment: "Content of paragraf 1")
        p2.text = NSLocalizedString("ParagrafTwo", comment: "Content of paragraf 2")
        p3.text = NSLocalizedString("ParagrafThree", comment: "Content of paragraf 3")
        p4.text = NSLocalizedString("ParagrafFour", comment: "Content of paragraf 4")
        p5.text = NSLocalizedString("ParagrafFive", comment: "Content of paragraf 5")
        okBtn.setTitle({NSLocalizedString("OKBtn", comment: "OK button label")}(), for: .normal)
    }
}
