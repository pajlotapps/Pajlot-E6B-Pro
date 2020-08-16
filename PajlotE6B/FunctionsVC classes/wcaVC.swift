
import UIKit

class wcaVC: UIViewController,
    UIPickerViewDelegate,
    UIPickerViewDataSource,
    UIScrollViewDelegate,
UITextFieldDelegate {
    
    //MARK: Properties
    let maxRows = 100
    private let maxElements = 36000
    let degrees = [Int](0...359)
    let degreesCrs = [Int](0...359)
    
    var speedVal: Float = 0.0
    var speedMaxVal: Float!
    var windSpeedVal: Float = 0.0
    
    // MARK: - IBOutlets - ScrollView
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: IBOutlets - Views
    @IBOutlet weak var bContainer: UIView!
    @IBOutlet weak var tContainer: UIView!
    
    // MARK: IBOutlets - TextFilds
    @IBOutlet weak var inputWind: UITextField!
    @IBOutlet weak var inputCrs: UITextField!
    @IBOutlet weak var inputSpeed: UITextField!
    @IBOutlet weak var inputWindSpeed: UITextField!
    
    // MARK: IBOutlets - Labels
    @IBOutlet weak var speedUlbl: UILabel!
    @IBOutlet weak var windSpeedUlbl: UILabel!
    @IBOutlet weak var wcaLbl: UILabel!
    @IBOutlet weak var GS_lbl: UILabel!
    @IBOutlet weak var HDG_lbl: UILabel!
    @IBOutlet weak var GSU_lbl: UILabel!
    @IBOutlet weak var HDGU_lbl: UILabel!
    @IBOutlet weak var WCAU_lbl: UILabel!

    @IBOutlet weak var windDirectionLbl: UILabel!
    @IBOutlet weak var courseLbl: UILabel!
    
    // MARK: IBOutlets - Sliders
    @IBOutlet weak var sSlider: UISlider!
    @IBOutlet weak var wsSlider: UISlider!
    
    var degPicker : UIPickerView!
    var activeTextField = 0
    var activeTF : UITextField!
    var activeValue = ""
    
    var hideBarButton : UIBarButtonItem!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("WCALabel", comment: "WCA Title").localiz()
        windDirectionLbl.text = NSLocalizedString("WindDirectionLabel", comment: "Wind Direction Label")
        courseLbl.text = NSLocalizedString("CourseLabel", comment: "Course Label")


        inputWind.delegate = self
        inputCrs.delegate = self
        
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

    override func viewDidLayoutSubviews() {
        tContainer.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        bContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
    
    // MARK: - IBActions > text fields section
    @IBAction func windTFTapped(_ sender: UITextField) {
        selValues.windDirection = inputWind.text
        hideKeyboard()
    }
    
    @IBAction func crsTFTapped(_ sender: UITextField) {
        selValues.crsDirection = inputCrs.text
        hideKeyboard()
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
    
    @IBAction func decreesSpeed(_ sender: Any) {
        if speedVal <= speedMaxVal && speedVal >= 1 {
            speedVal -= 1.0
            selValues.speed = String(speedVal)
            inputSpeed.text = String(speedVal)
            selValues.speed = String(speedVal)
            sSlider.value = speedVal
        }
    }
    
    @IBAction func increesSpeed(_ sender: Any) {
        if speedVal >= 0 && speedVal <= (speedMaxVal - 1.0) {
            speedVal += 1.0
            selValues.speed = String(speedVal)
            inputSpeed.text = String(speedVal)
            sSlider.value = speedVal
        }
    }
    
    //MARK: - IBActions > wind speed section
    @IBAction func windSpeedTFTapped(_ sender: UITextField) {
        if inputWindSpeed.text?.count != 0 {
            if inputWindSpeed.text?.first == "." || inputWindSpeed.text?.first == "," {
                inputWindSpeed.text = ""
                return
            }
            if var val = inputWindSpeed.text {
                selValues.windSpeed = val
                val = val.replacingOccurrences(of: ",", with: ".")
                windSpeedVal = Float(val)!
                inputWindSpeed.text = val
            }
        }else{
            windSpeedVal = 0.0
        }
        hideKeyboard()
    }
    
    @IBAction func windSpeedSlider(_ sender: UISlider) {
        windSpeedVal = (sender.value).roundTo(places: 0)
        selValues.windSpeed = String(windSpeedVal)
        inputWindSpeed.text = selValues.windSpeed
        hideKeyboard()
    }
    
    @IBAction func decreesWind(_ sender: Any) {
        if windSpeedVal <= 100 && windSpeedVal >= 1 {
            windSpeedVal -= 1.0
            selValues.windSpeed = String(windSpeedVal)
            inputWindSpeed.text = String(windSpeedVal)
            wsSlider.value = windSpeedVal
            hideKeyboard()
        }
    }
    
    @IBAction func increesWind(_ sender: Any) {
        if windSpeedVal >= 0 && windSpeedVal <= 99 {
            windSpeedVal += 1.0
            selValues.windSpeed = String(windSpeedVal)
            inputWindSpeed.text = String(windSpeedVal)
            wsSlider.value = windSpeedVal
            hideKeyboard()
        }
    }
    
    // MARK: - Functions
    func calculate(){
        
        let angleUnit = selectedUnits[12]
        let speedUnit = selectedUnits[0]
        let windSpeedUnit = selectedUnits[5]
        
        let WD : Int
        var CRS : Int
        var TAS : Float
        var WS : Float
        var AWA : Int
        
        var WCAangle : Float
        var WCA : Float
        var HDG : Int
        var GS : Float
        
        let TASmps : Float
        let WSmps : Float
        let GSmps : Float
        
        TAS = sSlider.value
        WS = wsSlider.value
        
        let wDValue = selValues.windDirection
        let cDValue = selValues.crsDirection
        
        if wDValue == "" || wDValue == nil {
            WD = 0
        }else{
            let degLess = wDValue?.replacingOccurrences(of: "°", with: "", options: .literal, range: nil)
            WD = Int(degLess!)!
        }
        
        if cDValue == "" || cDValue == nil {
            CRS = 0
        }else{
            let degLess = cDValue?.replacingOccurrences(of: "°", with: "", options: .literal, range: nil)
            CRS = Int(degLess!)!
        }
        
        if TAS != 0.0 {
            switch speedUnit {
            case "KPH":
                TASmps = TAS * 0.277777778
            case "KT":
                TASmps = TAS * 0.514444444
            case "MPH":
                TASmps = TAS * 0.447040000
            default:
                TASmps = TAS * 0.277777778
            }
        }else{
            TASmps = 0.0
        }
        
        if WS != 0.0 {
            switch windSpeedUnit {
            case "m/s":
                WSmps = WS
            case "KT":
                WSmps = WS * 0.514444444
            case "KPH":
                WSmps = WS * 0.277777778
            default:
                WSmps = WS
            }
        }else{
            WSmps = 0.0
        }
        
        AWA = (CRS - WD + 180) % 360
        WCAangle = (asin(WSmps * sin(Float(AWA).degreesToRadians)/TASmps).radiansToDegrees).roundTo(places: 0)
        
        if Float(CRS) + WCAangle > 359.5 {
            HDG = Int(Float(CRS) - 360.0 + WCAangle)
        }else{
            if WCAangle.isNaN || WCAangle.isInfinite {
                WCAangle = 0
                HDG = CRS
            }else{
                if Float(CRS) + WCAangle < 0 {
                    HDG = Int(Float(CRS) + 360.0 + WCAangle)
                }else{
                    HDG = CRS + Int(WCAangle)
                }
            }
        }
        
        GSmps = ((TASmps * cos(Float(CRS-HDG).degreesToRadians)) + (WSmps * cos(Float(AWA).degreesToRadians))).roundTo(places: 1)
        switch speedUnit {
        case "KPH":
            GS = (GSmps * 3.6).roundTo(places: 1)
        case "KT":
            GS = (GSmps * 1.94384449).roundTo(places: 1)
        case "MPH":
            GS = (GSmps * 2.23693629).roundTo(places: 1)
        default:
            GS = (GSmps * 3.6).roundTo(places: 1)
        }
        
        
        switch angleUnit {
        case "°":
            WCA = WCAangle
        case "rad":
            WCA = (WCAangle.degreesToRadians).roundTo(places: 3)
        default:
            WCA = WCAangle
        }
        
        GS_lbl.text = String(GS)
        HDG_lbl.text = String(HDG)
        wcaLbl.text = String(WCA)
    }
    
    func updateMaxVal (){
        if setValues[0] == 0 {
            speedMaxVal = Float(defValues[0])
            sSlider.maximumValue = Float(defValues[0])
        }else{
            speedMaxVal = Float(setValues[0])
            sSlider.maximumValue = Float(setValues[0])
        }
    }
    
    func updateView (){
        if selectedUnits[0] == "" {
            speedUlbl.text = defUnits[0]
            GSU_lbl.text = defUnits[0]
        }else{
            speedUlbl.text = selectedUnits[0]
            GSU_lbl.text = selectedUnits[0]
        }
        
        if selectedUnits[5] == "" {
            windSpeedUlbl.text = defUnits[5]
        }else{
            windSpeedUlbl.text = selectedUnits[5]
        }
        
        if selectedUnits[12] == "" {
            WCAU_lbl.text = defUnits[12]
            //HDGU_lbl.text = defUnits[12]
        }else{
            WCAU_lbl.text = selectedUnits[12]
            //HDGU_lbl.text = selectedUnits[12]
        }
        
        var sValue = selValues.speed
        sValue = sValue?.replacingOccurrences(of: ",", with: ".")
        
        var wValue = selValues.windSpeed
        wValue = wValue?.replacingOccurrences(of: ",", with: ".")
        
        let wDValue = selValues.windDirection
        let cDValue = selValues.crsDirection
        
        if sValue == nil || sValue == ""{
            inputSpeed.text = "0.0"
            sSlider.value = 0.0
            speedVal = 0.0
        }else{
            inputSpeed.text = sValue
            sSlider.value = Float(sValue!)!
            speedVal = Float(sValue!)!
        }
        
        if wValue == nil || wValue == "" {
            inputWindSpeed.text = String(setValues[5])
            windSpeedVal = Float(setValues[5])
            wsSlider.value = windSpeedVal
        }else{
            inputWindSpeed.text = wValue
            windSpeedVal = Float(wValue!)!
            wsSlider.value = windSpeedVal
        }
        
        if wDValue != nil {
            inputWind.text = wDValue
        }
        
        if cDValue != nil {
            inputCrs.text = cDValue
        }
    }
    
    //MARK: PICKERVIEW Section: Delegates and DataSources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return maxElements
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerView.backgroundColor = bgColor
        
        let myRow = row % degrees.count
        
        switch activeTextField {
        case 1:
            let myString = String(degrees[myRow])
            pickerLabel.text = myString
        case 2:
            let myString = String(degreesCrs[myRow])
            pickerLabel.text = myString
        default:
            break
        }
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let myRow = row % degrees.count
        
        switch activeTextField {
        case 1:
            let myString = String(degrees[myRow])
            return myString
        case 2:
            let myString = String(degreesCrs[myRow])
            return myString
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int){
        let myRow = row % degrees.count
        
        switch activeTextField {
        case 1:
            let myString = String(degrees[myRow])
            activeValue = myString
            inputWind.text = myString  + "°"
        case 2:
            let myString = String(degreesCrs[myRow])
            activeValue = myString
            inputCrs.text = myString  + "°"
        default:
            activeValue = ""
        }
        
        pickerView.selectRow((maxElements / 2) + row, inComponent: 0, animated:false)
    }
    
    func pickUpValue(textField: UITextField) {
        degPicker = UIPickerView(frame:CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width, height: 216)))
        
        degPicker.delegate = self
        degPicker.dataSource = self
        
        let wDValue = selValues.windDirection
        let cDValue = selValues.crsDirection
        
        //pickerView additional labels
        let dW = UIScreen.main.bounds.width
        let dH = degPicker.frame.size.height
        
        let pickerLabel = UILabel(frame: CGRect(x: CGFloat(dW/2 + 30), y: CGFloat(dH / 2 - 20), width: CGFloat(75), height: CGFloat(30)))
        pickerLabel.text = "°"
        pickerLabel.textColor = UIColor.white
        degPicker.addSubview(pickerLabel)
        
        //  ^^pickerViewToolbar config start^^
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 30.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(title: (NSLocalizedString("DoneBtn", comment: "Done Btn Label")), style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneTapped))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 2, height: self.view.frame.size.height))
        
        if textField == inputWind {
            label.text = NSLocalizedString("WindDirectionLabel", comment: "Wind Direction Label")
        }else if textField == inputCrs {
            label.text = NSLocalizedString("CourseLabel", comment: "Course Label")
        }
        label.font = UIFont(name: "Avenir-Book", size: 12)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        if textField == inputCrs || textField == inputWind {
            textField.inputAccessoryView = toolBar
        }
        //  ^^pickerViewToolbar config end^^
        
        switch activeTextField {
        case 1:
            if wDValue == "" || wDValue == nil {
                degPicker.selectRow(maxElements / 2, inComponent: 0, animated: false)
            }else{
                let degLess = Int((wDValue?.replacingOccurrences(of: "°", with: "", options: .literal, range: nil))!)
                degPicker.selectRow(maxElements / 2 + degLess!, inComponent: 0, animated: false)
            }
        case 2:
            if cDValue == "" || cDValue == nil {
                degPicker.selectRow(maxElements / 2, inComponent: 0, animated: false)
            }else{
                let degLess = Int((cDValue?.replacingOccurrences(of: "°", with: "", options: .literal, range: nil))!)
                degPicker.selectRow(maxElements / 2 + degLess!, inComponent: 0, animated: false)
            }
        default:
            degPicker.selectRow(maxElements / 2, inComponent: 0, animated: false)
            
        }
        
        if let currentValue = Int(inputWind.text!) {
            
            var row : Int?
            
            switch activeTextField {
            case 1:
                row = degrees.index(of: currentValue)
            case 2:
                row = degreesCrs.index(of: currentValue)
            default:
                row = nil
            }
            
            if row != nil {
                degPicker.selectRow(row!, inComponent: 0, animated: true)
            }
        }
        
        if (textField == inputWind || textField == inputCrs) {
            textField.inputView = self.degPicker
            textField.tintColor = UIColor.clear
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let myRow = row % degrees.count
        
        let str = String(degrees[myRow])
        
        let attributedString = NSAttributedString(string: str, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        
        return attributedString
    }
    
    //MARK: TEXTFIELDS interaction section
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem = hideBarButton
        
        scrollV.setContentOffset(CGPoint(x: 0,y: 25), animated: true)
        
        switch textField {
        case inputWind:
            activeTextField = 1
        case inputCrs:
            activeTextField = 2
        default:
            activeTextField = 0
        }
        activeTF = textField
        
        self.pickUpValue(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.navigationItem.rightBarButtonItem = nil
        
        if (textField == inputWind || textField == inputCrs) {
            scrollV.setContentOffset(CGPoint(x: 0,y: -65), animated: true)
        }else if (textField == inputWindSpeed) {
            scrollV.setContentOffset(CGPoint(x: 0,y: -65 ), animated: true)
            
            if inputWindSpeed.text != "" {
                wsSlider.value = Float(inputWindSpeed.text!)!
            }else{
                wsSlider.value = 0.0
            }
        }else if (textField == inputSpeed) {
            scrollV.setContentOffset(CGPoint(x: 0,y: -65 ), animated: true)
            
            if inputSpeed.text != "" {
                sSlider.value = Float(inputSpeed.text!)!
            }else{
                sSlider.value = 0.0
            }
        }
    }
    
    //MARK: Additional functions
    @objc func doneTapped(_ sender: UIBarButtonItem) {
        calculate()
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        inputCrs.resignFirstResponder()
        inputWind.resignFirstResponder()
        inputWindSpeed.resignFirstResponder()
        inputSpeed.resignFirstResponder()
        
        calculate()
    }
}

