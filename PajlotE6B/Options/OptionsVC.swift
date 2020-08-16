
import UIKit
import SafariServices

class OptionsVC: UIViewController {
    
    //MARK: IBOutlets declarations
    @IBOutlet weak var welcomeGuideLabel: UILabel!
    @IBOutlet weak var wizzardLabel: UILabel!
    @IBOutlet weak var disclaimerLabel: UILabel!
    @IBOutlet weak var optionsTV: UITextView!
    @IBOutlet weak var welcomeGuideLbl: UILabel!
    @IBOutlet weak var wizzardLbl: UILabel!
    @IBOutlet weak var disclaimerLbl: UILabel!
    @IBOutlet weak var infoLbl: UITextView!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var settingsLbl: UILabel!
    @IBOutlet weak var contactLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    @IBOutlet weak var donateLbl: UILabel!
    @IBOutlet weak var rateLbl: UILabel!
    
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var buildLabel: UILabel!
    
    //MARK: IBActions declarations
    @IBAction func rateAppBtn(sender: AnyObject) {
        rateApp(appId: "id1334810839") { success in
            print("RateApp \(success)")
        }
    }
    
    //MARK: LIFECYCLE
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        
        updateView()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Pajlot".localiz()
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        showNavigationBar()

    }
    

    
    //MARK: IBActions declarations
    @IBAction func visitWebsiteDidTap(_ sender: Any) {
        
        showSafariVC(for: "http://pajlot.pl")
        
    }
    
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
    
    //MARK: Additional functions
    func updateView() {
        setUpLanguage()
        
        if let appVersion = Bundle.main.releaseVersionNumber {
            versionLabel.text = appVersion
        }
        
        if let appBuild = Bundle.main.buildVersionNumber {
            buildLabel.text = appBuild
        }
        
        if prefs.bool(forKey: Keys.showWelcome) {
            welcomeGuideLabel.text =  NSLocalizedString("ONstatus", comment: "on status label")
        }else{
            welcomeGuideLabel.text = NSLocalizedString("OFFstatus", comment: "off status label")
        }
        
        if prefs.bool(forKey: Keys.showWizard) {
            wizzardLabel.text = NSLocalizedString("ONstatus", comment: "on status label")
        }else{
            wizzardLabel.text = NSLocalizedString("OFFstatus", comment: "off status label")
        }
        
        if prefs.bool(forKey: Keys.disclaimer) {
            disclaimerLabel.text = NSLocalizedString("OFFstatus", comment: "off status label")
        }else{
            disclaimerLabel.text = NSLocalizedString("ONstatus", comment: "on status label")
        }
    }
    

    
    
    func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    func setUpLanguage() {
        optionsTV.text = NSLocalizedString("OptionsText", comment: "OptionsText label")
        welcomeGuideLbl.text = NSLocalizedString("OptionsGuideStatus", comment: "Guide status label")
        wizzardLbl.text = NSLocalizedString("OptionsWizzardStatus", comment: "Wizzard status label")
        disclaimerLbl.text = NSLocalizedString("OptionsDisclaimerStatus", comment: "Disclaimer status label")
        infoLbl.text = NSLocalizedString("OptionsInfoLbl", comment: "OptionsInfoLbl label")
        languageLbl.text = NSLocalizedString("OptionsLanguageLbl", comment: "OptionsLanguage label")
        settingsLbl.text = NSLocalizedString("SettingsHL", comment: "Settings label")
        contactLbl.text = NSLocalizedString("OptionsContactLbl", comment: "OptionsContact label")
        websiteLbl.text = NSLocalizedString("OptionsWebsiteLbl", comment: "OptionsWebsite label")
        donateLbl.text = NSLocalizedString("DonateTitle", comment: "OptionsDonate label")
        rateLbl.text = NSLocalizedString("OptionsRateLbl", comment: "OptionsRate label")
    }
}
