
import UIKit

class fuelConvVC: UIViewController, UITextFieldDelegate, UIScrollViewDelegate {
    
    //MARK: Properties
    var fuelVolVal: Float = 0.0
    var fuelWeightVal: Float = 0.0
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollV: UIScrollView!
    
    // MARK: IBOutlets: textfields
    @IBOutlet weak var inputFuelVolume: UITextField!
    
    // MARK: IBOutlets: sliders
    @IBOutlet weak var fvSlider: UISlider!
    
    // MARK: IBOutlets: labels
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var resultUlbl: UILabel!
    @IBOutlet weak var fuelTypelbl: UILabel!
    @IBOutlet weak var fuelLbl: UILabel!
    
    // MARK: IBOutlets: views
    @IBOutlet weak var tContainer: UIView!
    @IBOutlet weak var bContainer: UIView!
    
    @IBOutlet weak var moreBtn: CustomButton!
    var hideBarButton : UIBarButtonItem!
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        title = NSLocalizedString("WeightLabel", comment: "Weight vs volume Title").localiz()
        fuelLbl.text = NSLocalizedString("FuelTypeLabel", comment: "Fuel type").localiz()
    moreBtn.setTitle((NSLocalizedString("MoreInfoBtn", comment: "More Label")), for: UIControlState.normal)

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
        fuelVolVal = (fvSlider.value).roundTo(places: 2)
        selValues.useableFuel = String(fuelVolVal)
        
        fuelVolVal = (fvSlider.value).roundTo(places: 2)
        selValues.fuelflow = String(fuelVolVal)
        
        if inputFuelVolume.text != "" {
            fvSlider.value = Float(inputFuelVolume.text!)!
        }else{
            fvSlider.value = 0.0
        }
        hideKeyboard()
        
    }
    
    @IBAction func fuelVolumeTFTapped(_ sender: UITextField) {
        if inputFuelVolume.text?.count != 0 {
            if inputFuelVolume.text?.first == "." || inputFuelVolume.text?.first == "," {
                inputFuelVolume.text = ""
                return
            }
            if var val = inputFuelVolume.text {
                selValues.useableFuel = val
                val = val.replacingOccurrences(of: ",", with: ".")
                fuelVolVal = Float(val)!
                inputFuelVolume.text = val
            }
        }else{
            fuelVolVal = 0.0
        }
        hideKeyboard()
    }
    
    @IBAction func fuelVolumeSlider(_ sender: UISlider) {
        fuelVolVal = (sender.value).roundTo(places: 1)
        selValues.useableFuel = String(fuelVolVal)
        inputFuelVolume.text = String(fuelVolVal)
        hideKeyboard()
    }
    
    @IBAction func decreaseFuelVolume(_ sender: Any) {
        if fuelVolVal <= 4000 && fuelVolVal >= 1 {
            fuelVolVal = fuelVolVal.roundTo(places: 1)
            fuelVolVal -= 1.0
            selValues.useableFuel = String(fuelVolVal)
            inputFuelVolume.text = String(fuelVolVal)
            fvSlider.value = fuelVolVal
        }
        hideKeyboard()
    }
    
    @IBAction func increaseFuelVolume(_ sender: Any) {
        if fuelVolVal >= 0 && fuelVolVal <= (3999) {
            fuelVolVal = fuelVolVal.roundTo(places: 1)
            fuelVolVal += 1.0
            selValues.useableFuel = String(fuelVolVal)
            inputFuelVolume.text = String(fuelVolVal)
            fvSlider.value = fuelVolVal
        }
        hideKeyboard()
    }
    
    // MARK: - Functions
    func calculate(){
        let weightUnit = selectedUnits[9]
         
        fuelVolVal = fvSlider.value
        
        if fuelVolVal == 0 {
            
            fuelWeightVal = 0
            result.text = "000.0"
         }else{
            switch fuelType {
                case "JET A1":
                    switch weightUnit {
                        case "kg":
                            fuelWeightVal = fuelVolVal * 0.79
                        case "lb":
                            fuelWeightVal = fuelVolVal * 1.76
                        default:
                            fuelWeightVal = fuelVolVal * 0.79
                    }
                case "AVGAS":
                    switch weightUnit {
                        case "kg":
                            fuelWeightVal = fuelVolVal * 0.72
                        case "lb":
                            fuelWeightVal = fuelVolVal * 1.58
                        default:
                            fuelWeightVal = fuelVolVal * 0.72
                        }
                default:
                    switch weightUnit {
                        case "kg":
                            fuelWeightVal = fuelVolVal * 0.79
                        case "lb":
                            fuelWeightVal = fuelVolVal * 1.76
                        default:
                            fuelWeightVal = fuelVolVal * 0.79
                    }
                }
         fuelWeightVal = fuelWeightVal.roundTo(places: 1)
         result.text = "\(fuelWeightVal)"
         }
    }
    
    func updateView (){
        if selectedUnits[9] == "" {
            resultUlbl.text = defUnits[9]
        }else{
            resultUlbl.text = selectedUnits[9]
        }
        
        let FVvalue = selValues.useableFuel
        if FVvalue == nil || FVvalue == "" {
            fvSlider.value = 0
            inputFuelVolume.text = "000.0"
        }else{
            fvSlider.value = Float(FVvalue!)!
            inputFuelVolume.text = FVvalue
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
        
        if textField == inputFuelVolume {
            scrollV.setContentOffset(CGPoint(x: 0,y: 20), animated: true)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.navigationItem.rightBarButtonItem = nil
        
        scrollV.setContentOffset(CGPoint(x: 0,y: -65 ), animated: true)
        
        if textField == inputFuelVolume {
            fuelVolVal = (fvSlider.value).roundTo(places: 2)
            selValues.useableFuel = String(fuelVolVal)
            if inputFuelVolume.text != "" {
                fvSlider.value = Float(inputFuelVolume.text!)!
            }else{
                fvSlider.value = 0.0
            }
        }
    }
    
    //MARK: Additional functions
    func secondsToHMS (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc func hideKeyboard() {
        inputFuelVolume.resignFirstResponder()
        calculate()
    }
}
