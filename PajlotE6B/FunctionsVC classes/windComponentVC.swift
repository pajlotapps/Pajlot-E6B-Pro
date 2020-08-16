
import UIKit

class windComponentVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UITextFieldDelegate {
    
    //MARK: Properties
    let maxRows = 100
    private let maxElements = 36000
    let degrees = [Int](0...359)
    let degreesCrs = [Int](0...359)
    
    var windSpeedVal: Float = 0.0
    
    var degPicker: UIPickerView!
    var activeTextField = 0
    var activeTF: UITextField!
    var activeValue = ""
    
    var hideBarButton : UIBarButtonItem!
    
    // MARK: - Outlets
    @IBOutlet weak var scrolV: UIScrollView!
    
    // MARK: - Outlets - Views
    @IBOutlet weak var tContainer: UIView!
    @IBOutlet weak var bContainer: UIView!
    
    // MARK: - Outlets - TextFields
    @IBOutlet weak var inputWindSpeed: UITextField!
    @IBOutlet weak var inputWind: UITextField!
    @IBOutlet weak var inputCrs: UITextField!
    
    // MARK: - Outlets - Labels
    @IBOutlet weak var hwResult: UILabel!
    @IBOutlet weak var hwUlbl: UILabel!
    @IBOutlet weak var cwResult: UILabel!
    @IBOutlet weak var cwUlbl: UILabel!
    @IBOutlet weak var windSpeedUlbl: UILabel!
    @IBOutlet weak var headwindLbl: UILabel!
    @IBOutlet weak var crosswindLbl: UILabel!
    
    @IBOutlet weak var windDirectionLbl: UILabel!
    @IBOutlet weak var courseLbl: UILabel!
    
    // MARK: - Outlets - Sliders
    @IBOutlet weak var wsSlider: UISlider!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("WindComponetLabel", comment: "Wind Component Title").localiz()
        headwindLbl.text = NSLocalizedString("HWC", comment: "Headwind Label")
        crosswindLbl.text = NSLocalizedString("CWC", comment: "Crosswind Label")
        windDirectionLbl.text = NSLocalizedString("WindDirectionLabel", comment: "Wind Direction Label")
        courseLbl.text = NSLocalizedString("CourseLabel", comment: "Course Label")
        
        inputWind.delegate = self
        inputCrs.delegate = self
        
        updateView()
        calculate()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrolV.addGestureRecognizer(tapGesture)
        
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

    //MARK: IBActions
    @IBAction func upgradePro(_ sender: Any) {
        usefulFunctions().jumpToUpgradeVC()
    }
    
    // MARK: - IBActions
    @IBAction func windTFTapped(_ sender: UITextField) {
        selValues.windDirection = inputWind.text
        hideKeyboard()
    }
    
    @IBAction func crsTFTapped(_ sender: UITextField) {
        selValues.crsDirection = inputCrs.text
        hideKeyboard()
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
        
        let speedUnit = selectedUnits[0]
        let windSpeedUnit = selectedUnits[5]
        
        let WD : Int
        var CRS : Int
        var WS : Float
        
        var ALPHA : Int
        var HW : Float
        var CW : Float
        
        let WSmps : Float
        let HWmps : Float
        let CWmps : Float
        
        WS = wsSlider.value
        selValues.windSpeed = String(WS)
        
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
        
        ALPHA = (WD - CRS)
        if ALPHA == 0 {
            CWmps = 0.0
            HWmps = WSmps
        }else if ALPHA == 180 {
            CWmps = 0.0
            HWmps = -WSmps
        }else if ALPHA == 90 {
            CWmps = WSmps
            HWmps = 0.0
        }else if ALPHA == 270 {
            CWmps = -WSmps
            HWmps = 0.0
        }else{
            CWmps = WSmps * Float(sin(ALPHA.degreesToRadians))
            HWmps = WSmps * Float(cos(ALPHA.degreesToRadians))
        }
        
        switch speedUnit {
        case "KPH":
            HW = (HWmps * 3.6).roundTo(places: 2)
            CW = (CWmps * 3.6).roundTo(places: 2)
        case "KT":
            HW = (HWmps * 1.94384449).roundTo(places: 2)
            CW = (CWmps * 1.94384449).roundTo(places: 2)
        case "MPH":
            HW = (HWmps * 2.23693629).roundTo(places: 2)
            CW = (CWmps * 2.23693629).roundTo(places: 2)
        default:
            HW = (HWmps * 3.6).roundTo(places: 2)
            CW = (CWmps * 3.6).roundTo(places: 2)
        }
        
        cwResult.text = String(CW)
        hwResult.text = String(HW)
    }
    
    func updateView (){
        if selectedUnits[0] == "" {
            hwUlbl.text = defUnits[0]
            cwUlbl.text = defUnits[0]
        }else{
            hwUlbl.text = selectedUnits[0]
            cwUlbl.text = selectedUnits[0]
        }
        
        if selectedUnits[5] == "" {
            windSpeedUlbl.text = defUnits[5]
        }else{
            windSpeedUlbl.text = selectedUnits[5]
        }
        
        var wValue = selValues.windSpeed
        wValue = wValue?.replacingOccurrences(of: ",", with: ".")
        
        let wDValue = selValues.windDirection
        let cDValue = selValues.crsDirection
        
        if wValue == nil || wValue == "" {
            inputWindSpeed.text = "0.0"
            wsSlider.value = 0.0
            windSpeedVal = 0.0
        }else{
            inputWindSpeed.text = wValue
            wsSlider.value = Float(wValue!)!
            windSpeedVal = Float(wValue!)!
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
            label.text = "Kierunek wiatru"
        }else if textField == inputCrs {
            label.text = "Kurs SP"
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
        
        scrolV.setContentOffset(CGPoint(x: 0,y: 25), animated: true)
        
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
        
        scrolV.setContentOffset(CGPoint(x: 0,y: -65), animated: true)
        
        if textField == inputWindSpeed {
            if inputWindSpeed.text != "" {
                wsSlider.value = Float(inputWindSpeed.text!)!
            }else{
                wsSlider.value = 0.0
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
        
        
        calculate()
    }
}

