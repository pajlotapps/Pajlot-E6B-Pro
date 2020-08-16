import UIKit

class WelcomeVC: UIViewController {
    
    //MARK: - Status bar hidden
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //MARK: IBOutlets declarations
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var skippedBtn: UIButton!
    
    
    let showWizard = prefs.bool(forKey: Keys.showWizard)
    
    //MARK: Variables declarations
    var welcomePageVC: WelcomePageVC? {
        didSet {
            welcomePageVC?.pageDelegate = self
        }
    }
    
    @IBAction func SkipBtnTapped(_ sender: Any) {
        prefs.set(true, forKey: Keys.skipped)
        
        if prefs.bool(forKey: Keys.wizard) && showWizard == false{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "wizard") as UIViewController
            controller.modalTransitionStyle = .crossDissolve
            present(controller, animated: true, completion: nil)
        }
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skippedBtn.setTitle((NSLocalizedString("SkipBtn", comment: "Skip Button content")), for: UIControlState.normal)
        
        pageControl.addTarget(self, action: #selector(WelcomeVC.didChangePageControlValue), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let welcomePageVC = segue.destination as? WelcomePageVC {
            self.welcomePageVC = welcomePageVC
        }
    }
    
    //MARK: Additional functions
    @objc func didChangePageControlValue() {
        welcomePageVC?.scrollToViewController(index: pageControl.currentPage)
    }
}


