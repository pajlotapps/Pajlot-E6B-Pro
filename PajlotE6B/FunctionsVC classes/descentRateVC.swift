
import UIKit

class descentRateVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UITextFieldDelegate {
    
    //MARK: Properties
    let degrees = [Int](0...45)

    var angleVal: Float = 0.0
    var descentRateVal: Float = 0.0
    var degPicker: UIPickerView!

    // MARK: - Outlets
    @IBOutlet weak var scrolV: UIScrollView!
    
    // MARK: IBOutlets: Views
    @IBOutlet weak var tContainer: UIView!
    @IBOutlet weak var bContainer: UIView!

    // MARK: IBOutlets: TextFields
    @IBOutlet weak var inputAngle: UITextField!
    
    // MARK: IBOutlets: Labels
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var resultUlbl: UILabel!
    @IBOutlet weak var angleUlbl: UILabel!
    
    // MARK: IBOutlets: Sliders
    @IBOutlet weak var aSlider: UISlider!

    @IBOutlet weak var moreBtn: CustomButton!
    var hideBarButton : UIBarButtonItem!

    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = NSLocalizedString("GlidePathLabel", comment: "Glide Path Title").localiz()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        moreBtn.setTitle((NSLocalizedString("MoreInfoBtn", comment: "More Label")), for: UIControlState.normal)
        
        inputAngle.delegate = self
        //inputAngle.delegate = self
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        calculate()
    }
    
    override func viewDidLayoutSubviews() {
        tContainer.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        bContainer.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
    }
    
        
    //MARK: IBActions
    @IBAction func upgradePro(_ sender: Any) {
        usefulFunctions().jumpToUpgradeVC()
    }
    
    @IBAction func angleTFTapped(_ sender: UITextField) {
        selValues.angle = inputAngle.text
        let val: String? = selValues.angle
        
        if val == "" || val == nil {
            angleVal = 0.0
        }else{
            angleVal = Float(val!)!
        }
        hideKeyboard()
    }
    
    @IBAction func angleSlider(_ sender: UISlider) {
        angleVal = (sender.value).roundTo(places: 0)
        selValues.angle = String(angleVal)
        inputAngle.text = String(angleVal)
        hideKeyboard()
    }
    
    @IBAction func decreaseAngle(_ sender: Any) {
        if angleVal <= 45 && angleVal >= 1 {
            angleVal = angleVal.roundTo(places: 0)
            angleVal -= 1.0
            selValues.angle = String(angleVal)
            inputAngle.text = String(angleVal)
            aSlider.value = angleVal
        }
        hideKeyboard()
    }
    
    @IBAction func increaseAngle(_ sender: Any) {
        if angleVal >= 0 && angleVal < 45 {
            angleVal = angleVal.roundTo(places: 0)
            angleVal += 1.0
            selValues.angle = String(angleVal)
            inputAngle.text = String(angleVal)
            aSlider.value = angleVal
        }
        hideKeyboard()
    }
    
    //MARK: Functions
    func calculate(){
        if angleVal == 0 {
            descentRateVal = 0
            result.text = "0.0"
        }else{
            descentRateVal = (tan(angleVal.degreesToRadians)*100).roundTo(places: 1)
            result.text = "\(descentRateVal)"
        }
    }
    
    //MARK: PICKERVIEW Section: Delegates and DataSources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return degrees.count
        //return maxElements
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerView.backgroundColor = bgColor

        let myRow = row % degrees.count

        let myString = String(degrees[myRow])
        pickerLabel.text = myString
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let myRow = row % degrees.count
        let myString = String(degrees[myRow])
        return myString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int){
        let myRow = row % degrees.count
        
        let myString = String(degrees[myRow])
        inputAngle.text = myString
        
        pickerView.selectRow(row, inComponent: 0, animated:false)
    }
    
    func pickUpValue(textField: UITextField) {
        degPicker = UIPickerView(frame:CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width, height: 216)))
        degPicker.backgroundColor = bgColor
        
        degPicker.delegate = self
        degPicker.dataSource = self
        
        let aValue = selValues.angle
        //let aValue = textField.text
        var selFromSlider: Int!
        
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
        
        label.text = "Kąt ścieżki schodzenia"
        label.font = UIFont(name: "Avenir-Book", size: 12)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        textField.inputAccessoryView = toolBar
        //  ^^pickerViewToolbar config end^^
        
        if let currentValue = Int(inputAngle.text!) {
            var row : Int?
            //row = Int(textField.text!)
            row = degrees.index(of: currentValue)
            //print("row: \(row)")
            if row != nil {
                degPicker.selectRow(row!, inComponent: 0, animated: false)
            }else{
                selFromSlider = Int(aValue!)
                degPicker.selectRow(selFromSlider!, inComponent: 0, animated: false)
            }
        }
        
        textField.inputView = degPicker
        textField.tintColor = UIColor.clear
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
                
        self.pickUpValue(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.navigationItem.rightBarButtonItem = nil
    
        if inputAngle.text == "" || inputAngle == nil {
            aSlider.value = 0
            selValues.angle = "0"
        }else{
            aSlider.value = Float(inputAngle.text!)!
            selValues.angle = inputAngle.text
        }
    }
    
    //MARK: Additional functions
    @objc func doneTapped(_ sender: UIBarButtonItem) {
        calculate()
        self.view.endEditing(true)
    }
    
    @objc func hideKeyboard() {
        inputAngle.resignFirstResponder()
        
        calculate()
    }
    
}
