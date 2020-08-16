
import UIKit

class vspeedVC: UIViewController,
                UIScrollViewDelegate,
                UITextFieldDelegate {
    
    //MARK: Properties
    var speedVal: Float = 0.0
    var speedMaxVal: Float!
    
    var distanceVal : Float = 0.0
    var distanceMaxVal: Float!
    
    var initialHVal: Float = 0.0
    var targetHVal: Float = 0.0
    var heightMaxVal: Float!
    
    var resultvSpeed: Float = 0.0

    // MARK: - IBOutlets
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: IBOutlets - TextFields
    @IBOutlet weak var inputSpeed: UITextField!
    @IBOutlet weak var inputDistance: UITextField!
    @IBOutlet weak var inputInitialH: UITextField!
    @IBOutlet weak var inputTargetH: UITextField!
    
    // MARK: IBOutlets: Slider
    @IBOutlet weak var sSlider: UISlider!
    @IBOutlet weak var dSlider: UISlider!
    @IBOutlet weak var iHSlider: UISlider!
    @IBOutlet weak var tHSlider: UISlider!
    
    // MARK: IBOutlets - Labels
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var vspeedUlbl: UILabel!
    @IBOutlet weak var speedUlbl: UILabel!
    @IBOutlet weak var distanceUlbl: UILabel!
    @IBOutlet weak var initialHUlbl: UILabel!
    @IBOutlet weak var targetHUlbl: UILabel!
    
    // MARK: IBOutlets - Views
    @IBOutlet weak var tContainer: UIView!
    @IBOutlet weak var bContainer: UIView!
    
    // MARK: IBOutlets - Images
    @IBOutlet weak var resIcon: UIImageView!
    
    var hideBarButton : UIBarButtonItem!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("VspeedLabel", comment: "Vertical Speed Title").localiz()

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
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    }
    
    override func viewDidLayoutSubviews() {
        tContainer.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        bContainer.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
    }
    
    //MARK: IBActions
    @IBAction func upgradePro(_ sender: Any) {
        usefulFunctions().jumpToUpgradeVC()
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
            speedVal -= 1.0
            selValues.speed = String(speedVal)
            inputSpeed.text = String(speedVal)
            selValues.speed = String(speedVal)
            sSlider.value = speedVal
        }
    }
    
    @IBAction func increaseSpeed(_ sender: Any) {
        if speedVal >= 0 && speedVal <= (speedMaxVal - 1.0) {
            speedVal += 1.0
            selValues.speed = String(speedVal)
            inputSpeed.text = String(speedVal)
            sSlider.value = speedVal
        }
    }
    
    //MARK: IBActions > distance section
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
            distanceVal -= 1.0
            selValues.distance = String(distanceVal)
            inputDistance.text = String(distanceVal)
            selValues.distance = String(distanceVal)
            dSlider.value = distanceVal
        }
    }
    
    @IBAction func increaseDistance(_ sender: Any) {
        if distanceVal >= 0 && distanceVal <= (distanceMaxVal - 1.0) {
            distanceVal += 1.0
            selValues.distance = String(distanceVal)
            inputDistance.text = String(distanceVal)
            dSlider.value = distanceVal
        }
    }
    
    //MARK: IBActions > initial height section
    @IBAction func initialHTFTapped(_ sender: UITextField) {
        if inputInitialH.text?.count != 0 {
            if inputInitialH.text?.first == "." || inputInitialH.text?.first == "," {
                inputInitialH.text = ""
                return
            }
            if var val = inputInitialH.text {
                selValues.initialH = val
                val = val.replacingOccurrences(of: ",", with: ".")
                initialHVal = Float(val)!
                inputInitialH.text = val
            }
        }else{
            initialHVal = 0.0
        }
        hideKeyboard()
    }
    
    @IBAction func initialHSlider(_ sender: UISlider) {
        initialHVal = (sender.value).roundTo(places: 1)
        selValues.initialH = String(initialHVal)
        inputInitialH.text = String(initialHVal)
        hideKeyboard()
    }
    
    @IBAction func decreaseInitialH(_ sender: Any) {
        if initialHVal >= 1 {
            initialHVal -= 1.0
            selValues.initialH = String(initialHVal)
            inputInitialH.text = String(initialHVal)
            selValues.initialH = String(initialHVal)
            iHSlider.value = initialHVal
            hideKeyboard()
        }
    }
    
    @IBAction func inreaseInitialH(_ sender: Any) {
        if initialHVal >= 0 && initialHVal <= (heightMaxVal - 1.0) {
            initialHVal += 1.0
            selValues.initialH = String(initialHVal)
            inputInitialH.text = String(initialHVal)
            selValues.initialH = String(initialHVal)
            iHSlider.value = initialHVal
            hideKeyboard()
        }
    }
    //MARK: - IBActions > target height section
    @IBAction func targetHTFTapped(_ sender: UITextField) {
        if inputTargetH.text?.count != 0 {
            if inputTargetH.text?.first == "." || inputTargetH.text?.first == "," {
                inputTargetH.text = ""
                return
            }
            if var val = inputTargetH.text {
                selValues.targetH = val
                val = val.replacingOccurrences(of: ",", with: ".")
                targetHVal = Float(val)!
                inputTargetH.text = val
            }
        }else{
            initialHVal = 0.0
        }
        hideKeyboard()
    }
    
    @IBAction func targetHSlider(_ sender: UISlider) {
        targetHVal = (sender.value).roundTo(places: 1)
        selValues.targetH = String(targetHVal)
        inputTargetH.text = String(targetHVal)
        hideKeyboard()
    }
    
    @IBAction func decreaseTargetH(_ sender: Any) {
        if targetHVal >= 1 {
            targetHVal -= 1.0
            selValues.targetH = String(targetHVal)
            inputTargetH.text = String(targetHVal)
            selValues.targetH = String(targetHVal)
            tHSlider.value = targetHVal
            hideKeyboard()
        }
    }
    
    @IBAction func increaseTargetH(_ sender: Any) {
        if targetHVal >= 0 && targetHVal <= (heightMaxVal - 1.0) {
            targetHVal += 1.0
            selValues.targetH = String(targetHVal)
            inputTargetH.text = String(targetHVal)
            selValues.targetH = String(targetHVal)
            tHSlider.value = targetHVal
            hideKeyboard()
        }
    }
    
    // MARK: - Functions
    func calculate(){
        resIcon.image = #imageLiteral(resourceName: "vspeedIcon")
        
        let speedUnit = selectedUnits[0]
        let distanceUnit = selectedUnits[1]
        let vspeedUnit = selectedUnits[3]
        let heightUnit = selectedUnits[4]

        if inputSpeed.text != "" {
            speedVal = Float(inputSpeed.text!)!
        }else{
            speedVal = 0
        }
        if inputDistance.text != "" {
            distanceVal = Float(inputDistance.text!)!
        }else{
            distanceVal = 0
        }
        if inputInitialH.text != "" {
            initialHVal = Float(inputInitialH.text!)!
        }else{
            initialHVal = 0
        }
        if inputTargetH.text != "" {
            targetHVal = Float(inputTargetH.text!)!
        }else{
            targetHVal = 0
        }
   
        var speedMPS : Float
        var distanceM : Float
        var heightM : Float
        
        var differenceH : Float
        var timeS : Float
        var vspeedMPS : Float
        
        var resultVspeed : Float
        
        switch speedUnit {
        case "KPH":
            speedMPS = round(100*speedVal * 0.277777778)/100
        case "KT":
            speedMPS = round(100*speedVal * 0.514444444)/100
        case "MPH":
            speedMPS = round(100*speedVal * 0.44704)/100
        default:
            speedMPS = round(100*speedVal * 0.277777778)/100
        }

        switch distanceUnit {
            case "km":
                distanceM = round(100*distanceVal*1000)/100
            case "NM":
                distanceM = round(100*distanceVal*1852)/100
            case "SM":
                distanceM = round(100*distanceVal*1609.344)/100
            default:
                distanceM = round(100*distanceVal*1000)/100
            }

        if initialHVal == targetHVal {
            differenceH = 0
            resIcon.image = #imageLiteral(resourceName: "vspeedIcon")
        }else if initialHVal == 0 && targetHVal != 0 {
            resIcon.image = #imageLiteral(resourceName: "climbIcon")
            differenceH = targetHVal
        }else if initialHVal != 0 && targetHVal == 0 {
            differenceH = initialHVal
            resIcon.image = #imageLiteral(resourceName: "descentIcon")
        }else{
            differenceH = abs(initialHVal - targetHVal)
            if initialHVal > targetHVal {
                resIcon.image = #imageLiteral(resourceName: "descentIcon")
            }else if targetHVal > initialHVal {
                resIcon.image = #imageLiteral(resourceName: "climbIcon")
            }else{
                resIcon.image = #imageLiteral(resourceName: "vspeedIcon")
            }
        }
        
        switch heightUnit {
            case "m":
                heightM = round(100*differenceH)/100
            case "ft":
                heightM = round(100*differenceH*0.3048)/100
            case "FL":
                heightM = round(100*differenceH*30.48)/100
            default:
                heightM = round(100*differenceH)/100
            }
        
        if speedVal == 0 || distanceVal == 0{
            timeS = 0
            vspeedMPS = 0
        }else{
            timeS =  distanceM / speedMPS
            vspeedMPS = heightM / timeS

        }
        
        switch vspeedUnit {
            case "m/s":
                resultVspeed = round(10*vspeedMPS)/10
                result.text = "\(resultVspeed)"
            case "ft/min":
                
                resultVspeed = vspeedMPS*196.850394
                result.text = "\(roundToTens(x: resultVspeed))"
            default:
                resultVspeed = round(10*vspeedMPS)/10
                result.text = "\(resultVspeed)"
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
            distanceMaxVal = Float(setValues[0])
            dSlider.maximumValue = Float(setValues[1])
        }
        
        if selectedUnits[4] == "" {
            heightMaxVal = 10000.0
            iHSlider.maximumValue = heightMaxVal
            tHSlider.maximumValue = heightMaxVal
        }else{
            switch selectedUnits[4] {
                case "m":
                    heightMaxVal = 10000.0
                    iHSlider.maximumValue = heightMaxVal
                    tHSlider.maximumValue = heightMaxVal
                case "ft":
                    heightMaxVal = 45000.0
                    iHSlider.maximumValue = heightMaxVal
                    tHSlider.maximumValue = heightMaxVal
                case "FL":
                    heightMaxVal = 430.0
                    iHSlider.maximumValue = heightMaxVal
                    tHSlider.maximumValue = heightMaxVal
                default:
                    heightMaxVal = 10000.0
                    iHSlider.maximumValue = heightMaxVal
                    tHSlider.maximumValue = heightMaxVal
            }
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
        
        if selectedUnits[3] == "" {
            vspeedUlbl.text = defUnits[3]
        }else{
            vspeedUlbl.text = selectedUnits[3]
        }
        
        if selectedUnits[4] == "" {
            initialHUlbl.text = defUnits[4]
            targetHUlbl.text = defUnits[4]
        }else{
            initialHUlbl.text = selectedUnits[4]
            targetHUlbl.text = selectedUnits[4]
        }
        
        let sValue = selValues.speed
        
        if sValue == nil || sValue == "" {
            inputSpeed.text = "0.0"
            sSlider.value = 0.0
            speedVal = 0.0
        }else{
            inputSpeed.text = sValue
            sSlider.value = Float(sValue!)!
            speedVal = Float(sValue!)!
        }
        
        let dValue = selValues.distance
        
        if dValue == nil || dValue == "" {
            inputDistance.text = "0.0"
            dSlider.value = 0.0
            distanceVal = 0.0
        }else{
            inputDistance.text = dValue
            dSlider.value = Float(dValue!)!
            distanceVal = Float(dValue!)!
        }
        
        let iHValue = selValues.initialH
        
        if iHValue == nil || iHValue == "" {
            inputInitialH.text = "0.0"
            iHSlider.value = 0.0
            initialHVal = 0.0
        }else{
            inputInitialH.text = iHValue
            iHSlider.value = Float(iHValue!)!
            initialHVal = Float(iHValue!)!
        }
        
        let tHValue = selValues.targetH
        
        if tHValue == nil || tHValue == "" {
            inputTargetH.text = "0.0"
            tHSlider.value = 0.0
            targetHVal = 0.0
        }else{
            inputTargetH.text = tHValue
            tHSlider.value = Float(tHValue!)!
            targetHVal = Float(tHValue!)!
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
            scrollV.setContentOffset(CGPoint(x: 0,y: 40), animated: true)
        }else if textField == inputInitialH {
            scrollV.setContentOffset(CGPoint(x: 0,y: 60), animated: true)
        }else if textField == inputTargetH {
            scrollV.setContentOffset(CGPoint(x: 0,y: 80), animated: true)
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
        }else if textField == inputInitialH {
            initialHVal = (iHSlider.value).roundTo(places: 2)
            selValues.initialH = String(initialHVal)
            
            if inputInitialH.text != "" {
                iHSlider.value = Float(inputInitialH.text!)!
            }else{
                iHSlider.value = 0.0
            }
        }else if textField == inputTargetH {
            targetHVal = (tHSlider.value).roundTo(places: 2)
            selValues.targetH = String(targetHVal)
            
            if inputTargetH.text != "" {
                tHSlider.value = Float(inputTargetH.text!)!
            }else{
                tHSlider.value = 0.0
            }
        }
    }
    
    //MARK: Additional functions
    func roundToTens(x : Float) -> Int {
        return 10 * Int(round(x / 10.0))
    }
    
    @objc func hideKeyboard() {
        inputSpeed.resignFirstResponder()
        inputDistance.resignFirstResponder()
        inputInitialH.resignFirstResponder()
        inputTargetH.resignFirstResponder()
        
        calculate()
    }
}
