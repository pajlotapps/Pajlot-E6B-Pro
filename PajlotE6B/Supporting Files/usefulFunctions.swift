
import UIKit

class usefulFunctions: UIViewController {
    
    func jumpToUpgradeVC () {
//        let storyboard = UIStoryboard(name: "Upgrade", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "upgradeVC") as UIViewController
//        controller.modalTransitionStyle = .crossDissolve
//        self.present(controller, animated: true, completion: nil)
        
        
        let controller = UIStoryboard(name: "Upgrade", bundle: nil).instantiateViewController(withIdentifier: "upgradeVC")
        UIApplication.topViewController()?.present(controller, animated: true, completion: nil)
        
        
    }
}
