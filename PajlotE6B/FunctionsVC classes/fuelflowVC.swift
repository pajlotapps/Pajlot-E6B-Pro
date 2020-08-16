
import UIKit

class fuelflowVC: UIViewController,
                    UIPickerViewDelegate,
                    UIPickerViewDataSource,
                    UITextFieldDelegate,
                    UIScrollViewDelegate {
    
    //MARK: Properties
    private let hh = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    private let mm = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    private let ss = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    
    var hhmmss = [[String]]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var inputFuelFlowRate: UITextField!
    @IBOutlet weak var inputTime: UITextField!
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: - IBOutlets: slider
    @IBOutlet weak var ffrSlider: UISlider!
    
    // MARK: IBOutlets: labels
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var fuelflowUlbl: UILabel!
    @IBOutlet weak var resultUlbl: UILabel!
    @IBOutlet weak var fuelTypelbl: UILabel!
    @IBOutlet weak var fuellbl: UILabel!

    
    // MARK: IBOutlets: views
    @IBOutlet weak var fuelflowContainer: UIView!
    @IBOutlet weak var timeContainer: UIView!
    
    var timePickerView = UIPickerView()
    
    var fuelFlowRateVal: Float = 0.0
    
    var timeVal: Float = 0.0
    var resultFuel: Float = 0.0
    
    var hideBarButton: UIBarButtonItem!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("FuelLabel", comment: "Fuel flow rate Title").localiz()
        
        fuellbl.text = NSLocalizedString("FuelTypeLabel", comment: "Fuel type")
        
        hhmmss.append(hh)
        hhmmss.append(mm)
        hhmmss.append(ss)
        
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
        
        timePickerView = UIPickerView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(216)))
        
        timePickerView.dataSource = self
        timePickerView.delegate = self
        
        inputTime.inputView = timePickerView
        inputTime.tintColor = UIColor.clear
        
        updatePicker(picker: timePickerView)
        
        //  ^^pickerViewToolbar config start^^
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 30.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(title: (NSLocalizedString("DoneBtn", comment: "Done Btn Label")), style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneTapped))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 2, height: self.view.frame.size.height))
        label.text = (NSLocalizedString("TimeLabel", comment: "Done Btn Label"))
        label.font = UIFont(name: "Avenir-Book", size: 12)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        inputTime.inputAccessoryView = toolBar
        //  ^^pickerViewToolbar config end^^
        
        //custom textField
        inputFuelFlowRate.attributedPlaceholder = NSAttributedString(string:"podaj zużycie paliwa", attributes:[NSAttributedStringKey.foregroundColor: phColor])
        
        inputTime.attributedPlaceholder = NSAttributedString(string:"[hh] [mm] [ss]", attributes:[NSAttributedStringKey.foregroundColor: phColor])
        
        //pickerView additional labels
        let sW = timePickerView.frame.size.width
        let sH = timePickerView.frame.size.height
        
        let hourLabel = UILabel(frame: CGRect(x: CGFloat(sW/4), y: CGFloat(sH / 2 - 15), width: CGFloat(75), height: CGFloat(30)))
        hourLabel.text = "HH"
        hourLabel.textColor = UIColor.white
        timePickerView.addSubview(hourLabel)
        
        let minsLabel = UILabel(frame: CGRect(x: CGFloat(sW/4 + (sW / 3)), y: CGFloat(sH / 2 - 15), width: CGFloat(75), height: CGFloat(30)))
        minsLabel.text = "MM"
        minsLabel.textColor = UIColor.white
        timePickerView.addSubview(minsLabel)
        
        let secsLabel = UILabel(frame: CGRect(x: CGFloat(sW/4 + ((sW / 3) * 2)), y: CGFloat(sH / 2 - 15), width: CGFloat(75), height: CGFloat(30)))
        secsLabel.text = "SS"
        secsLabel.textColor = UIColor.white
        timePickerView.addSubview(secsLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updateView()
        updatePicker(picker: timePickerView)
        calculate()
    }
    
    override func viewDidLayoutSubviews() {
        fuelflowContainer.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        timeContainer.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions > textFields section
    @IBAction func timeTFTapped(_ sender: UITextField) {
        hideKeyboard()
    }
    
    //MARK: - IBActions > speed section
    @IBAction func fuelflowTFTapped(_ sender: UITextField) {
        
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
    
    @IBAction func fuelflowSlider(_ sender: UISlider) {
        fuelFlowRateVal = (sender.value).roundTo(places: 1)
        selValues.fuelflow = String(fuelFlowRateVal)
        inputFuelFlowRate.text = String(fuelFlowRateVal)
        hideKeyboard()
    }
    
    @IBAction func decreesFuelFlow(_ sender: Any) {
        if fuelFlowRateVal <= 1500 && fuelFlowRateVal >= 1 {
            fuelFlowRateVal = fuelFlowRateVal.roundTo(places: 1)
            fuelFlowRateVal -= 1.0
            selValues.fuelflow = String(fuelFlowRateVal)
            inputFuelFlowRate.text = String(fuelFlowRateVal)
            ffrSlider.value = fuelFlowRateVal
            hideKeyboard()
        }
    }
    
    @IBAction func increesFuelFlow(_ sender: Any) {
        if fuelFlowRateVal >= 0 && fuelFlowRateVal <= (1499) {
            fuelFlowRateVal = fuelFlowRateVal.roundTo(places: 1)
            fuelFlowRateVal += 1.0
            selValues.fuelflow = String(fuelFlowRateVal)
            inputFuelFlowRate.text = String(fuelFlowRateVal)
            ffrSlider.value = fuelFlowRateVal
            hideKeyboard()
        }
    }
    
    //MARK: IBActions > addition def time buttons
    @IBAction func time1(_ sender: Any) {
        hours = 0
        minutes = 1
        seconds = 0
        
        selValues.hh = String(hours)
        selValues.mm = String(minutes)
        selValues.ss = String(seconds)
        
        selValues.hh = hhmmss[0][hours]
        selValues.mm = hhmmss[1][minutes]
        selValues.ss = hhmmss[2][seconds]
        
        inputTime.text = selValues.hh + " : " + selValues.mm + " : " + selValues.ss
        calculate()
    }
    @IBAction func time5(_ sender: Any) {
        hours = 0
        minutes = 5
        seconds = 0
        
        selValues.hh = String(hours)
        selValues.mm = String(minutes)
        selValues.ss = String(seconds)
        
        selValues.hh = hhmmss[0][hours]
        selValues.mm = hhmmss[1][minutes]
        selValues.ss = hhmmss[2][seconds]
        
        inputTime.text = selValues.hh + " : " + selValues.mm + " : " + selValues.ss
        calculate()
    }
    @IBAction func time10(_ sender: Any) {
        hours = 0
        minutes = 10
        seconds = 0
        
        selValues.hh = String(hours)
        selValues.mm = String(minutes)
        selValues.ss = String(seconds)
        
        selValues.hh = hhmmss[0][hours]
        selValues.mm = hhmmss[1][minutes]
        selValues.ss = hhmmss[2][seconds]
        
        inputTime.text = selValues.hh + " : " + selValues.mm + " : " + selValues.ss
        calculate()
    }
    @IBAction func time60(_ sender: Any) {
        hours = 1
        minutes = 0
        seconds = 0
        
        selValues.hh = String(hours)
        selValues.mm = String(minutes)
        selValues.ss = String(seconds)
        
        selValues.hh = hhmmss[0][hours]
        selValues.mm = hhmmss[1][minutes]
        selValues.ss = hhmmss[2][seconds]
        
        inputTime.text = selValues.hh + " : " + selValues.mm + " : " + selValues.ss
        calculate()
    }
    
    // MARK: - Functions
    func calculate(){
        let fuelFlowRateUnit = selectedUnits[6]
        let usableFuelUnit = selectedUnits[13]
        
        var fuelL : Float
        var ffrLPH : Float
        
        var fuel : Float
        fuelFlowRateVal = ffrSlider.value
        timeVal = Float(hours * 3600 + minutes * 60 + seconds)

        switch fuelType {
            case "JET A1":
                switch fuelFlowRateUnit {
                    case "l/h":
                        ffrLPH = fuelFlowRateVal
                    case "kg/h":
                        ffrLPH = (fuelFlowRateVal / 0.8).roundTo(places: 2)
                    case "lbs/h":
                        ffrLPH = (fuelFlowRateVal / 1.76).roundTo(places: 2)
                    default:
                        ffrLPH = fuelFlowRateVal
                    }
            case "AVGAS":
                switch fuelFlowRateUnit {
                    case "l/h":
                        ffrLPH = fuelFlowRateVal
                    case "kg/h":
                        ffrLPH = (fuelFlowRateVal / 0.79).roundTo(places: 2)
                    case "lbs/h":
                        ffrLPH = (fuelFlowRateVal / 1.76).roundTo(places: 2)
                    default:
                        ffrLPH = fuelFlowRateVal
                }
            default:
                switch fuelFlowRateUnit {
                case "l/h":
                    ffrLPH = fuelFlowRateVal
                case "kg/h":
                    ffrLPH = (fuelFlowRateVal / 0.8).roundTo(places: 2)
                case "lbs/h":
                    ffrLPH = (fuelFlowRateVal / 1.76).roundTo(places: 2)
                default:
                    ffrLPH = fuelFlowRateVal
                }
            }
        
        if timeVal == 0 || ffrLPH == 0 {
            fuelL = 0
            fuel = fuelL
            result.text = "000.0"
        }else{
            fuelL = (ffrLPH / 3600 * timeVal)
            
            switch usableFuelUnit {
                case "l":
                    fuel = fuelL.roundTo(places: 1)
                case "kg":
                    switch fuelType {
                        case "JET A1":
                            fuel = (fuelL * 0.79).roundTo(places: 1)
                        case "AVGAS":
                            fuel = (fuelL * 0.72).roundTo(places: 1)
                        default:
                            fuel = (fuelL * 0.79).roundTo(places: 1)
                    }
                case "lb":
                    switch fuelType {
                        case "JET A1":
                            fuel = (fuelL * 1.76).roundTo(places: 1)
                        case "AVGAS":
                            fuel = (fuelL * 1.58).roundTo(places: 1)
                        default:
                            fuel = (fuelL * 1.76).roundTo(places: 1)
                        }
                default:
                    fuel = fuelL.roundTo(places: 1)
            }
    
            result.text = "\(fuel)"

        }
    }

    func updatePicker (picker: UIPickerView){
        picker.selectRow(hours, inComponent: 0, animated: true)
        picker.selectRow(minutes, inComponent: 1, animated: true)
        picker.selectRow(seconds, inComponent: 2, animated: true)
    }
    
    func updateView (){
        
        if selectedUnits[6] == "" {
            fuelflowUlbl.text = defUnits[6]
        }else{
            fuelflowUlbl.text = selectedUnits[6]
        }
        
        if selectedUnits[13] == "" {
            resultUlbl.text = defUnits[13]
        }else{
            resultUlbl.text = selectedUnits[13]
        }
        
        let FFRvalue = selValues.fuelflow
        if FFRvalue == nil || FFRvalue == "" {
            if setValues[7] == 0 {
                ffrSlider.value = Float(defValues[7])
                inputFuelFlowRate.text = "\(defValues[7])"
            }else{
                ffrSlider.value = Float(setValues[7])
                inputFuelFlowRate.text = "\(setValues[7])"
            }
        }else{
            ffrSlider.value = Float(FFRvalue!)!
            inputFuelFlowRate.text = FFRvalue
        }
        
        if selValues.hh != nil {
            inputTime.text = selValues.hh + " : 00 : 00"
            if selValues.mm != nil {
                inputTime.text = selValues.hh + " : " + selValues.mm + " : 00"
                if selValues.ss != nil {
                    inputTime.text = selValues.hh + " : " + selValues.mm + " : " + selValues.ss
                }
            }
        }else if selValues.mm != nil {
            inputTime.text = "00 : " + selValues.mm + " : 00"
            if selValues.ss != nil {
                inputTime.text = "00 : " + selValues.mm + " : " + selValues.ss
            }
        }else if selValues.ss != nil {
            inputTime.text = "00 : 00 : " + selValues.ss
        }
        
        if fuelType != "" {
            fuelTypelbl.text = prefs.string(forKey: Keys.fuelTypeV)
        }else{
            fuelTypelbl.text = defFuelType
        }
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return hhmmss.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return hhmmss[component].count
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerView.backgroundColor = bgColor
        
        switch component {
        case 0:
            let myString = hh[row]
            pickerLabel.text = myString
            return pickerLabel
        case 1:
            let myString = mm[row]
            pickerLabel.text = myString
            return pickerLabel
        case 2:
            let myString = ss[row]
            pickerLabel.text = myString
            return pickerLabel
        default:
            break
        }
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return hhmmss[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int){
        
        hours = pickerView.selectedRow(inComponent: 0)
        minutes = pickerView.selectedRow(inComponent: 1)
        seconds = pickerView.selectedRow(inComponent: 2)
        
        selValues.hh = hhmmss[0][hours]
        selValues.mm = hhmmss[1][minutes]
        selValues.ss = hhmmss[2][seconds]
        
        inputTime.text = selValues.hh + " : " + selValues.mm + " : " + selValues.ss
    }
    
    //MARK: TEXTFIELDS interaction section
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.navigationItem.rightBarButtonItem = hideBarButton
        
        scrollV.setContentOffset(CGPoint(x: 0,y: 10), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.navigationItem.rightBarButtonItem = nil
        
        scrollV.setContentOffset(CGPoint(x: 0,y: -65 ), animated: true)
        
        if textField == inputFuelFlowRate {
            fuelFlowRateVal = (ffrSlider.value).roundTo(places: 1)
            selValues.fuelflow = String(fuelFlowRateVal)
            if inputFuelFlowRate.text != "" {
                ffrSlider.value = Float(inputFuelFlowRate.text!)!
            }else{
                ffrSlider.value = 0.0
            }
        }
    }
    
    //MARK: Additional functions
    @objc func doneTapped(_ sender: UIBarButtonItem) {
        calculate()
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        inputFuelFlowRate.resignFirstResponder()
        inputTime.resignFirstResponder()
        
        calculate()
    }
}
