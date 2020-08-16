
import UIKit

protocol WelcomePageVCDelegate: class {
    
    /**
     Called when the number of pages is updated.
     - parameter welcomePageVC: the TutorialPageViewController instance
     - parameter count: the total number of pages.
     */
    func welcomePageVC(_ welcomePageVC: WelcomePageVC, didUpdatePageCount count: Int)
    
    /**
     Called when the current index is updated.
     - parameter welcomePageVC: the TutorialPageViewController instance
     - parameter index: the index of the currently visible page.
     */
    func welcomePageVC(_ welcomePageVC: WelcomePageVC, didUpdatePageIndex index: Int)
    
}

extension WelcomeVC: WelcomePageVCDelegate {
    
    func welcomePageVC(_ welcomePageVC: WelcomePageVC, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func welcomePageVC(_ welcomePageVC: WelcomePageVC, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
    
}
