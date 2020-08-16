import UIKit

extension UIViewController {

    func noData(){
        let resetAlert = UIAlertController(title: "UWAGA", message: "Dane nie zostały wprowadzone", preferredStyle: UIAlertControllerStyle.alert)
        resetAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(resetAlert, animated: true, completion: nil)
    }
    
    func selectUnits(){
        let resetAlert = UIAlertController(title: "UWAGA", message: "Jednostki nie zostały wybrane", preferredStyle: UIAlertControllerStyle.alert)
        resetAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(resetAlert, animated: true, completion: nil)
    }
    

    
    func feedBack(){
        
        let resetAlert = UIAlertController(title: "Note from developer",
                                           message: "This app was made by the aviation enthusiasts. please rate and review this app. A good review gives us the power to continue updating this app and make it even better for You. It only takes a couple of seconds",
                                           preferredStyle: UIAlertControllerStyle.alert)
        
        resetAlert.addAction(UIAlertAction(title: "Later", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in print("Później tapped")}))
        resetAlert.addAction(UIAlertAction(title: "Now", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(resetAlert, animated: true, completion: nil)
    }
}
