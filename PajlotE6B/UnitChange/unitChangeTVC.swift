
import UIKit

class unitChangeTVC: UITableViewController {
   
    //MARK: IBOutlets UIView top-bottom rounded declarations
    @IBOutlet weak var s1Top: UIView!
    @IBOutlet weak var s1Bottom: UIView!
    @IBOutlet weak var s2Top: UIView!
    @IBOutlet weak var s2Bottom: UIView!
    @IBOutlet weak var s3Top: UIView!
    @IBOutlet weak var s3Bottom: UIView!
    
    @IBOutlet var unitSegControl: [UISegmentedControl]!
    
    //MARK: deklaracje IBOutlets
    //Podstawowe
    @IBOutlet weak var speedSelector: UISegmentedControl!
    @IBOutlet weak var distanceSelector: UISegmentedControl!
    @IBOutlet weak var timeSelector: UISegmentedControl!
    @IBOutlet weak var vspeedSelector: UISegmentedControl!
    @IBOutlet weak var heightSelector: UISegmentedControl!
    //Inne
    @IBOutlet weak var windSelector: UISegmentedControl!
    @IBOutlet weak var fuelFlowSelector: UISegmentedControl!
    @IBOutlet weak var elevSelector: UISegmentedControl!
    //Dodatkowe
    @IBOutlet weak var volumeSelector: UISegmentedControl!
    @IBOutlet weak var weightSelector: UISegmentedControl!
    @IBOutlet weak var tempSelector: UISegmentedControl!
    @IBOutlet weak var pressureSelector: UISegmentedControl!
    @IBOutlet weak var angleSelector: UISegmentedControl!
    @IBOutlet weak var fuelSelector: UISegmentedControl!
    
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var vspeedLbl: UILabel!
    @IBOutlet weak var altitudeLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var fuelFlowLbl: UILabel!
    @IBOutlet weak var elevationLbl: UILabel!
    @IBOutlet weak var volumeLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var angleLbl: UILabel!
    @IBOutlet weak var fuelLbl: UILabel!
    
    //MARK: App life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        title = NSLocalizedString("UnitsHL", comment: "Units Headline").localiz()

        //clear btn
        let clearBtn = UIButton.init(type: .custom)
        clearBtn.setImage(UIImage.init(named: "restoreIcon.png"), for: UIControlState.normal)
        clearBtn.addTarget(self, action:#selector(restoreDefaults), for: UIControlEvents.touchUpInside)
        clearBtn.frame = CGRect.init(x: 0, y: 0, width: 40, height: 20)
        let clearBarButton = UIBarButtonItem.init(customView: clearBtn)
        self.navigationItem.rightBarButtonItem = clearBarButton

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        setUpLanguage()
        updateView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateView()
    }
    
    override func viewDidLayoutSubviews() {
        s1Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s1Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
        s2Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s2Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
        s3Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s3Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
    }
    
    //MARK: deklaracje IBActions
    //Jednostki podstawowe
    @IBAction func speedS(_ sender: AnyObject) {
        let fromUnit = selectedUnits[0]
        let val = speedSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.speed)
        updateTable(selectedSegmentIndex: val, position: 0)
        prefs.set(selectedUnits, forKey: Keys.units)
        var value = Float(prefs.integer(forKey: Keys.speedV))
        let toUnit = selectedUnits[0]
        
