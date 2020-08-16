
import UIKit

class temperatureConVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    //MARK: IBOutlets textfields declarations
    @IBOutlet weak var tf_inputUnit: UITextField!
    @IBOutlet weak var tf_outputUnit: UITextField!
    @IBOutlet weak var tf_inputVal: UITextField!
    @IBOutlet weak var outputLbl: UILabel!
    
    // content for pickerViews
    let list = TemperatureUnit.allCases()
    let shortList = ["°C", "°F", "K"]
    
    var inputUnitSet : Bool = false
    var outputUnitSet : Bool = false
    var fromUnitIdx : Int = 0
    var toUnitIdx : Int = 0
    
    // variables to gold current data
    var picker : UIPickerView!
    var activeTextField = 0
    var activeTF : UITextField!
    
    var activeLabel = 0
    var activeLbl : UILabel!
    
    var activeValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Temperatura"
        
        // delegates for text fields
        tf_outputUnit.delegate = self
        tf_inputUnit.delegate = self
        
        // hide cursore symbol
        tf_outputUnit.tintColor = UIColor.clear
        tf_inputUnit.tintColor = UIColor.clear
        
        tf_inputUnit.text = selectedUnits[10]
        tf_outputUnit.text = selectedUnits[10]
        
        self.whenTappedAround()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // number of components in picekr view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // return number of elements in picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        // get number of elements in each pickerview
        switch activeTextField {
        case 1:
            return list.count
        case 2:
            return list.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.text = list[row]
        //pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    // Zawartość listy w picker view
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // return correct content for picekr view
        switch activeTextField {
        case 1:
            return list[row]
        case 2:
            return list[row]
        default:
            return ""
        }
    }
    
    // get currect value for picker view
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // set currect active value based on picker view
        switch activeTextField {
        case 1:
            activeValue = shortList[row]
            toUnitIdx = row
            outputUnitSet = true
        case 2:
            activeValue = shortList[row]
            fromUnitIdx = row
            inputUnitSet = true
        default:
            activeValue = ""
        }
    }
    
    // start editing text field
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        // set up correct active textField (no)
        switch textField {
        case tf_outputUnit:
            activeTextField = 1
        case tf_inputUnit:
            activeTextField = 2
        default:
            activeTextField = 0
        }
        
        // set active Text Field
        activeTF = textField
        
        self.pickUpValue(textField: textField)
        
    }
    
    // show picker view
    func pickUpValue(textField: UITextField) {
        
        // create frame and size of picker view
        picker = UIPickerView(frame:CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width, height: 162)))
        
        // deletates
        picker.delegate = self
        picker.dataSource = self
        
        // if there is a value in current text field, try to find it existing list
        if let currentValue = textField.text {
            
            var row : Int?
            
            // look in correct array
            switch activeTextField {
            case 1:
                row = list.index(of: currentValue)
            case 2:
                row = list.index(of: currentValue)
            default:
                row = nil
            }
            
            // we got it, let's set select it
            if row != nil {
                picker.selectRow(row!, inComponent: 0, animated: true)
            }
        }
        
        picker.backgroundColor = bgColor
        textField.inputView = self.picker
        
        // toolBar
        //let toolBar = UIToolbar()
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        toolBar.barStyle = .blackTranslucent
        toolBar.isTranslucent = true
        //toolBar.barTintColor = UIColor.darkGray
        toolBar.tintColor = UIColor.white
        toolBar.sizeToFit()
        toolBar.backgroundColor = UIColor.black
        
        
        // buttons for toolBar
        let doneButton = UIBarButtonItem(title: "Gotowe", style: .plain, target: self, action: #selector(doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Anuluj", style: .plain, target: self, action: #selector(cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
        
    }
    
    
    @objc func convertVal (){
        
        if (tf_inputVal.text?.isEmpty)! {
            noData()
            
        }else{
            dismissKeyboard()
        }
        
        if inputUnitSet == false || outputUnitSet == false {
            selectUnits()
        }
        
        let fromUnit = TemperatureUnit.fromString(list[fromUnitIdx])!
        let toUnit = TemperatureUnit.fromString(list[toUnitIdx])!
        
        if let inputText = tf_inputVal.text {
            if !inputText.isEmpty {
                let inputNum = Double(inputText.floatValue) as NSNumber
                let outputNum = fromUnit.convertTo(unit: toUnit, value: Double(truncating: inputNum))
                outputLbl.text = String(outputNum)
            }
        }
    }
    
    func whenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(convertVal))
        view.addGestureRecognizer(tap)
    }
    
    // Akcja po wciśnięciu 'Gotowe'
    @objc func doneClick() {
        activeTF.text = activeValue
        activeTF.resignFirstResponder()
        convertVal()
        
    }
    
    // Akcja po kliknięciu w 'Anuluj'
    @objc func cancelClick() {
        activeTF.resignFirstResponder()
    }
    
}

