import UIKit

class Weather: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "Weather", bundle: nil)
        let controller = storyboard.instantiateInitialViewController()! as UIViewController
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
}