        switch fromUnit {
            case "KPH":
                switch toUnit {
                    case "KT":
                        value = (value * 0.539956803).roundTo(places: 0)
                    case "MPH":
                        value = (value * 0.621371192).roundTo(places: 0)
                    default:
                        break
            }
            case "KT":
                switch toUnit {
                    case "KPH":
                        value = (value * 1.85200).roundTo(places: 0)
                    case "MPH":
                        value = (value * 1.15077945).roundTo(places: 0)
                    default:
                        break
            }
            case "MPH":
                switch toUnit {
                    case "KPH":
                        value = (value * 1.609344).roundTo(places: 0)
                    case "KT":
                        value = (value * 0.868976242).roundTo(places: 0)
                    default:
                        break
            }
            default:
                break
        }
        prefs.set(value, forKey: Keys.speedV)
    }
    
    @IBAction func distanceS(_ sender: AnyObject) {
        let fromUnit = selectedUnits[1]
        let val = distanceSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.distance)
        updateTable(selectedSegmentIndex: val, position: 1)
        prefs.set(selectedUnits, forKey: Keys.units)
        var value = Float(prefs.integer(forKey: Keys.distanceV))
        let toUnit = selectedUnits[1]
        
        switch fromUnit {
        case "km":
            switch toUnit {
            case "NM":
                value = (value * 0.539956803).roundTo(places: 0)
            case "SM":
                value = (value * 0.621371192).roundTo(places: 0)
            default:
                break
            }
        case "NM":
            switch toUnit {
            case "km":
                value = (value * 1.85200).roundTo(places: 0)
            case "SM":
                value = (value * 1.15077945).roundTo(places: 0)
            default:
                break
            }
        case "SM":
            switch toUnit {
            case "km":
                value = (value * 1.609344).roundTo(places: 0)
            case "NM":
                value = (value * 0.868976242).roundTo(places: 0)
            default:
                break
            }
        default:
            break
        }
        prefs.set(value, forKey: Keys.distanceV)
    }
    
    @IBAction func timeS(_ sender: AnyObject) {
        let val = timeSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.time)
        updateTable(selectedSegmentIndex: val, position: 2)
        prefs.set(selectedUnits, forKey: Keys.units)
    }
    
    @IBAction func vspeedS(_ sender: AnyObject) {
        let val = vspeedSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.vspeed)
        updateTable(selectedSegmentIndex: val, position: 3)
        prefs.set(selectedUnits, forKey: Keys.units)
    }
    
    @IBAction func heightS(_ sender: AnyObject) {
        let val = heightSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.height)
        updateTable(selectedSegmentIndex: val, position: 4)
        prefs.set(selectedUnits, forKey: Keys.units)
    }
    
    //Jednostki inne
    @IBAction func windS(_ sender: AnyObject){
        let fromUnit = selectedUnits[5]
        let val = windSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.wind)
        updateTable(selectedSegmentIndex: val, position: 5)
        prefs.set(selectedUnits, forKey: Keys.units)
        var value = prefs.float(forKey: Keys.windV)
        let toUnit = selectedUnits[5]
        
        switch fromUnit {
            case "m/s":
                switch toUnit {
                    case "KT":
                        value = (value * 1.94384449).roundTo(places: 1)
                case "KPH":
                    value = (value * 3.6).roundTo(places: 1)
                default:
                    break
                }
            case "KT":
                switch toUnit {
                    case "m/s":
                        value = (value * 0.514444444).roundTo(places: 1)
                    case "KPH":
                        value = (value * 1.85200).roundTo(places: 1)
                    default:
                        break
                }
            case "KPH":
                switch toUnit {
                    case "m/s":
                        value = (value * 0.277777778).roundTo(places: 1)
                    case "KT":
                        value = (value * 0.539956803).roundTo(places: 1)
                    default:
                        break
                }
            default:
                break
            }
        prefs.set(value, forKey: Keys.windV)
    }
    
    @IBAction func fuelFlowS(_ sender: AnyObject) {
        let fromUnit = selectedUnits[6]
        let val = fuelFlowSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.fuel)
        updateTable(selectedSegmentIndex: val, position: 6)
        prefs.set(selectedUnits, forKey: Keys.units)
        var value = prefs.float(forKey: Keys.fuelV)
        let toUnit = selectedUnits[6]
        
        let keyFuelVal = prefs.string(forKey: Keys.fuelTypeV)
        if (keyFuelVal != nil){
            switch (keyFuelVal)!{
                case "JET A1":
                    switch fromUnit {
                        case "l/h":
                            switch toUnit {
                                case "kg/h":
                                    value = (value * 0.79).roundTo(places: 1)
                                case "lbs/h":
                                    value = (value * 0.79 * 0.4535924).roundTo(places: 1)
                                default:
                                    break
                            }
                        case "kg/h":
                            switch toUnit {
                                case "l/h":
                                    value = (value / 0.79).roundTo(places: 1)
                                case "lbs/h":
                                    value = (value * 0.4535924).roundTo(places: 1)
                                default:
                                break
                            }
                        case "lbs/h":
                            switch toUnit {
                                case "l/h":
                                    value = (value / 0.4535924 / 0.79).roundTo(places: 1)
                                case "kg/h":
                                    value = (value / 0.4535924).roundTo(places: 1)
                                default:
                                break
                            }
                        default:
                            break
                    }
                case "AVGAS":
                    switch fromUnit {
                        case "l/h":
                            switch toUnit {
                                case "kg/h":
                                    value = (value * 0.72).roundTo(places: 1)
                            case "lbs/h":
                                value = (value * 0.72 * 0.4535924).roundTo(places: 1)
                            default:
                                break
                            }
                        case "kg/h":
                            switch toUnit {
                                case "l/h":
                                    value = (value / 0.72).roundTo(places: 1)
                                case "lbs/h":
                                    value = (value * 0.4535924).roundTo(places: 1)
                                default:
                                    break
                            }
                        case "lbs/h":
                            switch toUnit {
                                case "l/h":
                                    value = (value / 0.4535924 / 0.72).roundTo(places: 1)
                                case "kg/h":
                                    value = (value / 0.4535924).roundTo(places: 1)
                                default:
                                    break
                            }
                        default:
                            break
                    }
                default:
                    break
            }
        }
        prefs.set(value, forKey: Keys.fuelV)
    }
    
    @IBAction func elevS(_ sender: AnyObject) {
        let fromUnit = selectedUnits[7]
        let val = elevSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.elev)
        updateTable(selectedSegmentIndex: val, position: 7)
        prefs.set(selectedUnits, forKey: Keys.units)
        var value = prefs.float(forKey: Keys.elevV)
        let toUnit = selectedUnits[7]
        
        switch fromUnit {
            case "m":
                switch toUnit {
                    case "ft":
                        value = (value * 3.2808399).roundTo(places: 2)
                default:
                    break
                }
            case "ft":
                switch toUnit {
                    case "m":
                        value = (value * 0.3048).roundTo(places: 2)
                default:
                    break
                }
            default:
                break
        }
        prefs.set(value, forKey: Keys.elevV)
    }
    
    //Jednostki dodatkowe
    @IBAction func volumeS(_ sender: AnyObject) {
        let val = volumeSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.vol)
        updateTable(selectedSegmentIndex: val, position: 8)
        prefs.set(selectedUnits, forKey: Keys.units)
    }
    
    @IBAction func weightS(_ sender: AnyObject) {
        let val = weightSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.weight)
        updateTable(selectedSegmentIndex: val, position: 9)
        prefs.set(selectedUnits, forKey: Keys.units)
    }
    
    @IBAction func tempS(_ sender: AnyObject) {
        let fromUnit = selectedUnits[10]
        let val = tempSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.temp)
        updateTable(selectedSegmentIndex: val, position: 10)
        prefs.set(selectedUnits, forKey: Keys.units)
        var value = prefs.float(forKey: Keys.tempV)
        let toUnit = selectedUnits[10]
        
        switch fromUnit {
            case "°C":
                switch toUnit {
                    case "°F":
                        value = (value * 1.8 + 32).roundTo(places: 0)
                    case "K":
                        value = (value + 273.15).roundTo(places: 0)
                    default:
                        break
                }
            case "°F":
                switch toUnit {
                    case "°C":
                        value = ((value - 32) / 1.8).roundTo(places: 0)
                    case "K":
                        value = ((value + 459.67) * 5 / 9).roundTo(places: 0)
                    default:
                        break
                }
            case "K":
                switch toUnit {
                    case "°C":
                        value = (value - 273.15).roundTo(places: 0)
                    case "°F":
                        value = (value * 9 / 5 + 459.67).roundTo(places: 0)
                    default:
                        break
                }
            default:
                break
            }
        prefs.set(value, forKey: Keys.tempV)
    }
    
    @IBAction func pressureS(_ sender: AnyObject) {
        let fromUnit = selectedUnits[11]
        let val = pressureSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.press)
        updateTable(selectedSegmentIndex: val, position: 11)
        prefs.set(selectedUnits, forKey: Keys.units)
        var value = prefs.float(forKey: Keys.pressV)
        let toUnit = selectedUnits[11]

        print("\(value)")

        switch fromUnit {
            case "hPa":
                switch toUnit {
                case "mmHg":
                    value = (value * 3/4).roundTo(places: 2)
                case "inHg":
                    value = (value * 0.029529983071445).roundTo(places: 2)
                default:
                    break
                }
            case "mmHg":
                switch toUnit {
                case "hPa":
                    value = (value * 4/3).roundTo(places: 2)
                case "inHg":
                    value = (value / 25.4).roundTo(places: 2)
                default:
                    break
                }
            case "inHg":
                switch toUnit {
                case "hPa":
                    value = (value * 33.86388666666671).roundTo(places: 2)
                case "mmHg":
                    value = (value * 25.4).roundTo(places: 2)
                default:
                    break
                }
            default:
                break
        }
        prefs.set(value, forKey: Keys.pressV)
        print("\(fromUnit) na \(toUnit): \(value)")
    }
    
    @IBAction func angleS(_ sender: AnyObject) {
        let val = angleSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.angle)
        updateTable(selectedSegmentIndex: val, position: 12)
        prefs.set(selectedUnits, forKey: Keys.units)
    }
    
    @IBAction func fuelS(_ sender: AnyObject) {
        let val = fuelSelector.selectedSegmentIndex
        prefs.set(val, forKey: Keys.useableFuel)
        updateTable(selectedSegmentIndex: val, position: 13)
        prefs.set(selectedUnits, forKey: Keys.units)
    }

    // MARK: funkcja podświetlająca aktualnie wybraną jednostkę
    func updateView() {

        speedSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.speed)
        distanceSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.distance)
        timeSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.time)
        vspeedSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.vspeed)
        heightSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.height)
        windSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.wind)
        fuelFlowSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.fuel)
        elevSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.elev)
        volumeSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.vol)
        weightSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.weight)
        tempSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.temp)
        pressureSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.press)
        angleSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.angle)
        fuelSelector.selectedSegmentIndex = prefs.integer(forKey: Keys.useableFuel)
        
    }
    
    func updateTable(selectedSegmentIndex: Int, position: Int ) {
            switch (selectedSegmentIndex){
            case 0:
                selectedUnits[position] = availableUnits[position][0]
            case 1:
                selectedUnits[position] = availableUnits[position][1]
            case 2:
                selectedUnits[position] = availableUnits[position][2]
            default:
                break
            }
    }
    
    func backToDef() {
        selectedUnits = defUnits
        prefs.set(selectedUnits, forKey: Keys.units)

        var i = 0
        for segControl in self.unitSegControl {

            let Key = "selected" + unitsArray[i] + "Unit"
            prefs.set(0, forKey: Key)
            segControl.selectedSegmentIndex = 0
            i += 1
        }
    }
    
    @objc func restoreDefaults() {
        //alert potwierdzajacy chec resetu ustawień
        let resetAlert = UIAlertController(title: (NSLocalizedString("messageTitle1", comment: "Confirmation header")), message: (NSLocalizedString("message5", comment: "Reset units to defaults")), preferredStyle: UIAlertControllerStyle.alert)
        
        resetAlert.addAction(UIAlertAction(title: (NSLocalizedString("messageReset", comment: "Reset")), style: UIAlertActionStyle.destructive, handler: { action in
            self.backToDef()
        }))
        resetAlert.addAction(UIAlertAction(title: (NSLocalizedString("messageCancel", comment: "Cancel")), style: UIAlertActionStyle.default, handler: nil))
        
        self.present(resetAlert, animated: true, completion: nil)
    }
    
    // MARK: Funkcje pomocnicze
    func popToRoot(sender:UIBarButtonItem){
        self.navigationController!.popToRootViewController(animated: true)
    }
    
    func dissmissUnitChangeVC () {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor=UIColor.white
        header.textLabel?.font = UIFont(name: "Avenir-Black", size: 12)!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section{
        case 0:
            return NSLocalizedString("UnitsSection0", comment: "Units TV Section 0 HL").localiz()
        case 1:
            return NSLocalizedString("UnitsSection1", comment: "Units TV Section 1 HL").localiz()
        case 2:
            return NSLocalizedString("UnitsSection2", comment: "Units TV Section 2 HL").localiz()
        default:
            return NSLocalizedString("UnitsSectionDef", comment: "Units TV Deafult section title").localiz()
        }
    }
    
    func setUpLanguage() {
        speedLbl.text = NSLocalizedString("SpeedLabel", comment: "Speed label")
        distanceLbl.text = NSLocalizedString("DistanceLabel", comment: "Distance  label")
        timeLbl.text = NSLocalizedString("TimeLabel", comment: "Time  label")
        vspeedLbl.text = NSLocalizedString("VspeedLabel", comment: "VSpeed  label")
        altitudeLbl.text = NSLocalizedString("AltitideLabel", comment: "Altitude  label")
        windSpeedLbl.text = NSLocalizedString("windSpeedLabel", comment: "WindSpeed  label")
        fuelFlowLbl.text = NSLocalizedString("fuelFlowRateLabel", comment: "FuelFlow  label")
        elevationLbl.text = NSLocalizedString("ElevationLabel", comment: "Elevation  label")
        volumeLbl.text = NSLocalizedString("VolumeLabel", comment: "Volume  label")
        weightLbl.text = NSLocalizedString("UnitsWeightLabel", comment: "Weight  label")
        temperatureLbl.text = NSLocalizedString("TempLabel", comment: "Temperature  label")
        pressureLbl.text = NSLocalizedString("PressureLabel", comment: "Pressure  label")
        angleLbl.text = NSLocalizedString("AngleLabel", comment: "Angle  label")
        fuelLbl.text = NSLocalizedString("FuelAmountLabel", comment: "Fuel label")
    }
}
