import UIKit

class FinalPageVC: UIViewController {
    
    //MARK: IBOutlets declaration
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var puls: UIView!
    @IBOutlet weak var puls2: UIView!
    @IBOutlet weak var okBtn: UIButton!
    
    @IBOutlet weak var urlBtn: UIButton!
    
    
    let url = URL(string: "http://pajlot.pl")
    
    //MARK: IBActions declaration
    @IBAction func okBtnTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "wizard") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage()
        
        
        urlBtn.addTarget(self, action: #selector(didTapUrl), for: .touchUpInside)
        
        prefs.set(true, forKey: Keys.welcome)
        prefs.set(true, forKey: Keys.skipped)
        print("Wyświetliłem wszystkie strony. Keys.welcome ustawiony na true")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        puls.layer.cornerRadius = 0.5 * puls.bounds.size.width
        puls2.layer.cornerRadius = 0.5 * puls2.bounds.size.width
        
        UIView.animate(withDuration: 2.0, delay: 0, options: UIViewAnimationOptions.repeat, animations: ({
            self.puls.transform = CGAffineTransform.identity.scaledBy(x: 1.3, y: 1.3)
            self.puls.alpha = 0.0
            
        }), completion: nil)
        
        UIView.animate(withDuration: 2.0, delay: 1, options: UIViewAnimationOptions.repeat, animations: ({
            self.puls2.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
            self.puls2.alpha = 0.0
            
        }), completion: nil)
        
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 6, options: [], animations: ({
            
        }), completion: nil)
    }
    
    func setUpLanguage () {
        
        headerLbl.text = NSLocalizedString("WelcomeGuideH4", comment: "WelcomeGuide headline")
        
        detailLbl.text = NSLocalizedString("WelcomeGuideP4", comment: "WelcomeGuide Paragraph")
        urlBtn.setTitle((NSLocalizedString("linkBtn", comment: "utl Button content")), for: UIControlState.normal)
        okBtn.setTitle((NSLocalizedString("JumpToCreatorBtn", comment: "OK Button content")), for: UIControlState.normal)
    }
    
    @objc func didTapUrl(sender: AnyObject) {
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}

