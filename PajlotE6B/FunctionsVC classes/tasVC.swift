
import UIKit

class tasVC: UIViewController,
                UITextFieldDelegate,
                UIScrollViewDelegate {
    
    //MARK: Properties
    var speedVal: Float = 0.0
    var speedMaxVal: Float!
    var temp: Float!
    var p0: Float!
    var altitudeVal: Float = 0.0
    var altitudeMaxVal: Float!
    var resultTAS: Float = 0.0
        
    // MARK: - IBOutlets
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: IBOutlets: textfields
    @IBOutlet weak var inputSpeed: UITextField!
    @IBOutlet weak var inputAltitude: UITextField!
    
    // MARK: IBOutlets: sliders
    @IBOutlet weak var sSlider: UISlider!
    @IBOutlet weak var aSlider: UISlider!
    
    // MARK: IBOutlets: labels
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var resultUlbl: UILabel!
    @IBOutlet weak var speedUlbl: UILabel!
    @IBOutlet weak var altitudeUlbl: UILabel!
    
    @IBOutlet weak var templbl: UILabel!
    @IBOutlet weak var tempUlbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var pressurelbl: UILabel!
    @IBOutlet weak var pressureUlbl: UILabel!
    @IBOutlet weak var pressLbl: UILabel!
    
    // MARK: IBOutlets: views
    @IBOutlet weak var tContainer: UIView!
    @IBOutlet weak var bContainer: UIView!
    
    
    var hideBarButton : UIBarButtonItem!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("TASLabel", comment: "TAS Title").localiz()
        pressLbl.text = NSLocalizedString("PressureLabel", comment: "Pressure Label")
        temperatureLbl.text = NSLocalizedString("TempLabel", comment: "Temperature Label")
            
        updateMaxVal()
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
        inputSpeed.attributedPlaceholder = NSAttributedString(string:"podaj prędkość", attributes:[NSAttributedStringKey.foregroundColor: phColor])
        
        inputAltitude.attributedPlaceholder = NSAttributedString(string:"podaj wysokość lotu", attributes:[NSAttributedStringKey.foregroundColor: phColor])
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateMaxVal()
        updateView()
        calculate()
    }
    
    override func viewDidLayoutSubviews() {
        updateMaxVal()
        
        tContainer.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        bContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        speedVal = (sSlider.value).roundTo(places: 2)
        selValues.speed = String(speedVal)
        
        altitudeVal = (aSlider.value).roundTo(places: 2)
        selValues.height = String(altitudeVal)
        
        if inputSpeed.text != "" {
            sSlider.value = Float(inputSpeed.text!)!
        }else{
            sSlider.value = 0.0
        }
        
        if inputAltitude.text != "" {
            aSlider.value = Float(inputAltitude.text!)!
        }else{
            aSlider.value = 0.0
        }
        hideKeyboard()
        
    }
    
    //MARK: IBActions
    @IBAction func upgradePro(_ sender: Any) {
        usefulFunctions().jumpToUpgradeVC()
    }
    
    //MARK: IBActions > altitude section
    @IBAction func altitudeTFTapped(_ sender: UITextField) {
        if inputAltitude.text?.count != 0 {
            if inputAltitude.text?.first == "." || inputAltitude.text?.first == "," {
                inputAltitude.text = ""
                return
            }
            if var val = inputAltitude.text {
                selValues.height = val
                val = val.replacingOccurrences(of: ",", with: ".")
                altitudeVal = Float(val)!
                inputAltitude.text = val
            }
        }else{
            altitudeVal = 0.0
        }
        hideKeyboard()
    }
    
    @IBAction func altitudeSlider(_ sender: UISlider) {
        altitudeVal = (sender.value).roundTo(places: 1)
        selValues.height = String(altitudeVal)
        inputAltitude.text = String(altitudeVal)
        hideKeyboard()
    }
    
    @IBAction func decreaseAltitude(_ sender: Any) {
        if altitudeVal <= altitudeMaxVal && altitudeVal >= 1 {
            altitudeVal = altitudeVal.roundTo(places: 1)
            altitudeVal -= 1.0
            selValues.height = String(altitudeVal)
            inputAltitude.text = String(altitudeVal)
            aSlider.value = altitudeVal
        }
    }
    
    @IBAction func increaseAltitude(_ sender: Any) {
        if altitudeVal >= 0 && altitudeVal <= (altitudeMaxVal - 1.0) {
            altitudeVal = altitudeVal.roundTo(places: 1)
            altitudeVal += 1.0
            selValues.height = String(altitudeVal)
            inputAltitude.text = String(altitudeVal)
            aSlider.value = altitudeVal
        }
    }
    
    //MARK: - IBActions > speed section
    @IBAction func speedTFTapped(_ sender: UITextField) {
        
        if inputSpeed.text?.count != 0 {
            if inputSpeed.text?.first == "." || inputSpeed.text?.first == "," {
                inputSpeed.text = ""
                return
            }
            if var val = inputSpeed.text {
                selValues.speed = val
                val = val.replacingOccurrences(of: ",", with: ".")
                speedVal = Float(val)!
                inputSpeed.text = val
            }
        }else{
            speedVal = 0.0
        }
        hideKeyboard()
    }
    
    @IBAction func speedSlider(_ sender: UISlider) {
        speedVal = (sender.value).roundTo(places: 1)
        selValues.speed = String(speedVal)
        inputSpeed.text = String(speedVal)
        hideKeyboard()
    }
    
    @IBAction func decreaseSpeed(_ sender: Any) {
        if speedVal <= speedMaxVal && speedVal >= 1 {
            speedVal = speedVal.roundTo(places: 1)
            speedVal -= 1.0
            selValues.speed = String(speedVal)
            inputSpeed.text = String(speedVal)
            sSlider.value = speedVal
        }
    }
    
    @IBAction func increaseSpeed(_ sender: Any) {
        if speedVal >= 0 && speedVal <= (speedMaxVal - 1.0) {
            speedVal = speedVal.roundTo(places: 1)
            speedVal += 1.0
            selValues.speed = String(speedVal)
            inputSpeed.text = String(speedVal)
            sSlider.value = speedVal
        }
    }
    
    // MARK: - Functions
    func calculate(){
        let speedUnit = selectedUnits[0]
        let altitudeUnit = selectedUnits[4]
        let pressureUnit = selectedUnits[11]
        let tempUnit = selectedUnits[10]
        
        var speedMPS : Float
        var altM : Float
        var pressureHPA : Float
        var tempC : Float

        switch pressureUnit {
            case "hPa":
                pressureHPA = p0
            case "mmHg":
                pressureHPA = p0 * 1.33322368
            case "inHg":
                pressureHPA = p0 * 33.8638816
            default:
                pressureHPA = p0
        }
        
        switch tempUnit {
            case "°C":
                tempC = temp
            case "°F":
                tempC = temp * 1.8 + 32
            case "K":
                tempC = temp - 273.15
            default:
                tempC = temp
            }
    
        var resultMPS : Float
        
        speedVal = sSlider.value
        altitudeVal = aSlider.value
        
        switch speedUnit {
            case "KPH":
                speedMPS = speedVal * 0.277777778
            case "KT":
                speedMPS = speedVal * 0.514444444
            case "MPH":
                speedMPS = speedVal * 0.44704
            default:
                speedMPS = speedVal * 0.277777778
            }
        
        switch altitudeUnit {
            case "m":
                altM = altitudeVal
            case "ft":
                altM = (altitudeVal * 1852).roundTo(places: 2)
            case "FL":
                altM = (altitudeVal * 1609.344).roundTo(places: 2)
            default:
                altM = (altitudeVal * 1000).roundTo(places: 2)
            }
        
        if speedMPS == 0 && altM == 0 {
            resultMPS = 0
            result.text = "000.0"
        }else if speedMPS == 0 && altM != 0{
            resultMPS = 0
            result.text = "000.0"
        }else if speedMPS != 0 && altM == 0{
            resultMPS = speedMPS
            
            switch speedUnit {
                case "KPH":
                    resultTAS = (resultMPS * 3.6).roundTo(places: 1)
                case "KT":
                    resultTAS = (resultMPS * 1.94384449).roundTo(places: 1)
                case "MPH":
                    resultTAS = (resultMPS * 2.23693629).roundTo(places: 1)
                default:
                    resultTAS = (resultMPS * 3.6).roundTo(places: 1)
            }
            
            result.text = "\(resultTAS)"
        }else{
            let p = pressureHPA * pow((1 - 0.0065 * altM / (tempC + 273.15 + 0.0065 * altM)), 5.257)

            let delta = 288.15 / (tempC + 273.15) * p / pressureHPA
            resultMPS = speedMPS / Float(delta.squareRoot())
            
            switch speedUnit {
                case "KPH":
                    resultTAS = (resultMPS * 3.6).roundTo(places: 1)
                case "KT":
                    resultTAS = (resultMPS * 1.94384449).roundTo(places: 1)
                case "MPH":
                    resultTAS = (resultMPS * 2.23693629).roundTo(places: 1)
                default:
                    resultTAS = (resultMPS * 3.6).roundTo(places: 1)
            }
            
            result.text = "~ \(resultTAS)"
        }
    }
    
    func updateMaxVal (){
        if setValues[0] == 0 {
            speedMaxVal = Float(defValues[0])
            sSlider.maximumValue = Float(defValues[0])
        }else{
            speedMaxVal = Float(setValues[0])
            sSlider.maximumValue = Float(setValues[0])
        }
        
        if selectedUnits[4] == "" {
            altitudeMaxVal = 10000.0
            aSlider.maximumValue = altitudeMaxVal
        }else{
            switch selectedUnits[4] {
                case "m":
                    altitudeMaxVal = 10000.0
                    aSlider.maximumValue = altitudeMaxVal
                case "ft":
                    altitudeMaxVal = 45000.0
                    aSlider.maximumValue = altitudeMaxVal
                case "FL":
                    altitudeMaxVal = 430.0
                    aSlider.maximumValue = altitudeMaxVal
                default:
                    altitudeMaxVal = 10000.0
                    aSlider.maximumValue = altitudeMaxVal
                }
            }
    }
    
    func updateView (){
        
        if selectedUnits[0] == "" {
            speedUlbl.text = defUnits[0]
        }else{
            speedUlbl.text = selectedUnits[0]
        }
        
        if selectedUnits[4] == "" {
            altitudeUlbl.text = defUnits[4]
        }else{
            altitudeUlbl.text = selectedUnits[4]
        }
        
        if selectedUnits[0] == "" {
            resultUlbl.text = defUnits[0]
        }else{
            resultUlbl.text = selectedUnits[0]
        }
        
        let Svalue = selValues.speed
        if Svalue == nil || Svalue == "" {
            sSlider.value = 0.0
            inputSpeed.text = "0.0"
        }else{
            sSlider.value = Float(Svalue!)!
            inputSpeed.text = Svalue
        }
        
        let Avalue = selValues.height
        if Avalue == nil || Avalue == "" {
            aSlider.value = 0.0
            inputAltitude.text = "0.0"
        }else{
            aSlider.value = Float(Avalue!)!
            inputAltitude.text = Avalue
        }
        
        
        if setValues[2] != 0 {
            p0 = Float(setValues[2])
        }else{
            p0 = Float(defValues[2])
        }
        pressurelbl.text = String(p0)

        if selectedUnits[11] == "" {
            pressureUlbl.text = defUnits[11]
        }else{
            pressureUlbl.text = selectedUnits[11]
        }
        
        if setValues[3] != 0 {
            temp = Float(setValues[3])
        }else{
            temp = Float(defValues[3])
        }
        templbl.text = String(temp)

        if selectedUnits[10] == "" {
            tempUlbl.text = defUnits[10]
        }else{
            tempUlbl.text = selectedUnits[10]
        }
    }
    
    //MARK: TEXTFIELDS interaction section
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem = hideBarButton
        
        if textField == inputSpeed {
            scrollV.setContentOffset(CGPoint(x: 0,y: 20), animated: true)
        }else if textField == inputAltitude {
            scrollV.setContentOffset(CGPoint(x: 0,y: 60), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.navigationItem.rightBarButtonItem = nil
        
        scrollV.setContentOffset(CGPoint(x: 0,y: -65 ), animated: true)
        
        if textField == inputSpeed {
            speedVal = (sSlider.value).roundTo(places: 2)
            selValues.speed = String(speedVal)
            if inputSpeed.text != "" {
                sSlider.value = Float(inputSpeed.text!)!
            }else{
                sSlider.value = 0.0
            }
        }else if textField == inputAltitude {
            altitudeVal = (aSlider.value).roundTo(places: 2)
            selValues.height = String(altitudeVal)
            if inputAltitude.text != "" {
                aSlider.value = Float(inputAltitude.text!)!
            }else{
                aSlider.value = 0.0
            }
        }
    }
    
    //MARK: Additional functions   
    @objc func hideKeyboard() {
        inputSpeed.resignFirstResponder()
        inputAltitude.resignFirstResponder()
        
        calculate()
    }
}
