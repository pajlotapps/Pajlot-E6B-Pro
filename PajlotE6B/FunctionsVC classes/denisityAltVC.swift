
import UIKit

class densityAltVC: UIViewController,
                UITextFieldDelegate,
                UIScrollViewDelegate {

    //MARK: Properties
    var altitudeVal: Float = 0.0
    var altitudeMaxVal: Float!
    var barometerVal: Float = 0.0
    var barometerMinVal: Float!
    var barometerMaxVal: Float!
    var temperatureVal: Float = 0.0
    var temperatureMinVal: Float!
    var temperatureMaxVal: Float!

    var resultALT: Float = 0.0
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: IBOutlets: textfields
    @IBOutlet weak var inputAltitude: UITextField!
    @IBOutlet weak var inputBarometer: UITextField!
    @IBOutlet weak var inputTemperature: UITextField!
    
    // MARK: IBOutlets: sliders
    @IBOutlet weak var aSlider: UISlider!
    @IBOutlet weak var bSlider: UISlider!
    @IBOutlet weak var tSlider: UISlider!
    
    // MARK: IBOutlets: labels
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var resultUlbl: UILabel!
    @IBOutlet weak var altitudeUlbl: UILabel!
    @IBOutlet weak var barometerUlbl: UILabel!
    @IBOutlet weak var temperatureUlbl: UILabel!

    // MARK: IBOutlets: views
    @IBOutlet weak var tContainer: UIView!
    @IBOutlet weak var bContainer: UIView!
    
    @IBOutlet weak var moreBtn: CustomButton!
    var hideBarButton : UIBarButtonItem!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        title = NSLocalizedString("DensityAltLabel", comment: "Density Altitude Title").localiz()
        moreBtn.setTitle((NSLocalizedString("MoreInfoBtn", comment: "More Label")), for: UIControlState.normal)

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
        altitudeVal = (aSlider.value).roundTo(places: 2)
        selValues.height = String(altitudeVal)
        
        barometerVal = (bSlider.value).roundTo(places: 2)
        selValues.pressure = String(barometerVal)
        
        temperatureVal = (tSlider.value).roundTo(places: 2)
        selValues.temp = String(temperatureVal)
        
        if inputAltitude.text != "" {
            aSlider.value = Float(inputAltitude.text!)!
        }else{
            aSlider.value = 0.0
        }
        
        if inputBarometer.text != "" {
            bSlider.value = Float(inputBarometer.text!)!
        }else{
            bSlider.value = 0.0
        }
        
        if inputTemperature.text != "" {
            tSlider.value = Float(inputTemperature.text!)!
        }else{
            tSlider.value = 0.0
        }
        hideKeyboard()
        
    }
    
    //MARK: IBActions
    @IBAction func upgradePro(_ sender: Any) {
        usefulFunctions().jumpToUpgradeVC()
    }
    
    //MARK: - IBActions > altitude section
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
    
    //MARK: - IBActions > barometer section
    @IBAction func barometerTFTapped(_ sender: UITextField) {
        if inputBarometer.text?.count != 0 {
            if inputBarometer.text?.first == "." || inputBarometer.text?.first == "," {
                inputBarometer.text = ""
                return
            }
            if var val = inputBarometer.text {
                selValues.pressure = val
                val = val.replacingOccurrences(of: ",", with: ".")
                barometerVal = Float(val)!
                inputBarometer.text = val
            }
        }else{
            barometerVal = 0.0
        }
        hideKeyboard()
    }
    
    @IBAction func barometerSlider(_ sender: UISlider) {
        barometerVal = (sender.value).roundTo(places: 1)
        selValues.pressure = String(barometerVal)
        inputBarometer.text = String(barometerVal)
        hideKeyboard()
    }
    
    @IBAction func decreaseBarometer(_ sender: Any) {
        if barometerVal <= barometerMaxVal && barometerVal >= 1 {
            barometerVal = barometerVal.roundTo(places: 1)
            barometerVal -= 1.0
            selValues.pressure = String(barometerVal)
            inputBarometer.text = String(barometerVal)
            bSlider.value = barometerVal
        }
    }
    
    @IBAction func increaseBarometer(_ sender: Any) {
        if barometerVal >= 0 && barometerVal <= (barometerMaxVal - 1.0) {
            barometerVal = barometerVal.roundTo(places: 1)
            barometerVal += 1.0
            selValues.pressure = String(barometerVal)
            inputBarometer.text = String(barometerVal)
            bSlider.value = barometerVal
        }
    }
    
    //MARK: - IBActions > temperature section
    @IBAction func temperatureTFTapped(_ sender: UITextField) {
        if inputTemperature.text?.count != 0 {
            if inputTemperature.text?.first == "." || inputTemperature.text?.first == "," {
                inputTemperature.text = ""
                return
            }
            if var val = inputTemperature.text {
                selValues.temp = val
                val = val.replacingOccurrences(of: ",", with: ".")
                temperatureVal = Float(val)!
                inputTemperature.text = val
            }
        }else{
            temperatureVal = 0.0
        }
        hideKeyboard()
    }
    
    @IBAction func temperatureSlider(_ sender: UISlider) {
        temperatureVal = (sender.value).roundTo(places: 1)
        selValues.temp = String(temperatureVal)
        inputTemperature.text = String(temperatureVal)
        hideKeyboard()
    }
    
    @IBAction func decreaseTemperature(_ sender: Any) {
        if temperatureVal <= temperatureMaxVal && temperatureVal >= 1 {
            temperatureVal = temperatureVal.roundTo(places: 1)
            temperatureVal -= 1.0
            selValues.temp = String(temperatureVal)
            inputTemperature.text = String(temperatureVal)
            tSlider.value = temperatureVal
        }
    }
    
    @IBAction func increaseTemperature(_ sender: Any) {
        if temperatureVal >= 0 && temperatureVal <= (temperatureMaxVal - 1.0) {
            temperatureVal = temperatureVal.roundTo(places: 1)
            temperatureVal += 1.0
            selValues.temp = String(temperatureVal)
            inputTemperature.text = String(temperatureVal)
            tSlider.value = temperatureVal
        }
    }
    
    
    // MARK: - Functions
    func calculate(){
        let altitudeUnit = selectedUnits[4]
        let pressureUnit = selectedUnits[11]
        let tempUnit = selectedUnits[10]
        
        var altM : Float
        var pressureHPA : Float
        var tempK : Float
        var resultM : Float
        var temp : Float

        altitudeVal = aSlider.value
        switch altitudeUnit {
            case "m":
                altM = altitudeVal
            case "ft":
                altM = altitudeVal * 1852
            case "FL":
                altM = altitudeVal * 1609.344
            default:
                altM = altitudeVal * 1000
            }
        
        barometerVal = bSlider.value
        switch pressureUnit {
            case "hPa":
                pressureHPA = barometerVal
            case "mmHg":
                pressureHPA = barometerVal * 1.33322368
            case "inHg":
                pressureHPA = barometerVal * 33.8638816
            default:
                pressureHPA = barometerVal
        }
        
        temperatureVal = tSlider.value
        switch tempUnit {
            case "°C":
                tempK = temperatureVal + 273.15
            case "°F":
                tempK = (temperatureVal + 459.67) * 5 / 9
            case "K":
                tempK = temperatureVal
            default:
                tempK = temperatureVal
        }
        
        if altM != 0 {
            result.text = "\(altitudeVal)"
            if barometerVal >= barometerMinVal && barometerVal <= barometerMaxVal{
                if temperatureVal >= temperatureMinVal && temperatureVal <= temperatureMaxVal {

                    temp = pow((pressureHPA / 1013.25)/(tempK / 288.15),0.235)
                    print("temp: \(temp)")
                    resultM = 288.15/0.0065 * (1 - temp)
                    print("metrów: \(resultM)")
                    
                    let DA : Float
                    DA = altitudeVal  + (120 * ((tempK-273.15)-(15-(altitudeVal)/1000*2)))
                    
                    print("DA: \(DA)")

                    
                    
                    
                    switch altitudeUnit {
                        case "m":
                            resultALT = resultM.roundTo(places: 1)
                        case "ft":
                            resultALT = (resultM * 3.281).roundTo(places: 1)
                        case "FL":
                            resultALT = (resultM * 3.281 / 100).roundTo(places: 0)
                        default:
                            resultALT = resultM.roundTo(places: 1)
                    }
                    result.text = "\(resultALT)"
                }
            }
        }
    }
    
    func updateMaxVal (){
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
        
        if selectedUnits[11] == "" {
            barometerMinVal = 337
            barometerMaxVal = 1067
            bSlider.minimumValue = barometerMinVal
            bSlider.maximumValue = barometerMaxVal
        }else{
            switch selectedUnits[11] {
                case "hPa":
                    barometerMinVal = 337
                    barometerMaxVal = 1067
                    bSlider.minimumValue = barometerMinVal
                    bSlider.maximumValue = barometerMaxVal
                case "mmHg":
                    barometerMinVal = 252
                    barometerMaxVal = 801
                    bSlider.minimumValue = barometerMinVal
                    bSlider.maximumValue = barometerMaxVal
                case "inHg":
                    barometerMinVal = 9
                    barometerMaxVal = 32
                    bSlider.minimumValue = barometerMinVal
                    bSlider.maximumValue = barometerMaxVal
                default:
                    barometerMinVal = 337
                    barometerMaxVal = 1067
                    bSlider.minimumValue = barometerMinVal
                    bSlider.maximumValue = barometerMaxVal
            }
        }
        
        if selectedUnits[10] == "" {
            temperatureMinVal = -50
            temperatureMaxVal = 50
            tSlider.minimumValue = temperatureMinVal
            tSlider.maximumValue = temperatureMaxVal
        }else{
            switch selectedUnits[10] {
                case "°C":
                    temperatureMinVal = -50
                    temperatureMaxVal = 50
                    tSlider.minimumValue = temperatureMinVal
                    tSlider.maximumValue = temperatureMaxVal
                case "°F":
                    temperatureMinVal = -58
                    temperatureMaxVal = 122
                    tSlider.minimumValue = temperatureMinVal
                    tSlider.maximumValue = temperatureMaxVal
                case "K":
                    temperatureMinVal = 223.15
                    temperatureMaxVal = 323.15
                    tSlider.minimumValue = temperatureMinVal
                    tSlider.maximumValue = temperatureMaxVal
                default:
                    temperatureMinVal = -50
                    temperatureMaxVal = 50
                    tSlider.minimumValue = temperatureMinVal
                    tSlider.maximumValue = temperatureMaxVal
            }
        }
        
    }
    
    func updateView (){
        
        if selectedUnits[4] == "" {
            altitudeUlbl.text = defUnits[4]
            resultUlbl.text = defUnits[4]
        }else{
            altitudeUlbl.text = selectedUnits[4]
            resultUlbl.text = selectedUnits[4]
        }
        
        let Avalue = selValues.height
        if Avalue == nil || Avalue == "" {
            aSlider.value = 0.0
            inputAltitude.text = "0.0"
        }else{
            aSlider.value = Float(Avalue!)!
            inputAltitude.text = Avalue
        }
        
        if selectedUnits[11] == "" {
            barometerUlbl.text = defUnits[11]
        }else{
            barometerUlbl.text = selectedUnits[11]
        }
        
        let Bvalue = selValues.pressure
        if Bvalue == nil || Bvalue == "" {
            bSlider.value = 0.0
            inputBarometer.text = "0.0"
        }else{
            bSlider.value = Float(Bvalue!)!
            inputBarometer.text = Bvalue
        }
        
        if selectedUnits[10] == "" {
            temperatureUlbl.text = defUnits[10]
        }else{
            temperatureUlbl.text = selectedUnits[10]
        }
        
        let Tvalue = selValues.temp
        if Tvalue == nil || Tvalue == "" {
            tSlider.value = 0.0
            inputTemperature.text = "0.0"
        }else{
            tSlider.value = Float(Tvalue!)!
            inputTemperature.text = Tvalue
        }
    }
    
    //MARK: TEXTFIELDS interaction section
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem = hideBarButton
        
        if textField == inputAltitude {
            scrollV.setContentOffset(CGPoint(x: 0,y: 20), animated: true)
        }else if textField == inputBarometer {
            scrollV.setContentOffset(CGPoint(x: 0,y: 60), animated: true)
        }else if textField == inputTemperature {
            scrollV.setContentOffset(CGPoint(x: 0,y: 100), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.navigationItem.rightBarButtonItem = nil
        
        scrollV.setContentOffset(CGPoint(x: 0,y: -65 ), animated: true)
        
        if textField == inputAltitude {
            altitudeVal = (aSlider.value).roundTo(places: 2)
            selValues.height = String(altitudeVal)
            if inputAltitude.text != "" {
                aSlider.value = Float(inputAltitude.text!)!
            }else{
                aSlider.value = 0.0
            }
        }else if textField == inputBarometer {
            barometerVal = (bSlider.value).roundTo(places: 2)
            selValues.pressure = String(barometerVal)
            if inputBarometer.text != "" {
                bSlider.value = Float(inputBarometer.text!)!
            }else{
                bSlider.value = 0.0
            }
        }else if textField == inputTemperature {
            temperatureVal = (tSlider.value).roundTo(places: 2)
            selValues.temp = String(temperatureVal)
            if inputTemperature.text != "" {
                tSlider.value = Float(inputTemperature.text!)!
            }else{
                tSlider.value = 0.0
            }
        }
    }
    
    //MARK: Additional functions
    @objc func hideKeyboard() {
        inputAltitude.resignFirstResponder()
        inputBarometer.resignFirstResponder()
        inputTemperature.resignFirstResponder()
        
        calculate()
    }
}
