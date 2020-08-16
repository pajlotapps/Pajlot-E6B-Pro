
import UIKit

class HomeScreenVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !prefs.bool(forKey: Keys.disclaimer) {
            let sb = UIStoryboard(name: "Disclaimer", bundle: nil)
            let popup = sb.instantiateInitialViewController()!
            self.present(popup, animated: true)
        }
    }
}
