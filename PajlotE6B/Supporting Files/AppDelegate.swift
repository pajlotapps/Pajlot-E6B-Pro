
import UIKit
import CoreData
import StoreKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        globalFunctions().checkReachability()
        
        if let retrived = prefs.object(forKey: Keys.lang) as? String {
            UserDefaults.standard.set([retrived], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()        }
        
        //MARK: Sekcja sprawdzająca czy pominieto strony powitalne
        let launchedBefore = prefs.bool(forKey: Keys.launch)
        let filledWizard = prefs.bool(forKey: Keys.wizard)
        let showWizard = prefs.bool(forKey: Keys.showWizard)
        let showWelcome = prefs.bool(forKey: Keys.showWelcome)

        if launchedBefore {
            print("Not first launch.")
            print("Setting Wizard filled: \(filledWizard)")
        } else {
            print("First launch, launchKey set as true")
            prefs.set(true, forKey: Keys.launch)
            prefs.set(false, forKey: Keys.showWizard)
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeStoryboard: UIStoryboard = UIStoryboard(name: "Welcome", bundle: nil)
        let wizardStoryboard: UIStoryboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
        
        var initialViewController: UIViewController
        if launchedBefore {
            if showWelcome {
                initialViewController = welcomeStoryboard.instantiateViewController(withIdentifier: "WelcomeVC")
            }else{
                if filledWizard {
                    if showWizard {
                        initialViewController = wizardStoryboard.instantiateViewController(withIdentifier: "set_speed")
                    }else{
                        initialViewController = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
                        
                        let tabBar = window?.rootViewController as? UITabBarController
                        tabBar?.selectedIndex = 2
                    }
                }else{
                    initialViewController = wizardStoryboard.instantiateViewController(withIdentifier: "set_speed")
                }
            }
        }else{
            initialViewController = welcomeStoryboard.instantiateViewController(withIdentifier: "WelcomeVC")
        }
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        
        //MARK: Sekcja stylizująca aplikację
        let navBgImage: UIImage = UIImage(named: "navBarBgImage")!
        UINavigationBar.appearance().setBackgroundImage(navBgImage, for: .default)
        
        // set navigation bar title color / tite color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barStyle = .blackTranslucent

        UITabBar.appearance().barTintColor = cellBgColor
        UITabBar.appearance().tintColor = UIColor.white
        
        
        
        
        
        //let TabBar = self.window?.rootViewController as! UITabBarController
        //TabBar.selectedIndex = 2
        
        let shortestTime: UInt32 = 50
        let longestTime: UInt32 = 500
        guard let timeInterval = TimeInterval(exactly: arc4random_uniform(longestTime - shortestTime) + shortestTime) else { return true }
        
        
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(AppDelegate.requestReview), userInfo: nil, repeats: false)
        
        
        
        return true
    }
    
    @objc func requestReview() {
        SKStoreReviewController.requestReview()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PajlotE6B")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
