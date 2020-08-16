
import UIKit

class distanceVC: UIViewController,
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
    @IBOutlet weak var inputSpeed: UITextField!
    @IBOutlet weak var inputTime: UITextField!
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: - IBOutlets: slider
    @IBOutlet weak var sSlider: UISlider!

    // MARK: IBOutlets: labels
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var speedUlbl: UILabel!
    @IBOutlet weak var distanceUlbl: UILabel!
    
    // MARK: IBOutlets: views
    @IBOutlet weak var speedContainer: UIView!
    @IBOutlet weak var timeContainer: UIView!
    
    var timePickerView = UIPickerView()
    
    var speedVal: Float = 0.0
    var speedMaxVal: Float!
    
    var timeVal: Float = 0.0
    var resultDistance: Float = 0.0
    
    var hideBarButton: UIBarButtonItem!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("DistanceLabel", comment: "Distance Title").localiz()
        
        hhmmss.append(hh)
        hhmmss.append(mm)
        hhmmss.append(ss)
        
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
        inputSpeed.attributedPlaceholder = NSAttributedString(string:"podaj prędkość", attributes:[NSAttributedStringKey.foregroundColor: phColor])
        
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
        updateMaxVal()
        updateView()
        updatePicker(picker: timePickerView)
        calculate()
    }
    
    override func viewDidLayoutSubviews() {
        speedContainer.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        timeContainer.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
    }

    
    // MARK: - IBActions > textFields section
    @IBAction func timeTFTapped(_ sender: UITextField) {
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
        
//        selValues.speed = inputSpeed.text
//        let val = String(selValues.speed)
//        if val == "" {
//            speedVal = 0.0
//        }else{
//            speedVal = Float(val)!
//        }
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
            speedVal = speedVal.roundTo(places: 1)
            speedVal -= 1.0
            selValues.speed = String(speedVal)
            inputSpeed.text = String(speedVal)
            sSlider.value = speedVal
            hideKeyboard()
        }
    }
    
    @IBAction func increesSpeed(_ sender: Any) {
        if speedVal >= 0 && speedVal <= (speedMaxVal - 1.0) {
            speedVal = speedVal.roundTo(places: 1)
            speedVal += 1.0
            selValues.speed = String(speedVal)
            inputSpeed.text = String(speedVal)
            sSlider.value = speedVal
            hideKeyboard()
        }
    }
    
    //MARK: IBActions > addition def speed buttons
    @IBAction func btn80(_ sender: Any) {
        speedVal = 80
        selValues.speed = String(speedVal)
        sSlider.value = speedVal
        inputSpeed.text = selValues.speed
        calculate()
    }
    @IBAction func btn100(_ sender: Any) {
        speedVal = 100
        selValues.speed = String(speedVal)
        sSlider.value = speedVal
        inputSpeed.text = selValues.speed
        calculate()
    }
    @IBAction func btn150(_ sender: Any) {
        speedVal = 150
        selValues.speed = String(speedVal)
        sSlider.value = speedVal
        inputSpeed.text = selValues.speed
        calculate()
    }
    @IBAction func btn180(_ sender: Any) {
        speedVal = 180
        selValues.speed = String(speedVal)
        sSlider.value = speedVal
        inputSpeed.text = selValues.speed
        calculate()
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
    @IBAction func time2(_ sender: Any) {
        hours = 0
        minutes = 2
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
    
    // MARK: - Functions
    func calculate(){
        let speedUnit = selectedUnits[0]
        let distanceUnit = selectedUnits[1]
        
        var speedMPS : Float
        var distanceM : Float
        
        speedVal = sSlider.value
        timeVal = Float(hours * 3600 + minutes * 60 + seconds)
        
        switch speedUnit {
            case "KPH":
                speedMPS = (speedVal * 0.277777778).roundTo(places: 2)
            case "KT":
                speedMPS = (speedVal * 0.514444444).roundTo(places: 2)
            case "MPH":
                speedMPS = (speedVal * 0.44704).roundTo(places: 2)
            default:
                speedMPS = (speedVal * 0.277777778).roundTo(places: 2)
            }
        
        distanceM = speedMPS * timeVal
        
        switch distanceUnit {
        case "km":
            resultDistance = (distanceM/1000).roundTo(places: 1)
        case "NM":
            resultDistance = (distanceM*0.000539956803).roundTo(places: 1)
        case "SM":
            resultDistance = (distanceM*0.000621371192).roundTo(places: 1)
        default:
            resultDistance = (distanceM/1000).roundTo(places: 1)
        }
        result.text = "\(resultDistance)"
        
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
    
    func updatePicker (picker: UIPickerView){
        picker.selectRow(hours, inComponent: 0, animated: true)
        picker.selectRow(minutes, inComponent: 1, animated: true)
        picker.selectRow(seconds, inComponent: 2, animated: true)
    }
    
    func updateView (){
        
        if selectedUnits[0] == "" {
            speedUlbl.text = defUnits[0]
        }else{
            speedUlbl.text = selectedUnits[0]
        }
        
        if selectedUnits[1] == "" {
            distanceUlbl.text = defUnits[1]
        }else{
            distanceUlbl.text = selectedUnits[1]
        }
        
        let sValue = selValues.speed
        
        if sValue == nil || sValue == ""{
            inputSpeed.text = "0.0"
            sSlider.value = 0.0
            speedVal = 0.0
        }else{
            inputSpeed.text = sValue
            sSlider.value = Float(sValue!)!
            speedVal = Float(sValue!)!
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
        
        if textField == inputSpeed {
            speedVal = (sSlider.value).roundTo(places: 1)
            selValues.speed = String(speedVal)
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
        inputSpeed.resignFirstResponder()
        inputTime.resignFirstResponder()
        
        calculate()
    }
}
