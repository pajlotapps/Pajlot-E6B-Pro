
import UIKit

class AirfieldWx: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    private let pickerViewData = ICAOcodesMIL
    private let pickerDataSize = 100_000
    
    var airfieldPicker: UIPickerView = UIPickerView()
    
    var hideBarButton : UIBarButtonItem!
        
    private var fetchedMETAR: METARItem!
    private var fetchedTAF: TAFItem!
    
    private var pickedAirfield: String!
    
    @IBOutlet weak var inputAirfield: UITextField!
    
    @IBOutlet weak var inputContainer: UIView!
    @IBOutlet weak var metarContainer: UIView!
    @IBOutlet weak var tafContainer: UIView!
    
    @IBOutlet weak var metarOutput: UITextViewFixed!
    @IBOutlet weak var tafOutput: UITextViewFixed!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("WxTitle", comment: "Title")

        //hide keypad btn
        let hideBtn = UIButton.init(type: .custom)
        hideBtn.setImage(UIImage.init(named: "hideKeypad.png"), for: UIControlState.normal)
        hideBtn.addTarget(self, action:#selector(hideKeyboard), for: UIControlEvents.touchUpInside)
        hideBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 20)
        hideBarButton = UIBarButtonItem.init(customView: hideBtn)
        
        inputAirfield.delegate = self
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        metarOutput.text = NSLocalizedString("METARwillBeLoad", comment: "METAR will be load")
        tafOutput.text = NSLocalizedString("TAFwillBeLoad", comment: "TAF will be load")
        inputAirfield.placeholder = NSLocalizedString("WxPlaceholder", comment: "Placeholder")
    }
    
    //MARK: PICKERVIEW Section: Delegates and DataSources
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSize
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.white
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerView.backgroundColor = bgColor
        
        let myRow = row % pickerViewData.count
        
        let myString = String(pickerViewData[myRow])
        pickerLabel.text = myString
        
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row % pickerViewData.count]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int,inComponent component: Int){
        let myRow = row % pickerViewData.count
        
        inputAirfield.text = String(ICAOcodesDescription[myRow])
        let position = pickerDataSize / 2 + myRow
        pickerView.selectRow(position, inComponent: 0, animated:false)
        
        self.title = String(ICAOcodesMIL[myRow])
        pickedAirfield = String(ICAOcodesMIL[myRow])
    }
    
    func setupPicker () {
        airfieldPicker = UIPickerView(frame:CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.frame.size.width, height: 216)))
        airfieldPicker.backgroundColor = bgColor
        
        airfieldPicker.dataSource = self
        airfieldPicker.delegate = self
    }
    
    func pickUpValue(textField: UITextField) {
        setupPicker()
        
        //  ^^pickerViewToolbar config start^^
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height / 6, width: self.view.frame.size.width, height: 30.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width / 2, y: self.view.frame.size.height - 20.0)
        toolBar.barStyle = UIBarStyle.blackTranslucent
        toolBar.tintColor = UIColor.white
        toolBar.backgroundColor = UIColor.black
        
        let doneButton = UIBarButtonItem(title: (NSLocalizedString("DoneBtn", comment: "Done Btn Label")), style: UIBarButtonItemStyle.plain, target: self, action: #selector(doneTapped))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 2, height: self.view.frame.size.height))
        label.text = NSLocalizedString("aerodromes", comment: "Available airfields:")
        label.font = UIFont(name: "Avenir-Book", size: 16)
        label.textColor = UIColor.white
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        
        let textBtn = UIBarButtonItem(customView: label)
        toolBar.setItems([flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        textField.inputAccessoryView = toolBar
        //  ^^pickerViewToolbar config end^^
        
        textField.inputView = airfieldPicker
        let curAirfield = inputAirfield.text
        var position = 0
        if let index = ICAOcodesDescription.index(of: curAirfield!) {
            position = pickerDataSize / 2 + index
        }else{
            position = pickerDataSize / 2
        }
        
        airfieldPicker.selectRow(position, inComponent: 0, animated:false)
        textField.tintColor = UIColor.clear
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let myRow = row % ICAOcodesMIL.count
        
        let str = String(ICAOcodesMIL[myRow])
        
        let attributedString = NSAttributedString(string: str, attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        
        return attributedString
    }
    
    //MARK: TEXTFIELDS interaction section
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.pickUpValue(textField: textField)
        self.navigationItem.rightBarButtonItem = hideBarButton
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: Additional functions
    @objc func doneTapped(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        if pickedAirfield != "" && pickedAirfield != nil {
            if isConnected {
                loadMETAR()
                loadTAF()
            }else{
                connectionInfo()
            }
        }
    }
    
    @objc func hideKeyboard() {
        inputAirfield.resignFirstResponder()
    }
    
    func loadMETAR () {
        self.metarOutput.text = NSLocalizedString("loadingMETAR", comment: "Loading METAR")
        
        let metarFeedParser = MetarFetch()
        
        metarFeedParser.parseFeed(airfield: pickedAirfield) { (fetchedMETAR) in
            self.fetchedMETAR = fetchedMETAR
            
            OperationQueue.main.addOperation {
                self.metarOutput.text = fetchedMETAR.description
            }
        }
    }
    
    func loadTAF() {
        self.tafOutput.text = NSLocalizedString("loadingTAF", comment: "Loading TAF")
        
        let currentName = "TAF \(pickedAirfield!)</span> "
        let airfieldUrl = "http://awiacja.imgw.pl/index.php?product=taf_mil"
        
        let request = URLRequest(url: URL(string: airfieldUrl)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            }else{
                
                let htmlContent = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                let text = String(describing: htmlContent)
                
                if let start = text.range(of: currentName),
                    let end  = text.range(of: "<span class='redfont'>TAF ", range: start.upperBound..<text.endIndex) {
                    let TAFraw = text[start.upperBound..<end.lowerBound]
                    
                    var currentDescription = String(TAFraw)
                    currentDescription = currentDescription.replacingOccurrences(of: "<br>", with: "")
                    currentDescription = currentDescription.replacingOccurrences(of: "  ", with: "")
                    
                    self.fetchedTAF = TAFItem(title: self.pickedAirfield, description: currentDescription)
                } else {
                    self.fetchedTAF = TAFItem(title: self.pickedAirfield, description: NSLocalizedString("noWxInfo", comment: "TAF unavailable"))
                }
            }
            
            OperationQueue.main.addOperation {
                self.tafOutput.text = "TAF \(self.pickedAirfield!) \(self.fetchedTAF.description)"
            }
        }
        
        task.resume()
    }
    
    func connectionInfo(){
        let resetAlert = UIAlertController(title: (NSLocalizedString("messageTitle6", comment: "Connection")), message: (NSLocalizedString("message6", comment: "Connection info")), preferredStyle: UIAlertControllerStyle.alert)
        resetAlert.addAction(UIAlertAction(title: (NSLocalizedString("messageGotIt", comment: "GotIt Btn")), style: .default, handler: nil))
        self.present(resetAlert, animated: true, completion: nil)
    }
}
