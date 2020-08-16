
import UIKit

class donateVC: UIViewController {
    
    //MARK: IBOutlets declarations
    @IBOutlet weak var showHideLbl: UILabel!
    @IBOutlet weak var info1: UITextView!
    @IBOutlet weak var info2: UITextView!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var dSwitch: UISwitch!
    
    //MARK: IBActions declarations
    @IBAction func donateSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            prefs.set(true, forKey: Keys.showQR)
            qrImage.isHidden = false
        }else{
            prefs.set(false, forKey: Keys.showQR)
            qrImage.isHidden = true
        }
    }
    
    //MARK: App Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("DonateTitle", comment: "Title")
        setUpLanguage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if prefs.bool(forKey: Keys.showQR) {
            dSwitch.setOn(true, animated: true);
            qrImage.isHidden = false
        }else{
            dSwitch.setOn(false, animated: true);
            qrImage.isHidden = true
        }
    }
    
    //MARK: Additioanl functions
    func setUpLanguage() {
        showHideLbl.text = NSLocalizedString("ShowHideLbl", comment: "Show/hide label")
        info1.text = NSLocalizedString("DonateInfo1", comment: "Info 1")
        info2.text = NSLocalizedString("DonateInfo2", comment: "Info 2")
    }
}
