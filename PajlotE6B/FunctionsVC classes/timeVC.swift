
import UIKit

class timeVC: UIViewController,
                UITextFieldDelegate,
                UIScrollViewDelegate {
    
    //MARK: Properties
    var speedVal: Float = 0.0
    var speedMaxVal: Float!
    var distanceVal: Float = 0.0
    var distanceMaxVal: Float!
    var resultTime: Float = 0.0
    
    var hhmmss = [[String]]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: IBOutlets: textfields
    @IBOutlet weak var inputSpeed: UITextField!
    @IBOutlet weak var inputDistance: UITextField!

    // MARK: IBOutlets: sliders
    @IBOutlet weak var sSlider: UISlider!
    @IBOutlet weak var dSlider: UISlider!
    
    // MARK: IBOutlets: labels
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var timeUlbl: UILabel!
    @IBOutlet weak var speedUlbl: UILabel!
    @IBOutlet weak var distanceUlbl: UILabel!
    
    // MARK: IBOutlets: views
    @IBOutlet weak var tContainer: UIView!
    @IBOutlet weak var bContainer: UIView!

    var hideBarButton : UIBarButtonItem!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        title = NSLocalizedString("TimeLabel", comment: "Time Title").localiz()

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

        inputDistance.attributedPlaceholder = NSAttributedString(string:"podaj dystans", attributes:[NSAttributedStringKey.foregroundColor: phColor])
        
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
        
        distanceVal = (dSlider.value).roundTo(places: 2)
        selValues.distance = String(distanceVal)
        
        if inputSpeed.text != "" {
            sSlider.value = Float(inputSpeed.text!)!
        }else{
            sSlider.value = 0.0
        }
        
        if inputDistance.text != "" {
            dSlider.value = Float(inputDistance.text!)!
        }else{
            dSlider.value = 0.0
        }
        hideKeyboard()
        
    }
    
    //MARK: - IBActions > distance section
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
        distanceVal = (sender.value).roundTo(places: 1)
        selValues.distance = String(distanceVal)
        inputDistance.text = String(distanceVal)
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
        let distanceUnit = selectedUnits[1]
        let timeUnit = selectedUnits[2]
        var speedMPS : Float
        var distanceM : Float
        var timeS : Int

        let hours : String
        let minutes : String
        let seconds : String
        
        speedVal = sSlider.value
        distanceVal = dSlider.value
        
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
        
        if speedMPS == 0 || distanceM == 0 {
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
            
            timeS = Int(round(distanceM / speedMPS))
            
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
    
    func updateMaxVal (){
        if setValues[0] == 0 {
            speedMaxVal = Float(defValues[0])
            sSlider.maximumValue = Float(defValues[0])
        }else{
            speedMaxVal = Float(setValues[0])
            sSlider.maximumValue = Float(setValues[0])
        }
        
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
        
        if selectedUnits[2] == "" {
            timeUlbl.text = defUnits[2]
        }else{
            timeUlbl.text = selectedUnits[2]
        }
        
        let Svalue = selValues.speed
        
        if Svalue == nil || Svalue == "" {
            sSlider.value = 0.0
            inputSpeed.text = "0.0"
        }else{
            sSlider.value = Float(Svalue!)!
            inputSpeed.text = Svalue
        }
        
        let Dvalue = selValues.distance
        if Dvalue == nil || Dvalue == "" {
            dSlider.value = 0.0
            inputDistance.text = "0.0"
        }else{
            dSlider.value = Float(Dvalue!)!
            inputDistance.text = Dvalue
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
        }else if textField == inputDistance {
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
        }else if textField == inputDistance {
            distanceVal = (dSlider.value).roundTo(places: 2)
            selValues.distance = String(distanceVal)
            if inputDistance.text != "" {
                dSlider.value = Float(inputDistance.text!)!
            }else{
                dSlider.value = 0.0
            }
        }
    }
    
    //MARK: Additional functions
    func secondsToHMS (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc func hideKeyboard() {
        inputSpeed.resignFirstResponder()
        inputDistance.resignFirstResponder()
        
        calculate()
    }
}
