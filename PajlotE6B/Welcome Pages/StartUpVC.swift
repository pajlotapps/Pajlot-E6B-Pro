
import UIKit

class StartUpVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("StartUpVC: viewDidload: ")
        
        let status = prefs.bool(forKey: Keys.skipped)
        print("Keys.skipped ustawiony na \(status)")
        let status2 = prefs.bool(forKey: Keys.launch)
        print("Keys.launch ustawiony na \(status2)")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let launchedBefore = prefs.bool(forKey: Keys.launch)
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            prefs.set(true, forKey: Keys.launch)
        }
        
        
        
        let test = prefs.bool(forKey: Keys.skipped)
        
        if test == false {
            print("Keys.skipped ustawiony na FALSE")
        } else {
            print("Keys.skipped ustawiony na TRUE")
            prefs.set(true, forKey: Keys.skipped)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

