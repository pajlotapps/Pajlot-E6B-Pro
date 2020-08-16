
import UIKit

class SettingsTVC: UITableViewController {

    @IBOutlet var settingsList: UITableView!

    //MARK: IBOutlets UIView top-bottom rounded declarations
    @IBOutlet weak var s1Top: UIView!
    @IBOutlet weak var s1Bottom: UIView!
    @IBOutlet weak var s2Top: UIView!
    @IBOutlet weak var s2Bottom: UIView!
    @IBOutlet weak var s3Top: UIView!
    @IBOutlet weak var s3Bottom: UIView!
    
    //MARK: IBOutlets unit labels declarations
    @IBOutlet weak var speedULbl: UILabel!
    @IBOutlet weak var distanceULbl: UILabel!
    @IBOutlet weak var pressULbl: UILabel!
    @IBOutlet weak var tempULbl: UILabel!
    @IBOutlet weak var elevULbl: UILabel!
    @IBOutlet weak var windULbl: UILabel!
    @IBOutlet weak var fuelULbl: UILabel!
    
    //MARK: IBOutlets values text fields declarations
    @IBOutlet var valuesTFColl: [UITextField]!
    @IBOutlet weak var speedTF: UITextField!
    @IBOutlet weak var distanceTF: UITextField!
    @IBOutlet weak var pressTF: UITextField!
    @IBOutlet weak var tempTF: UITextField!
    @IBOutlet weak var elevTF: UITextField!
    @IBOutlet weak var windTF: UITextField!
    @IBOutlet weak var windDirTF: UITextField!
    @IBOutlet weak var fuelFlowTF: UITextField!
    @IBOutlet weak var magDecTF: UITextField!
    @IBOutlet weak var fuelTypeSegControl: UISegmentedControl!
    @IBOutlet weak var varDirSegControl: UISegmentedControl!
    
