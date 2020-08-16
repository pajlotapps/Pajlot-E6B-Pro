
import UIKit

class speedVC: UIViewController,
                UIScrollViewDelegate,
                UIPickerViewDelegate,
                UIPickerViewDataSource,
                UITextFieldDelegate {
    
    //MARK: Properties
    var distanceVal: Float = 0.0
    var distanceMaxVal: Float!
    var timeVal: Float = 0.0
    var resultSpeed: Float = 0.0
    
    private let hh = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23"]
    private let mm = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    private let ss = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    
    var hhmmss = [[String]]()
    
    // MARK: - IBOutlets: Textfields
    @IBOutlet weak var inputDistance: UITextField!
    @IBOutlet weak var inputTime: UITextField!
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: IBOutlets: Slider
    @IBOutlet weak var dSlider: UISlider!

    // MARK: IBOutlets: Labels
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var distanceUlbl: UILabel!
    @IBOutlet weak var speedUlbl: UILabel!
    
    // MARK: IBOutlets: Views
    @IBOutlet weak var distanceContainer: UIView!
    @IBOutlet weak var timeContainer: UIView!
    
    var hideBarButton : UIBarButtonItem!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("SpeedLabel", comment: "Speed Title").localiz()

        
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
        
        let timePickerView = UIPickerView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(self.view.frame.size.width), height: CGFloat(216)))
        
        timePickerView.dataSource = self
        timePickerView.delegate = self
        
        inputTime.inputView = timePickerView
        inputTime.tintColor = UIColor.clear
        
        timePickerView.selectRow(hours, inComponent: 0, animated: true)
        timePickerView.selectRow(minutes, inComponent: 1, animated: true)
        timePickerView.selectRow(seconds, inComponent: 2, animated: true)
        
        //  ^^pickerViewToolbar config start^^
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 30.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height - 20.0)
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
        
        inputDistance.attributedPlaceholder = NSAttributedString(string:"podaj dystans", attributes:[NSAttributedStringKey.foregroundColor: phColor])
        
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
        calculate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func viewDidLayoutSubviews() {
        distanceContainer.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        timeContainer.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - IBActions section
    @IBAction func timeTFTapped(_ sender: UITextField) {
        hideKeyboard()
    }
    
    //MARK: - IBActions > distance
    @IBAction func distanceTFTapped(_ sender: UITextField) {
        if inputDistance.text?.count != 0 {
            if inputDistance.text?.first == "." || inputDistance.text?.first == "," {
                inputDistance.text = ""
                return
            }
            if var val = inputDistance.text {
                selValues.distance = val
                val = val.replacingOccurrences(of: ",", with: ".")
                distanceVal = Float(val)!
                inputDistance.text = val
            }
        }else{
            distanceVal = 0.0
        }
        hideKeyboard()
    }
    
    @IBAction func distanceSlider(_ sender: UISlider) {
        distanceVal = (sender.value).roundTo(places: 0)
        selValues.distance = String(distanceVal)
        inputDistance.text = selValues.distance
        hideKeyboard()
    }
    
    @IBAction func decreaseDistance(_ sender: Any) {
        if distanceVal <= distanceMaxVal && distanceVal >= 1 {
            distanceVal = distanceVal.roundTo(places: 1)
            distanceVal -= 1.0
            selValues.distance = String(distanceVal)
            inputDistance.text = String(distanceVal)
            dSlider.value = distanceVal
        }
    }
    
    @IBAction func increaseDistance(_ sender: Any) {
        if distanceVal >= 0 && distanceVal <= (distanceMaxVal - 1.0) {
            distanceVal = distanceVal.roundTo(places: 1)
            distanceVal += 1.0
            selValues.distance = String(distanceVal)
            inputDistance.text = String(distanceVal)
            dSlider.value = distanceVal
        }
    }
    
    //MARK: IBActions > addition def speed buttons
    @IBAction func btn1(_ sender: Any) {
        distanceVal = 1
        selValues.distance = String(distanceVal)
        dSlider.value = distanceVal
        inputDistance.text = selValues.distance
        calculate()
    }
    
    @IBAction func btn10(_ sender: Any) {
        distanceVal = 10
        selValues.distance = String(distanceVal)
        dSlider.value = distanceVal
        inputDistance.text = selValues.distance
        calculate()
    }
    
    @IBAction func btn50(_ sender: Any) {
        distanceVal = 50
        selValues.distance = String(distanceVal)
        dSlider.value = distanceVal
        inputDistance.text = selValues.distance
        calculate()
    }
    
    @IBAction func btn100(_ sender: Any) {
        distanceVal = 100
        selValues.distance = String(distanceVal)
        dSlider.value = distanceVal
        inputDistance.text = selValues.distance
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
    
    // MARK: - Functions
    func calculate(){
        let distanceUnit = selectedUnits[1]
        let speedUnit = selectedUnits[0]
        var speedMPS : Float
        var distanceM : Float
        
        distanceVal = dSlider.value
        timeVal = Float(hours * 3600 + minutes * 60 + seconds)
        
        switch distanceUnit {
        case "km":
            distanceM = (distanceVal*1000).roundTo(places: 2)
        case "NM":
            distanceM = (distanceVal*1852).roundTo(places: 2)
        case "SM":
            distanceM = (distanceVal*1609.344).roundTo(places: 2)
        default:
            distanceM = (distanceVal*1000).roundTo(places: 2)
        }
        if timeVal == 0 {
            speedMPS = 0
            result.text = "podaj czas"
        }else{
            speedMPS = distanceM / timeVal
            
            switch speedUnit {
                case "KPH":
                    resultSpeed = (speedMPS*3.6).roundTo(places: 1)
                case "KT":
                    resultSpeed = (speedMPS*1.94384449).roundTo(places: 1)
                case "MPH":
                    resultSpeed = (speedMPS*2.23693629).roundTo(places: 1)
                default:
                    resultSpeed = (speedMPS*3.6).roundTo(places: 1)
                }
        }
        
        result.text = "\(resultSpeed)"
        
    }
    
    func updateMaxVal (){
        if setValues[1] == 0 {
            distanceMaxVal = Float(defValues[1])
            dSlider.maximumValue = Float(defValues[1])
        }else{
            distanceMaxVal = Float(setValues[1])
            dSlider.maximumValue = Float(setValues[1])
        }
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
        
        let value = selValues.distance
        if value == nil || value == "" {
            dSlider.value = 0.0
            inputDistance.text = "0.0"
        }else{
            dSlider.value = Float(value!)!
            inputDistance.text = value
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
        
        if textField == inputDistance {
            distanceVal = (dSlider.value).roundTo(places: 1)
            selValues.distance = String(distanceVal)
            
            if inputDistance.text?.count != 0 {
                
                if var val = inputDistance.text {
                    val = val.replacingOccurrences(of: ",", with: ".")
                    dSlider.value = Float(val)!
                }
            }else{
                dSlider.value = 0.0
            }
        }
    }
    
    //MARK: Additional functions
    @objc func doneTapped(_ sender: UIBarButtonItem) {
        calculate()
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        inputDistance.resignFirstResponder()
        inputTime.resignFirstResponder()
        
        calculate()
    }
}
