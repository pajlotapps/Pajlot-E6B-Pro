import UIKit

class setDefSpeed: UIViewController {
    
    @IBOutlet weak var speedTF: UITextField!
    @IBOutlet weak var speedSelector: UISegmentedControl!
    @IBOutlet weak var nextBtn: CustomButton!
    @IBOutlet weak var leaveBtn: CustomButton!
    
    @IBOutlet weak var speedInfoLbl: UILabel!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    var state1: Bool = false
    var state2: Bool = false
    
    @IBAction func speedTFTapped(_ sender: Any) {
        
        if speedTF.text?.count != 0 {
            if speedTF.text?.first == "." || speedTF.text?.first == "," {
                speedTF.text = ""
                return
            }
            
            if var speedValue = speedTF.text {
                speedValue = speedValue.replacingOccurrences(of: ",", with: ".")
                prefs.set(speedValue, forKey: Keys.speedV)
                prefs.synchronize()
                state1 = true
            }
        }else{
            state1 = false
            nextBtn.isEnabled = false
            nextBtn.alpha = 0.2
        }
        
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func speedS(_ sender: Any) {
        self.view.endEditing(true)
        let val = speedSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.speed)
        selectedUnits[0] = availableUnits[0][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state2 = true
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        
        selectedUnits = defUnits
        setValues = defValues
        
        let filledWizard = true
        prefs.set(filledWizard, forKey: Keys.wizard)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "set_distance") as UIViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func leaveBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        nextBtn.isEnabled = false
        nextBtn.alpha = 0.2
        
        leaveBtn.isEnabled = false
        leaveBtn.alpha = 0.0
        //        if prefs.bool(forKey: Keys.wizard) {
        //            leaveBtn.isEnabled = true
        //            leaveBtn.alpha = 1.0
        //        }else{
        //            leaveBtn.isEnabled = false
        //            leaveBtn.alpha = 0.0
        //        }
        
        screenTitle.text = NSLocalizedString("TitleOFTheScreenWizard", comment: "Title Of The Screen Wizard")
        additionalInfo.text = NSLocalizedString("AdditionalInfoWizard", comment: "Additional Info on Wizard")
        speedInfoLbl.text = NSLocalizedString("WizardSpeedInfo", comment: "Additional Speed Info on Wizard")
        nextBtn.setTitle(NSLocalizedString("NextBtn", comment: "Next page"), for: UIControlState.normal)
        leaveBtn.setTitle(NSLocalizedString("QuitBtn", comment: "Quit wizard"), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class setDefDistance: UIViewController {
    @IBOutlet weak var distanceTF: UITextField!
    @IBOutlet weak var distanceSelector: UISegmentedControl!
    @IBOutlet weak var nextBtn: CustomButton!
    @IBOutlet weak var leaveBtn: CustomButton!
    
    @IBOutlet weak var distanceInfoLbl: UILabel!
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    var state1: Bool = false
    var state2: Bool = false
    
    @IBAction func distanceTFTapped(_ sender: Any) {
        
        if distanceTF.text?.count != 0 {
            if distanceTF.text?.first == "." || distanceTF.text?.first == "," {
                distanceTF.text = ""
                return
            }
            
            if var distanceValue = distanceTF.text {
                distanceValue = distanceValue.replacingOccurrences(of: ",", with: ".")
                
                prefs.set(distanceValue, forKey: Keys.distanceV)
                prefs.synchronize()
                state1 = true
            }
        }else{
            state1 = false
            nextBtn.isEnabled = false
            nextBtn.alpha = 0.2
        }
        
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func distanceS(_ sender: Any) {
        self.view.endEditing(true)
        let val = distanceSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.distance)
        selectedUnits[1] = availableUnits[1][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state2 = true
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        
        selectedUnits = defUnits
        setValues = defValues
        
        let filledWizard = true
        prefs.set(filledWizard, forKey: Keys.wizard)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "set_pressure") as UIViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func leaveBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        nextBtn.isEnabled = false
        nextBtn.alpha = 0.2
        
        leaveBtn.isEnabled = false
        leaveBtn.alpha = 0.0
        //        if prefs.bool(forKey: Keys.wizard) {
        //            leaveBtn.isEnabled = true
        //            leaveBtn.alpha = 1.0
        //        }else{
        //            leaveBtn.isEnabled = false
        //            leaveBtn.alpha = 0.0
        //        }
        
        screenTitle.text = NSLocalizedString("TitleOFTheScreenWizard", comment: "Title Of The Screen Wizard")
        additionalInfo.text = NSLocalizedString("AdditionalInfoWizard", comment: "Additional Info on Wizard")
        distanceInfoLbl.text = NSLocalizedString("WizardDistanceInfo", comment: "Additional distance Info on Wizard")
        nextBtn.setTitle(NSLocalizedString("NextBtn", comment: "Next page"), for: UIControlState.normal)
        leaveBtn.setTitle(NSLocalizedString("QuitBtn", comment: "Quit wizard"), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class setDefPressure: UIViewController {
    
    @IBOutlet weak var pressureTF: UITextField!
    @IBOutlet weak var pressureSelector: UISegmentedControl!
    @IBOutlet weak var nextBtn: CustomButton!
    @IBOutlet weak var leaveBtn: CustomButton!
    @IBOutlet weak var pressureInfoLbl: UILabel!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    var state1: Bool = false
    var state2: Bool = false
    
    @IBAction func pressureTFTapped(_ sender: Any) {
        
        if pressureTF.text?.count != 0 {
            if pressureTF.text?.first == "." || pressureTF.text?.first == "," {
                pressureTF.text = ""
                return
            }
            
            if var pressureValue = pressureTF.text {
                pressureValue = pressureValue.replacingOccurrences(of: ",", with: ".")
                prefs.set(pressureValue, forKey: Keys.pressV)
                prefs.synchronize()
                state1 = true
            }
        }else{
            state1 = false
            nextBtn.isEnabled = false
            nextBtn.alpha = 0.2
        }
        
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func pressureS(_ sender: Any) {
        self.view.endEditing(true)
        let val = pressureSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.press)
        selectedUnits[11] = availableUnits[11][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state2 = true
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        
        selectedUnits = defUnits
        setValues = defValues
        
        let filledWizard = true
        prefs.set(filledWizard, forKey: Keys.wizard)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "set_temperature") as UIViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func leaveBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        nextBtn.isEnabled = false
        nextBtn.alpha = 0.2
        
        
        leaveBtn.isEnabled = false
        leaveBtn.alpha = 0.0
        //        if prefs.bool(forKey: Keys.wizard) {
        //            leaveBtn.isEnabled = true
        //            leaveBtn.alpha = 1.0
        //        }else{
        //            leaveBtn.isEnabled = false
        //            leaveBtn.alpha = 0.0
        //        }
        
        screenTitle.text = NSLocalizedString("TitleOFTheScreenWizard", comment: "Title Of The Screen Wizard")
        additionalInfo.text = NSLocalizedString("AdditionalInfoWizard", comment: "Additional Info on Wizard")
        pressureInfoLbl.text = NSLocalizedString("WizardPressureInfo", comment: "Additional pressure Info on Wizard")
        nextBtn.setTitle(NSLocalizedString("NextBtn", comment: "Next page"), for: UIControlState.normal)
        leaveBtn.setTitle(NSLocalizedString("QuitBtn", comment: "Quit wizard"), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class setDefTemperature: UIViewController {
    
    @IBOutlet weak var temperatureTF: UITextField!
    @IBOutlet weak var temperatureSelector: UISegmentedControl!
    @IBOutlet weak var nextBtn: CustomButton!
    @IBOutlet weak var leaveBtn: CustomButton!
    
    @IBOutlet weak var temperatureInfoLbl: UILabel!
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    var state1: Bool = false
    var state2: Bool = false
    
    @IBAction func temperatureTFTapped(_ sender: Any) {
        
        if temperatureTF.text?.count != 0 {
            if temperatureTF.text?.first == "." || temperatureTF.text?.first == "," {
                temperatureTF.text = ""
                return
            }
            
            if var temperatureValue = temperatureTF.text {
                temperatureValue = temperatureValue.replacingOccurrences(of: ",", with: ".")
                prefs.set(temperatureValue, forKey: Keys.tempV)
                prefs.synchronize()
                state1 = true
            }
        }else{
            state1 = false
            nextBtn.isEnabled = false
            nextBtn.alpha = 0.2
        }
        
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func temperatureS(_ sender: Any) {
        self.view.endEditing(true)
        let val = temperatureSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.temp)
        selectedUnits[10] = availableUnits[10][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state2 = true
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        
        selectedUnits = defUnits
        setValues = defValues
        
        let filledWizard = true
        prefs.set(filledWizard, forKey: Keys.wizard)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "set_elevation") as UIViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func leaveBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        nextBtn.isEnabled = false
        nextBtn.alpha = 0.2
        
        leaveBtn.isEnabled = false
        leaveBtn.alpha = 0.0
        //        if prefs.bool(forKey: Keys.wizard) {
        //            leaveBtn.isEnabled = true
        //            leaveBtn.alpha = 1.0
        //        }else{
        //            leaveBtn.isEnabled = false
        //            leaveBtn.alpha = 0.0
        //        }
        
        screenTitle.text = NSLocalizedString("TitleOFTheScreenWizard", comment: "Title Of The Screen Wizard")
        additionalInfo.text = NSLocalizedString("AdditionalInfoWizard", comment: "Additional Info on Wizard")
        temperatureInfoLbl.text = NSLocalizedString("WizardTemperatureInfo", comment: "Additional temp Info on Wizard")
        nextBtn.setTitle(NSLocalizedString("NextBtn", comment: "Next page"), for: UIControlState.normal)
        leaveBtn.setTitle(NSLocalizedString("QuitBtn", comment: "Quit wizard"), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class setDefElevation: UIViewController {
    
    @IBOutlet weak var elevationTF: UITextField!
    @IBOutlet weak var elevationSelector: UISegmentedControl!
    @IBOutlet weak var nextBtn: CustomButton!
    @IBOutlet weak var leaveBtn: CustomButton!
    
    @IBOutlet weak var elevationInfoLbl: UILabel!
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    var state1: Bool = false
    var state2: Bool = false
    
    @IBAction func elevationTFTapped(_ sender: Any) {
        
        if elevationTF.text?.count != 0 {
            if elevationTF.text?.first == "." || elevationTF.text?.first == "," {
                elevationTF.text = ""
                return
            }
            
            if var elevationValue = elevationTF.text {
                elevationValue = elevationValue.replacingOccurrences(of: ",", with: ".")
                prefs.set(elevationValue, forKey: Keys.elevV)
                prefs.synchronize()
                state1 = true
            }
        }else{
            state1 = false
            nextBtn.isEnabled = false
            nextBtn.alpha = 0.2
        }
        
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func elevationS(_ sender: Any) {
        self.view.endEditing(true)
        let val = elevationSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.elev)
        selectedUnits[7] = availableUnits[7][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state2 = true
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        
        selectedUnits = defUnits
        setValues = defValues
        
        let filledWizard = true
        prefs.set(filledWizard, forKey: Keys.wizard)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func leaveBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "set_wind") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        nextBtn.isEnabled = false
        nextBtn.alpha = 0.2
        
        leaveBtn.isEnabled = false
        leaveBtn.alpha = 0.0
        //        if prefs.bool(forKey: Keys.wizard) {
        //            leaveBtn.isEnabled = true
        //            leaveBtn.alpha = 1.0
        //        }else{
        //            leaveBtn.isEnabled = false
        //            leaveBtn.alpha = 0.0
        //        }
        
        screenTitle.text = NSLocalizedString("TitleOFTheScreenWizard", comment: "Title Of The Screen Wizard")
        additionalInfo.text = NSLocalizedString("AdditionalInfoWizard", comment: "Additional Info on Wizard")
        
        elevationInfoLbl.text = NSLocalizedString("WizardElevationInfo", comment: "Additional elevation Info on Wizard")
        nextBtn.setTitle(NSLocalizedString("NextBtn", comment: "Next page"), for: UIControlState.normal)
        leaveBtn.setTitle(NSLocalizedString("QuitBtn", comment: "Quit wizard"), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class setDefWind: UIViewController {
    
    @IBOutlet weak var windDirTF: UITextField!
    @IBOutlet weak var windSpeedTF: UITextField!
    @IBOutlet weak var windSelector: UISegmentedControl!
    @IBOutlet weak var nextBtn: CustomButton!
    @IBOutlet weak var leaveBtn: CustomButton!
    
    @IBOutlet weak var windInfoLbl: UILabel!
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    var state1: Bool = false
    var state2: Bool = false
    var state3: Bool = false
    
    @IBAction func windDirTFTapped(_ sender: Any) {
        
        if windDirTF.text?.count != 0 {
            if windDirTF.text?.first == "." || windDirTF.text?.first == "," {
                windDirTF.text = ""
                return
            }
            
            if var windDirValue = windDirTF.text {
                windDirValue = windDirValue.replacingOccurrences(of: ",", with: ".")
                prefs.set(windDirValue, forKey: Keys.windDirV)
                prefs.synchronize()
                state1 = true
            }
        }else{
            state1 = false
            nextBtn.isEnabled = false
            nextBtn.alpha = 0.2
        }
        
        if state1 && state2 && state3 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func windSpeedTFTapped(_ sender: Any) {
        
        if windSpeedTF.text?.count != 0 {
            if windSpeedTF.text?.first == "." || windSpeedTF.text?.first == "," {
                windSpeedTF.text = ""
                return
            }
            
            if var windSpeedValue = windSpeedTF.text {
                windSpeedValue = windSpeedValue.replacingOccurrences(of: ",", with: ".")
                prefs.set(windSpeedValue, forKey: Keys.windV)
                prefs.synchronize()
                state2 = true
            }
        }else{
            state2 = false
            nextBtn.isEnabled = false
            nextBtn.alpha = 0.2
        }
        
        if state1 && state2 && state3 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func windS(_ sender: Any) {
        self.view.endEditing(true)
        let val = windSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.wind)
        selectedUnits[5] = availableUnits[5][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state3 = true
        if state1 && state2 && state3 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        
        selectedUnits = defUnits
        setValues = defValues
        
        let filledWizard = true
        prefs.set(filledWizard, forKey: Keys.wizard)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "set_fuel") as UIViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func leaveBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        nextBtn.isEnabled = false
        nextBtn.alpha = 0.2
        
        leaveBtn.isEnabled = false
        leaveBtn.alpha = 0.0
        //        if prefs.bool(forKey: Keys.wizard) {
        //            leaveBtn.isEnabled = true
        //            leaveBtn.alpha = 1.0
        //        }else{
        //            leaveBtn.isEnabled = false
        //            leaveBtn.alpha = 0.0
        //        }
        
        screenTitle.text = NSLocalizedString("TitleOFTheScreenWizard", comment: "Title Of The Screen Wizard")
        additionalInfo.text = NSLocalizedString("AdditionalInfoWizard", comment: "Additional Info on Wizard")
        
        windInfoLbl.text = NSLocalizedString("WizardWindInfo", comment: "Additional wind Info on Wizard")
        nextBtn.setTitle(NSLocalizedString("NextBtn", comment: "Next page"), for: UIControlState.normal)
        leaveBtn.setTitle(NSLocalizedString("QuitBtn", comment: "Quit wizard"), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class setDefFuel: UIViewController {
    
    @IBOutlet weak var fuelTF: UITextField!
    @IBOutlet weak var fuelRateSelector: UISegmentedControl!
    @IBOutlet weak var fuelSelector: UISegmentedControl!
    @IBOutlet weak var nextBtn: CustomButton!
    @IBOutlet weak var leaveBtn: CustomButton!
    
    @IBOutlet weak var fuelInfoLbl: UILabel!
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    var state1: Bool = false
    var state2: Bool = false
    var state3: Bool = false
    
    @IBAction func fuelTFTapped(_ sender: Any) {
        
        if fuelTF.text?.count != 0 {
            if fuelTF.text?.first == "." || fuelTF.text?.first == "," {
                fuelTF.text = ""
                return
            }
            
            if var fuelValue = fuelTF.text {
                fuelValue = fuelValue.replacingOccurrences(of: ",", with: ".")
                prefs.set(fuelValue, forKey: Keys.fuelV)
                prefs.synchronize()
                state1 = true
            }
        }else{
            state1 = false
            nextBtn.isEnabled = false
            nextBtn.alpha = 0.2
        }
        
        if state1 && state2 && state3 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func fuelRateS(_ sender: Any) {
        self.view.endEditing(true)
        let val = fuelRateSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.fuel)
        selectedUnits[6] = availableUnits[6][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state2 = true
        
        if state1 && state2 && state3 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func fuelS(_ sender: Any) {
        self.view.endEditing(true)
        let val = fuelSelector.selectedSegmentIndex
        if val == 0 {
            fuelType = "JET A1"
        }else{
            fuelType = "AVGAS"
        }
        prefs.set(fuelType, forKey: Keys.fuelTypeV)
        state3 = true
        if state1 && state2 && state3 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        
        selectedUnits = defUnits
        setValues = defValues
        
        let filledWizard = true
        prefs.set(filledWizard, forKey: Keys.wizard)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "set_deviation") as UIViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func leaveBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        nextBtn.isEnabled = false
        nextBtn.alpha = 0.2
        
        leaveBtn.isEnabled = false
        leaveBtn.alpha = 0.0
        //        if prefs.bool(forKey: Keys.wizard) {
        //            leaveBtn.isEnabled = true
        //            leaveBtn.alpha = 1.0
        //        }else{
        //            leaveBtn.isEnabled = false
        //            leaveBtn.alpha = 0.0
        //        }
        
        screenTitle.text = NSLocalizedString("TitleOFTheScreenWizard", comment: "Title Of The Screen Wizard")
        additionalInfo.text = NSLocalizedString("AdditionalInfoWizard", comment: "Additional Info on Wizard")
        
        fuelInfoLbl.text = NSLocalizedString("WizardFuelInfo", comment: "Additional fuel Info on Wizard")
        nextBtn.setTitle(NSLocalizedString("NextBtn", comment: "Next page"), for: UIControlState.normal)
        leaveBtn.setTitle(NSLocalizedString("QuitBtn", comment: "Quit wizard"), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class setDefVariation: UIViewController {
    
    @IBOutlet weak var devTF: UITextField!
    @IBOutlet weak var devDirSelector: UISegmentedControl!
    @IBOutlet weak var nextBtn: CustomButton!
    @IBOutlet weak var leaveBtn: CustomButton!
    
    @IBOutlet weak var variationInfoLbl: UILabel!
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    var state1: Bool = false
    var state2: Bool = false
    
    @IBAction func devTFTapped(_ sender: Any) {
        
        if devTF.text?.count != 0 {
            if devTF.text?.first == "." || devTF.text?.first == "," {
                devTF.text = ""
                return
            }
            
            if var magDecValue = devTF.text {
                magDecValue = magDecValue.replacingOccurrences(of: ",", with: ".")
                prefs.set(magDecValue, forKey: Keys.magDecV)
                prefs.synchronize()
                state1 = true
            }
        }else{
            state1 = false
            nextBtn.isEnabled = false
            nextBtn.alpha = 0.2
        }
        
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func devS(_ sender: Any) {
        self.view.endEditing(true)
        let val = devDirSelector.selectedSegmentIndex
        if val == 0 {
            varDir = "E"
        }else{
            varDir = "W"
        }
        prefs.set(varDir, forKey: Keys.varDirV)
        
        state2 = true
        if state1 && state2 {
            nextBtn.isEnabled = true
            nextBtn.alpha = 1.0
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        
        selectedUnits = defUnits
        setValues = defValues
        
        let filledWizard = true
        prefs.set(filledWizard, forKey: Keys.wizard)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func nextBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SetDefaultsWizard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "set_units") as UIViewController
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func leaveBtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        nextBtn.isEnabled = false
        nextBtn.alpha = 0.2
        
        leaveBtn.isEnabled = false
        leaveBtn.alpha = 0.0
        //        if prefs.bool(forKey: Keys.wizard) {
        //            leaveBtn.isEnabled = true
        //            leaveBtn.alpha = 1.0
        //        }else{
        //            leaveBtn.isEnabled = false
        //            leaveBtn.alpha = 0.0
        //        }
        
        screenTitle.text = NSLocalizedString("TitleOFTheScreenWizard", comment: "Title Of The Screen Wizard")
        additionalInfo.text = NSLocalizedString("AdditionalInfoWizard", comment: "Additional Info on Wizard")
        variationInfoLbl.text = NSLocalizedString("WizardVariationInfo", comment: "Additional Variation Info on Wizard")
        
        nextBtn.setTitle(NSLocalizedString("NextBtn", comment: "Next page"), for: UIControlState.normal)
        leaveBtn.setTitle(NSLocalizedString("QuitBtn", comment: "Quit wizard"), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class setDefUnits: UIViewController {
    
    @IBOutlet weak var timeSelector: UISegmentedControl!
    @IBOutlet weak var vspeedSelector: UISegmentedControl!
    @IBOutlet weak var heightSelector: UISegmentedControl!
    @IBOutlet weak var volumeSelector: UISegmentedControl!
    @IBOutlet weak var weightSelector: UISegmentedControl!
    @IBOutlet weak var angleSelector: UISegmentedControl!
    @IBOutlet weak var fuelSelector: UISegmentedControl!
    
    @IBOutlet weak var endBtn: CustomButton!
    
    @IBOutlet weak var unitsInfoLbl: UILabel!
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var additionalInfo: UILabel!
    
    var state1: Bool = false
    var state2: Bool = false
    var state3: Bool = false
    var state4: Bool = false
    var state5: Bool = false
    var state6: Bool = false
    var state7: Bool = false
    
    @IBAction func timeS(_ sender: Any) {
        let val = timeSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.time)
        selectedUnits[2] = availableUnits[2][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state1 = true
        
        if state1 && state2 && state3 && state4 && state5 && state6 && state7 {
            endBtn.isEnabled = true
            endBtn.alpha = 1.0
        }
    }
    
    @IBAction func vspeedS(_ sender: Any) {
        let val = vspeedSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.time)
        selectedUnits[3] = availableUnits[3][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state2 = true
        
        if state1 && state2 && state3 && state4 && state5 && state6 && state7 {
            endBtn.isEnabled = true
            endBtn.alpha = 1.0
        }
    }
    
    @IBAction func heightS(_ sender: Any) {
        let val = heightSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.height)
        selectedUnits[4] = availableUnits[4][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state3 = true
        
        if state1 && state2 && state3 && state4 && state5 && state6 && state7 {
            endBtn.isEnabled = true
            endBtn.alpha = 1.0
        }
    }
    
    @IBAction func volumeS(_ sender: Any) {
        let val = volumeSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.vol)
        selectedUnits[8] = availableUnits[8][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state4 = true
        
        if state1 && state2 && state3 && state4 && state5 && state6 && state7 {
            endBtn.isEnabled = true
            endBtn.alpha = 1.0
        }
    }
    
    @IBAction func weightS(_ sender: Any) {
        let val = weightSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.weight)
        selectedUnits[9] = availableUnits[9][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state5 = true
        
        if state1 && state2 && state3 && state4 && state5 && state6 && state7 {
            endBtn.isEnabled = true
            endBtn.alpha = 1.0
        }
    }
    
    @IBAction func angleS(_ sender: Any) {
        let val = angleSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.angle)
        selectedUnits[12] = availableUnits[12][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state6 = true
        
        if state1 && state2 && state3 && state4 && state5 && state6 && state7 {
            endBtn.isEnabled = true
            endBtn.alpha = 1.0
        }
    }
    
    @IBAction func fuelS(_ sender: Any) {
        let val = fuelSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.useableFuel)
        selectedUnits[13] = availableUnits[13][val]
        prefs.set(selectedUnits, forKey: Keys.units)
        state7 = true
        
        if state1 && state2 && state3 && state4 && state5 && state6 && state7 {
            endBtn.isEnabled = true
            endBtn.alpha = 1.0
        }
    }
    
    @IBAction func quitAction(_ sender: Any) {
        
        selectedUnits = defUnits
        setValues = defValues
        
        let filledWizard = true
        prefs.set(filledWizard, forKey: Keys.wizard)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func endBtnTapped(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainVC") as UIViewController
        controller.modalTransitionStyle = .crossDissolve
        present(controller, animated: true, completion: nil)
        
        let filledWizard = true
        prefs.set(filledWizard, forKey: Keys.wizard)
    }
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        endBtn.isEnabled = false
        endBtn.alpha = 0.2
        
        screenTitle.text = NSLocalizedString("TitleOFTheScreenWizard", comment: "Title Of The Screen Wizard")
        additionalInfo.text = NSLocalizedString("AdditionalInfoWizard", comment: "Additional Info on Wizard")
        unitsInfoLbl.text = NSLocalizedString("WizardUnitsInfo", comment: "Additional Units Info on Wizard")
        endBtn.setTitle(NSLocalizedString("finishBtn", comment: "Finish wizard"), for: UIControlState.normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}