    //MARK: IBOutlets functions labels declarations
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var elevationLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var windDirection: UILabel!
    @IBOutlet weak var fuelFlowRateLbl: UILabel!
    @IBOutlet weak var fuelTyleLbl: UILabel!
   
    
    //MARK: App Lifecycle
    override func viewDidLoad() {
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        self.hideKeyboardWhenTappedAround()
        
        title = NSLocalizedString("SettingsHL", comment: "Settings Headline").localiz()
        
        //rightBarButtonItem
        let restoreBtn = UIButton.init(type: .custom)
        restoreBtn.setImage(UIImage.init(named: "restoreIcon.png"), for: UIControlState.normal)
        restoreBtn.addTarget(self, action: #selector(resetVal), for: UIControlEvents.touchUpInside)
        restoreBtn.frame = CGRect.init(x: 0, y: 0, width: 20, height: 20)
        let restoreBarButton = UIBarButtonItem.init(customView: restoreBtn)
        self.navigationItem.rightBarButtonItem = restoreBarButton
    
    }
 
    override func viewDidAppear(_ animated: Bool) {
        loadSetValues()
        loadDefUnits()
        setUpLanguage()
        settingsList.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        loadSetValues()
        loadDefUnits()
    }
    
    override func viewDidLayoutSubviews() {
        s1Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s1Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
        s2Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s2Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
        s3Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s3Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
    }
   
    //MARK: tableView cystomize
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor=UIColor.white
        header.textLabel?.font = UIFont(name: "Avenir-Black", size: 12)!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return NSLocalizedString("SettingsTVSection0", comment: "Settings TV Section 0 HL").localiz()
        case 1:
            return NSLocalizedString("SettingsTVSection1", comment: "Settings TV Section 1 HL").localiz()
        case 2:
            return NSLocalizedString("SettingsTVSection2", comment: "Settings TV Section 2 HL").localiz()
        default:
            return NSLocalizedString("SettingsTVSectionDef", comment: "Settings TV Deafult section title").localiz()
        }
    }
    
    //MARK: IBActions values text fields declarations
    @IBAction func getSpeedVal(_ sender: Any) {
        if let speedValue = speedTF.text {
            prefs.set(speedValue, forKey: Keys.speedV)
            prefs.synchronize()
        }
    }
    
    @IBAction func getDistanceVal(_ sender: Any) {
        if let distanceValue = distanceTF.text {
            prefs.set(distanceValue, forKey: Keys.distanceV)
            prefs.synchronize()
        }
    }
    @IBAction func getPressVal(_ sender: Any) {
        if let pressValue = pressTF.text {
            prefs.set(pressValue, forKey: Keys.pressV)
            prefs.synchronize()
        }
    }
    @IBAction func getTempVal(_ sender: Any) {
        if let tempValue = tempTF.text {
            prefs.set(tempValue, forKey: Keys.tempV)
            prefs.synchronize()
        }
    }
    @IBAction func getElevVal(_ sender: Any) {
        if let elevValue = elevTF.text {
            prefs.set(elevValue, forKey: Keys.elevV)
            prefs.synchronize()
        }
    }
    @IBAction func getWindSpeedVal(_ sender: Any) {
        if let windValue = windTF.text {
            prefs.set(windValue, forKey: Keys.windV)
            prefs.synchronize()
        }
    }
    @IBAction func getWindDirVal(_ sender: Any) {
        if let windDirValue = windDirTF.text {
            prefs.set(windDirValue, forKey: Keys.windDirV)
            prefs.synchronize()
        }
    }
    @IBAction func getFuelFlowVal(_ sender: Any) {
        if let fuelFlowValue = fuelFlowTF.text {
            prefs.set(fuelFlowValue, forKey: Keys.fuelV)
            prefs.synchronize()
        }
    }
    @IBAction func fuelTypeS(_ sender: Any) {
        let val = fuelTypeSegControl.selectedSegmentIndex
        if val == 0 {
            fuelType = "JET A1"
        }else{
            fuelType = "AVGAS"
        }
        prefs.set(fuelType, forKey: Keys.fuelTypeV)
    }
    
    @IBAction func getMagDecVal(_ sender: Any) {
        if let magDecValue = magDecTF.text {
            prefs.set(magDecValue, forKey: Keys.magDecV)
            prefs.synchronize()
        }
    }
    @IBAction func varDirS(_ sender: Any) {
        let val = varDirSegControl.selectedSegmentIndex
        if val == 0 {
            varDir = "E"
        }else{
            varDir = "W"
        }
        prefs.set(varDir, forKey: Keys.varDirV)
    }

    @IBAction func magDecInfo(_ sender: Any) {
        varInfo()
    }
    
    @IBAction func fuelTypeInfo(_ sender: Any) {
        fuelInfo()
    }
    
    //MARK: Functions
    func loadSetValues() {
        var i = 0
        for tf in self.valuesTFColl {
            let Key = "default" + defaultsArray[i] + "Value"
            let keyVal = prefs.float(forKey: Key)
            
            if keyVal != 0 {
                tf.text = String(keyVal)
                setValues[i] = Float(keyVal)
            }else{
                tf.text = String(defValues[i])
                setValues[i] = defValues[i]
            }
            i += 1
        }
        let magDec = prefs.float(forKey: Keys.magDecV)
        if magDec != 0 {
            magDecTF.text = String(magDec)
            setValues[8] = Float(magDec)
        }else{
            magDecTF.text = String(defValues[8])
            setValues[8] = defValues[8]
        }
    }
    
    func backToDef() {
        setValues = defValues
        prefs.set(setValues, forKey: Keys.defValues)
        var i = 0
        for tf in self.valuesTFColl {
            let Key = "default" + defaultsArray[i] + "Value"
            prefs.set(0, forKey: Key)
            tf.text = String(defValues[i])
            i += 1
        }
        
        varDir = "E"
        prefs.set(varDir, forKey: Keys.varDirV)
        varDirSegControl.selectedSegmentIndex = 0
        
        fuelType = "JET A1"
        prefs.set(fuelType, forKey: Keys.fuelTypeV)
        fuelTypeSegControl.selectedSegmentIndex = 0
    }
    
    func setUpLanguage () {
        speedLbl.text = NSLocalizedString("SpeedLabel", comment: "Speed label")
        distanceLbl.text = NSLocalizedString("DistanceLabel", comment: "Distance  label")
        pressureLbl.text = NSLocalizedString("PressureLabel", comment: "Pressure  label")
        tempLbl.text = NSLocalizedString("TempLabel", comment: "temperature  label")
        elevationLbl.text = NSLocalizedString("ElevationLabel", comment: "Elevation  label")
        windSpeedLbl.text = NSLocalizedString("windSpeedLabel", comment: "windSpeedLbl label")
        windDirection.text = NSLocalizedString("windDirectionLabel", comment: "windDirection label")
        fuelFlowRateLbl.text = NSLocalizedString("fuelFlowRateLabel", comment: "fuelFlowRate label")
        fuelTyleLbl.text = NSLocalizedString("FuelTypeLabel", comment: "Fuel type  label")
    }
    
    func loadDefUnits() {
        
        if selectedUnits[0] == "" {
            speedULbl.text = defUnits[0]
        }else{
            speedULbl.text = selectedUnits[0]
        }
        
        if selectedUnits[1] == "" {
            distanceULbl.text = defUnits[1]
        }else{
            distanceULbl.text = selectedUnits[1]
        }

        if selectedUnits[11] == "" {
            pressULbl.text = defUnits[11]
        }else{
            pressULbl.text = selectedUnits[11]
        }
        
        if selectedUnits[10] == "" {
            tempULbl.text = defUnits[10]
        }else{
            tempULbl.text = selectedUnits[10]
        }
        
        if selectedUnits[7] == "" {
            elevULbl.text = defUnits[7]
        }else{
            elevULbl.text = selectedUnits[7]
        }
        
        if selectedUnits[5] == "" {
            windULbl.text = defUnits[5]
        }else{
            windULbl.text = selectedUnits[5]
        }
        
        if selectedUnits[6] == "" {
            fuelULbl.text = defUnits[6]
        }else{
            fuelULbl.text = selectedUnits[6]
        }
        
        let keyVarVal = prefs.string(forKey: Keys.varDirV)
        if (keyVarVal != nil){
            switch (keyVarVal)!{
            case "E":
                varDir = "E"
                varDirSegControl.selectedSegmentIndex = 0
            case "W":
                varDir = "W"
                varDirSegControl.selectedSegmentIndex = 1
            default:
                break
            }
        }else{
            varDirSegControl.selectedSegmentIndex = 0
        }
        
        let keyFuelVal = prefs.string(forKey: Keys.fuelTypeV)
        if (keyFuelVal != nil){
            switch (keyFuelVal)!{
            case "JET A1":
                fuelType = "JET A1"
                fuelTypeSegControl.selectedSegmentIndex = 0
            case "AVGAS":
                fuelType = "AVGAS"
                fuelTypeSegControl.selectedSegmentIndex = 1
            default:
                break
            }
        }else{
            fuelTypeSegControl.selectedSegmentIndex = 0
        }
    }
    
    //MARK: Alerts
    @objc func resetVal(){
        var resetAlert : UIAlertController
        if setValues == defValues && varDir == defVarDir {
            resetAlert = UIAlertController(title: nil, message: (NSLocalizedString("message1", comment: "Loaded values")), preferredStyle: UIAlertControllerStyle.alert)
            resetAlert.addAction(UIAlertAction(title: (NSLocalizedString("messageGotIt", comment: "GotIt Btn")), style: .default, handler: nil))
        }else{
            resetAlert = UIAlertController(title: (NSLocalizedString("messageTitle1", comment: "Confirmation Title")), message: (NSLocalizedString("message2", comment: "Confirmation message")), preferredStyle: UIAlertControllerStyle.alert)
            resetAlert.addAction(UIAlertAction(title: (NSLocalizedString("messageReset", comment: "Reset Btn")), style: UIAlertActionStyle.destructive, handler: { action in self.backToDef() }))
            resetAlert.addAction(UIAlertAction(title: (NSLocalizedString("messageCancel", comment: "Cancel Btn")), style: .default, handler: nil))
        }
        self.present(resetAlert, animated: true, completion: nil)
    }
    
    func varInfo(){
        let resetAlert = UIAlertController(title: (NSLocalizedString("messageTitle2", comment: "Magnetic dev")), message: (NSLocalizedString("message3", comment: "Magnetic Dev info")), preferredStyle: UIAlertControllerStyle.alert)
        resetAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(resetAlert, animated: true, completion: nil)
    }

    func fuelInfo(){
        let resetAlert = UIAlertController(title: (NSLocalizedString("messageTitle3", comment: "Fuel")), message: (NSLocalizedString("message4", comment: "Magnetic Dev info")), preferredStyle: UIAlertControllerStyle.alert)
        resetAlert.addAction(UIAlertAction(title: (NSLocalizedString("messageGotIt", comment: "GotIt Btn")), style: .default, handler: nil))
        self.present(resetAlert, animated: true, completion: nil)
    }

}

