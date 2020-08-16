
import UIKit

class functionListTVC: UITableViewController {
    
    @IBOutlet weak var s1Top: UIView!
    @IBOutlet weak var s1Bottom: UIView!
    @IBOutlet weak var s2Top: UIView!
    @IBOutlet weak var s2Bottom: UIView!
    @IBOutlet weak var s3Top: UIView!
    @IBOutlet weak var s3Bottom: UIView!
    @IBOutlet weak var s4Top: UIView!
    @IBOutlet weak var s4Bottom: UIView!
    
    @IBOutlet weak var speedLbl: UILabel!
    @IBOutlet weak var vspeedLbl: UILabel!
    @IBOutlet weak var distancelbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var wcaLbl: UILabel!
    @IBOutlet weak var glidePathLbl: UILabel!
    @IBOutlet weak var fuelLbl: UILabel!
    @IBOutlet weak var enduranceLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var windComponentLbl: UILabel!
    @IBOutlet weak var tasLbl: UILabel!
    @IBOutlet weak var densityAltLbl: UILabel!
    
    
    @IBOutlet weak var speedULbl: UILabel!
    @IBOutlet weak var tasUlbl: UILabel!
    @IBOutlet weak var distanceULbl: UILabel!
    @IBOutlet weak var timeULbl: UILabel!
    @IBOutlet weak var vspeedULbl: UILabel!
    @IBOutlet weak var weightULbl: UILabel!
    @IBOutlet weak var fuelULbl: UILabel!
    @IBOutlet weak var densityAltUlbl: UILabel!
    
    @IBOutlet var functionList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLanguage()
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)
        
        tableView.estimatedRowHeight = 50
        updateLbls()
    }
    
    override func viewDidLayoutSubviews() {
        s1Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s1Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
        s2Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s2Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
        s3Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s3Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
        s4Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s4Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        updateSelectedUnitsArray()
        updateLbls()
        setUpLanguage()
        functionList.reloadData()
    }
        
    // wygląd nagłówka sekcji
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor=UIColor.white
        header.textLabel?.font = UIFont(name: "Avenir-Black", size: 12)!
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section{
        case 0:
            return NSLocalizedString("Section0", comment: "Section 0 HL")
        case 1:
            return NSLocalizedString("Section1", comment: "Section 1 HL")
        case 2:
            return NSLocalizedString("Section2", comment: "Section 2 HL")
        case 3:
            return NSLocalizedString("Section3", comment: "Section 3 HL")
        default:
            return NSLocalizedString("SectionDef", comment: "Deafult section title")
        }
    }
    
    func updateSelectedUnitsArray() {
        if let tryRead = prefs.object(forKey: Keys.units) as AnyObject? {
            selectedUnits = tryRead as! [String]
        }
    }
    
    func updateLbls (){
        if selectedUnits[0] == "" {
            speedULbl.text = defUnits[0]
            tasUlbl.text = defUnits[0]
        }else{
            speedULbl.text = selectedUnits[0]
            tasUlbl.text = selectedUnits[0]
        }
        
        if selectedUnits[1] == "" {
            distanceULbl.text = defUnits[1]
        }else{
            distanceULbl.text = selectedUnits[1]
        }
        
        if selectedUnits[2] == "" {
            timeULbl.text = defUnits[2]
        }else{
            timeULbl.text = selectedUnits[2]
        }
        
        if selectedUnits[3] == "" {
            vspeedULbl.text = defUnits[3]
        }else{
            vspeedULbl.text = selectedUnits[3]
        }
        
        if selectedUnits[9] == "" {
            weightULbl.text = defUnits[9]
        }else{
            weightULbl.text = selectedUnits[9]
        }
        
        if selectedUnits[13] == "" {
            fuelULbl.text = defUnits[13]
        }else{
            fuelULbl.text = selectedUnits[13]
        }
        
        if selectedUnits[4] == "" {
            densityAltUlbl.text = defUnits[4]
        }else{
            densityAltUlbl.text = selectedUnits[4]
        }
    }
    
    
    func setUpLanguage () {
        
        speedLbl.text = NSLocalizedString("SpeedLabel", comment: "Speed label")
        vspeedLbl.text = NSLocalizedString("VspeedLabel", comment: "VSpeed  label")
        distancelbl.text = NSLocalizedString("DistanceLabel", comment: "Distance  label")
        timeLbl.text = NSLocalizedString("TimeLabel", comment: "Time  label")
        wcaLbl.text = NSLocalizedString("WCALabel", comment: "WCA  label")
        glidePathLbl.text = NSLocalizedString("GlidePathLabel", comment: "GlidePath  label")
        fuelLbl.text = NSLocalizedString("FuelLabel", comment: "Fuel  label")
        enduranceLbl.text = NSLocalizedString("EnduranceLabel", comment: "Endurance label")
        weightLbl.text = NSLocalizedString("WeightLabel", comment: "Weight label")
        windComponentLbl.text = NSLocalizedString("WindComponetLabel", comment: "WindComponed label")
        tasLbl.text = NSLocalizedString("TASLabel", comment: "TAS label")
        densityAltLbl.text = NSLocalizedString("DensityAltLabel", comment: "Density Altitude label")
    }
}

