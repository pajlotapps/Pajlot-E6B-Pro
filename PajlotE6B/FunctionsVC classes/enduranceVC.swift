
import UIKit

class enduranceVC: UIViewController,
                    UITextFieldDelegate,
                    UIScrollViewDelegate {
    
    //MARK: Properties
    var useableFuelVal: Float = 0.0
    var fuelFlowRateVal: Float = 0.0
    var resultTime: Float = 0.0
    
    var hhmmss = [[String]]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: IBOutlets: textfields
    @IBOutlet weak var inputUseableFuel: UITextField!
    @IBOutlet weak var inputFuelFlowRate: UITextField!
    
    // MARK: IBOutlets: sliders
    @IBOutlet weak var ufSlider: UISlider!
    @IBOutlet weak var ffrSlider: UISlider!
    
    // MARK: IBOutlets: labels
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var resultUlbl: UILabel!
    @IBOutlet weak var useableFuelUlbl: UILabel!
    @IBOutlet weak var fuelFlowRateUlbl: UILabel!
    @IBOutlet weak var fuelTypelbl: UILabel!
    @IBOutlet weak var fuellbl: UILabel!

    // MARK: IBOutlets: views
    @IBOutlet weak var tContainer: UIView!
    @IBOutlet weak var bContainer: UIView!
    @IBOutlet weak var defaultBox: UIView!
    
    @IBOutlet weak var defaultBtn: UIButton!
    var hideBarButton : UIBarButtonItem!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("EnduranceLabel", comment: "Endurance Title").localiz()
        fuellbl.text = NSLocalizedString("FuelTypeLabel", comment: "Fuel type")
        defaultBtn.setTitle((NSLocalizedString("setDefaultFuelFlow", comment: "Default Fuel Flow Btn")), for: UIControlState.normal)
        updateView()
        calculate()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollV.addGestureRecognizer(tapGesture)
        
        //hide keypad btn
        let hideBtn = UIButton.init(type: .custom)
        hideBtn.setImage(UIImage.init(named: "hideKeypad.png"), for: UIControlState.normal)
        hideBtn.addTarget(self, action:#selector(hideKeyboard), for: UIControlEvents.touchUpInside)
        hideBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 20)
        hideBarButton = UIBarButtonItem.init(customView: hideBtn)
        
        //custom textField
        inputUseableFuel.attributedPlaceholder = NSAttributedString(string:"ilość paliwa", attributes:[NSAttributedStringKey.foregroundColor: phColor])
        
        inputFuelFlowRate.attributedPlaceholder = NSAttributedString(string:"zużycie", attributes:[NSAttributedStringKey.foregroundColor: phColor])
        
        
        defaultBox.layer.cornerRadius = 10.0

    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateView()
        calculate()
    }
    
    override func viewDidLayoutSubviews() {
        tContainer.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        bContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        useableFuelVal = round(100*ufSlider.value)/100
        selValues.useableFuel = String(useableFuelVal)
        
        fuelFlowRateVal = round(100*ffrSlider.value)/100
        selValues.fuelflow = String(fuelFlowRateVal)
        
        if inputUseableFuel.text != "" {
            ufSlider.value = Float(inputUseableFuel.text!)!
        }else{
            ufSlider.value = 0.0
        }
        
        if inputFuelFlowRate.text != "" {
            ffrSlider.value = Float(inputFuelFlowRate.text!)!
        }else{
            ffrSlider.value = 0.0
        }
        hideKeyboard()
        
    }
    
    //MARK: IBActions
    @IBAction func upgradePro(_ sender: Any) {
        usefulFunctions().jumpToUpgradeVC()
    }
    
    //MARK: IBActions > useableFuel section
    @IBAction func useableFuelTFTapped(_ sender: UITextField) {
        if inputUseableFuel.text?.count != 0 {
            if inputUseableFuel.text?.first == "." || inputUseableFuel.text?.first == "," {
                inputUseableFuel.text = ""
                return
            }
            if var val = inputUseableFuel.text {
                selValues.useableFuel = val
                val = val.replacingOccurrences(of: ",", with: ".")
                useableFuelVal = Float(val)!
                inputUseableFuel.text = val
            }
        }else{
            useableFuelVal = 0.0
        }
        hideKeyboard()
    }
    
    @IBAction func useableFuelSlider(_ sender: UISlider) {
        useableFuelVal = (sender.value).roundTo(places: 1)
        selValues.useableFuel = String(useableFuelVal)
        inputUseableFuel.text = String(useableFuelVal)
        hideKeyboard()
    }
    
    @IBAction func decreaseUseableFuel(_ sender: Any) {
        if useableFuelVal <= 4000 && useableFuelVal >= 1 {
            useableFuelVal = useableFuelVal.roundTo(places: 1)
            useableFuelVal -= 1.0
            selValues.useableFuel = String(useableFuelVal)
            inputUseableFuel.text = String(useableFuelVal)
            ufSlider.value = useableFuelVal
        }
    }
    
    @IBAction func increaseUseableFuel(_ sender: Any) {
        if useableFuelVal >= 0 && useableFuelVal <= (3999) {
            useableFuelVal = useableFuelVal.roundTo(places: 1)
            useableFuelVal += 1.0
            selValues.useableFuel = String(useableFuelVal)
            inputUseableFuel.text = String(useableFuelVal)
            ufSlider.value = useableFuelVal
        }
    }
    
    //MARK: - IBActions > FuelFlowRate section
    @IBAction func fuelFlowRateTFTapped(_ sender: UITextField) {
        
        if inputFuelFlowRate.text?.count != 0 {
            if inputFuelFlowRate.text?.first == "." || inputFuelFlowRate.text?.first == "," {
                inputFuelFlowRate.text = ""
                return
            }
            if var val = inputFuelFlowRate.text {
                selValues.fuelflow = val
                val = val.replacingOccurrences(of: ",", with: ".")
                fuelFlowRateVal = Float(val)!
                inputFuelFlowRate.text = val
            }
        }else{
            fuelFlowRateVal = 0.0
        }
        hideKeyboard()
    }
    
    @IBAction func fuelFlowRateSlider(_ sender: UISlider) {
        fuelFlowRateVal = (sender.value).roundTo(places: 1)
        selValues.fuelflow = String(fuelFlowRateVal)
        inputFuelFlowRate.text = String(fuelFlowRateVal)
        hideKeyboard()
    }
    
    @IBAction func decreaseFuelFlowRate(_ sender: Any) {
        if fuelFlowRateVal <= 1500 && fuelFlowRateVal >= 1 {
            fuelFlowRateVal = fuelFlowRateVal.roundTo(places: 1)
            fuelFlowRateVal -= 1.0
            selValues.fuelflow = String(fuelFlowRateVal)
            inputFuelFlowRate.text = String(fuelFlowRateVal)
            ffrSlider.value = fuelFlowRateVal
        }
    }
    
    @IBAction func increaseFuelFlowRate(_ sender: Any) {
        if fuelFlowRateVal >= 0 && fuelFlowRateVal <= (1499) {
            fuelFlowRateVal = fuelFlowRateVal.roundTo(places: 1)
            fuelFlowRateVal += 1.0
            selValues.fuelflow = String(fuelFlowRateVal)
            inputFuelFlowRate.text = String(fuelFlowRateVal)
            ffrSlider.value = fuelFlowRateVal
        }
    }
    @IBAction func defaultFuelFlow(_ sender: Any) {
        if setValues[7] == 0 {
            fuelFlowRateVal = 300.0
            selValues.fuelflow = String(fuelFlowRateVal)
            inputFuelFlowRate.text = String(fuelFlowRateVal)
            ffrSlider.value = fuelFlowRateVal
        }else{
            fuelFlowRateVal = Float(setValues[7])
            selValues.fuelflow = String(fuelFlowRateVal)
            inputFuelFlowRate.text = String(fuelFlowRateVal)
            ffrSlider.value = fuelFlowRateVal
        }
        calculate()
    }
    
    // MARK: - Functions
    func calculate(){
        let usableFuelUnit = selectedUnits[13]
        let fuelFlowRateUnit = selectedUnits[6]
        let timeUnit = selectedUnits[2]

        var ufL : Float
        var ffrLPH : Float
        var timeS : Int
        
        let hours : String
        let minutes : String
        let seconds : String
        
        useableFuelVal = ufSlider.value
        fuelFlowRateVal = ffrSlider.value
        
        
        switch fuelType {
            case "JET A1":
                switch usableFuelUnit {
                    case "l":
                        ufL = useableFuelVal
                    case "kg":
                        ufL = useableFuelVal / 0.79
                    case "lb":
                        ufL = useableFuelVal / 1.76
                    default:
                        ufL = useableFuelVal
                }
            
                switch fuelFlowRateUnit {
                    case "l/h":
                        ffrLPH = fuelFlowRateVal
                    case "kg/h":
                        ffrLPH = fuelFlowRateVal / 0.79
                    case "lbs/h":
                        ffrLPH = fuelFlowRateVal / 1.76
                    default:
                        ffrLPH = fuelFlowRateVal
                }
            
            case "AVGAS":
                switch usableFuelUnit {
                    case "l":
                        ufL = useableFuelVal
                    case "kg":
                        ufL = useableFuelVal / 0.72
                    case "lb":
                        ufL = useableFuelVal / 1.58
                    default:
                        ufL = useableFuelVal
                    }
            
                switch fuelFlowRateUnit {
                    case "l/h":
                        ffrLPH = fuelFlowRateVal
                    case "kg/h":
                        ffrLPH = fuelFlowRateVal / 0.72
                    case "lbs/h":
                        ffrLPH = fuelFlowRateVal / 1.58
                    default:
                        ffrLPH = fuelFlowRateVal
            }
            default:
                switch usableFuelUnit {
                    case "l":
                        ufL = useableFuelVal
                    case "kg":
                        ufL = useableFuelVal / 0.79
                    case "lb":
                        ufL = useableFuelVal / 1.76
                    default:
                        ufL = useableFuelVal
                }
            
                switch fuelFlowRateUnit {
                    case "l/h":
                        ffrLPH = fuelFlowRateVal
                    case "kg/h":
                        ffrLPH = fuelFlowRateVal / 0.79
                    case "lbs/h":
                        ffrLPH = fuelFlowRateVal / 1.76
                    default:
                        ffrLPH = fuelFlowRateVal
                }
        }
        
        if ufL == 0 || ffrLPH == 0 {
            timeS = 0
            
            switch timeUnit {
                case "HH : MM : SS":
                    result.text = "00 : 00 : 00"
                case "MM : SS":
                    result.text = "000 : 00"
                case "SS":
                    result.text = "000"
                default:
                    result.text = "00 : 00 : 00"
            }
        }else{
            timeS = Int((ufL * 3600)/ffrLPH)
            
            switch timeUnit {
                case "HH : MM : SS":
                    let (h,m,s) = secondsToHMS(seconds: timeS)
                    hours = ((h<10) ? "0" : "") + String(h)
                    minutes = ((m<10) ? "0" : "") + String(m)
                    seconds = ((s<10) ? "0" : "") + String(s)
                
                    result.text = "\(hours) : \(minutes) : \(seconds)"
                case "MM : SS":
                    var (h,m,s) = secondsToHMS(seconds: timeS)
                    if h > 0 {
                        m = h * 60 + m
                    }
                    minutes = ((m<10) ? "0" : "") + String(m)
                    seconds = ((s<10) ? "0" : "") + String(s)
                
                    result.text = "\(minutes) : \(seconds)"
            case "SS":
                    seconds = ((timeS<10) ? "0" : "") + String(timeS)
                
                    result.text = "\(seconds)"
            default:
                    let (h,m,s) = secondsToHMS(seconds: timeS)
                    hours = ((h<10) ? "0" : "") + String(h)
                    minutes = ((m<10) ? "0" : "") + String(m)
                    seconds = ((s<10) ? "0" : "") + String(s)
                
                    result.text = "\(hours) : \(minutes) : \(seconds)"
            }
        }
    }
    
    func updateView (){
        
        if selectedUnits[13] == "" {
            useableFuelUlbl.text = defUnits[13]
        }else{
            useableFuelUlbl.text = selectedUnits[13]
        }
        
        if selectedUnits[6] == "" {
            fuelFlowRateUlbl.text = defUnits[6]
        }else{
            fuelFlowRateUlbl.text = selectedUnits[6]
        }
        
        if selectedUnits[2] == "" {
            resultUlbl.text = defUnits[2]
        }else{
            resultUlbl.text = selectedUnits[2]
        }
        
        let UFvalue = selValues.useableFuel
        
        if UFvalue == nil || UFvalue == "" {
            ufSlider.value = 0.0
            inputUseableFuel.text = "0.0"
        }else{
            ufSlider.value = Float(UFvalue!)!
            inputUseableFuel.text = UFvalue
        }
        
        let FFRvalue = selValues.fuelflow
        if FFRvalue == nil || FFRvalue == "" {
            if setValues[7] != 0 {
                ffrSlider.value = Float(setValues[7])
                inputFuelFlowRate.text = "\(setValues[7])"
            }else{
                ffrSlider.value = Float(defValues[7])
                inputFuelFlowRate.text = "\(defValues[7])"
            }
        }else{
            ffrSlider.value = Float(FFRvalue!)!
            inputFuelFlowRate.text = FFRvalue
        }
        
        if fuelType != "" {
            fuelTypelbl.text = prefs.string(forKey: Keys.fuelTypeV)
        }else{
            fuelTypelbl.text = defFuelType
        }
    }
    
    //MARK: TEXTFIELDS interaction section
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem = hideBarButton
        
        if textField == inputUseableFuel {
            scrollV.setContentOffset(CGPoint(x: 0,y: 20), animated: true)
        }else if textField == inputFuelFlowRate {
            scrollV.setContentOffset(CGPoint(x: 0,y: 60), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.navigationItem.rightBarButtonItem = nil
        
        scrollV.setContentOffset(CGPoint(x: 0,y: -65 ), animated: true)
        
        if textField == inputUseableFuel {
            useableFuelVal = (ufSlider.value).roundTo(places: 2)
            selValues.useableFuel = String(useableFuelVal)
            if inputUseableFuel.text != "" {
                ufSlider.value = Float(inputUseableFuel.text!)!
            }else{
                ufSlider.value = 0.0
            }
        }else if textField == inputFuelFlowRate {
            fuelFlowRateVal = (ffrSlider.value).roundTo(places: 2)
            selValues.fuelflow = String(fuelFlowRateVal)
            if inputFuelFlowRate.text != "" {
                ffrSlider.value = Float(inputFuelFlowRate.text!)!
            }else{
                ffrSlider.value = 0.0
            }
        }
    }
    
    //MARK: Additional functions
    func secondsToHMS (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc func hideKeyboard() {
        inputUseableFuel.resignFirstResponder()
        inputFuelFlowRate.resignFirstResponder()
        
        calculate()
    }
}
