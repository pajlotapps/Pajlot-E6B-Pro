
import UIKit

//enum Operation: String {
//    case Add = "+"
//    case Subtrack = "-"
//    case NULL = "Null"
//}

class timeCalcVC_old: UIViewController {
    
    @IBOutlet weak var outputLbl: UILabel!
    
    @IBOutlet weak var operationIndicator: OvalBtn!

    var runningNumber = ""
    var leftValue = ""
    var rightValue = ""
    var result = ""
    var resultSeconds = 0
    var currentOperation: Operation = .NULL
    
    //MARK: App lifecycle
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        outputLbl.text = "0"
    }
    
    var freshLaunch = true
    override func viewWillAppear(_ animated: Bool) {
        operationIndicator.isHidden = true

        if freshLaunch == true {
            freshLaunch = false
            self.tabBarController?.selectedIndex = 2
        }
    }
    
    @IBAction func numberPressed(_ sender: RoundedCalcBtn) {
        if runningNumber.count <= 6 {
            if runningNumber.contains(":") {
                var token = runningNumber.components(separatedBy: ":")
                if token[1].count < 2 {
                    if !runningNumber.contains(":00") {
                        runningNumber += "\(sender.tag)"
                        outputLbl.text = runningNumber
                    }
                }
            }else{
                if !runningNumber.contains(":00") {
                    runningNumber += "\(sender.tag)"
                    outputLbl.text = runningNumber
                }
            }
        }
    }
    
    @IBAction func dropLastPressed(_ sender: RoundedCalcBtn) {
        if runningNumber.count != 0 {
            let str = runningNumber
            let truncuted = str.dropLast(1)
            outputLbl.text = String(truncuted)
            runningNumber = String(truncuted)
        }
    }
    
    @IBAction func allClearPressed(_ sender: RoundedCalcBtn) {
        runningNumber = ""
        leftValue = ""
        rightValue = ""
        result = ""
        currentOperation = .NULL
        operationIndicator.isHidden = true
        outputLbl.text = "0"
    }
    
    @IBAction func clearPressed(_ sender: RoundedCalcBtn) {
        runningNumber = ""
        leftValue = String(resultSeconds)
        outputLbl.text = "0"
    }
    
    @IBAction func colonPressed(_ sender: RoundedCalcBtn) {
        if runningNumber.count <= 5 && !runningNumber.contains(":") {
            runningNumber += ":"
            outputLbl.text = runningNumber
        }
    }
    
    @IBAction func colonDoubleZero(_ sender: RoundedCalcBtn) {
        if runningNumber.count <= 5 && !runningNumber.contains(":") {
            runningNumber += ":00"
            outputLbl.text = runningNumber
        }
    }
    
    @IBAction func equalPressed(_ sender: RoundedCalcBtn) {
        operation(operation: currentOperation)
    }
    
    @IBAction func addPressed(_ sender: RoundedCalcBtn) {
        operation(operation: .Add)
        operationIndicator.isHidden = false
        operationIndicator.setTitle("+", for: UIControlState.normal)
    }
    
    @IBAction func substractPressed(_ sender: RoundedCalcBtn) {
        operation(operation: .Subtrack)
        operationIndicator.isHidden = false
        operationIndicator.setTitle("-", for: UIControlState.normal)
    }
    
    func operation(operation: Operation) {
        if currentOperation != .NULL {
            if runningNumber != "" || runningNumber != ":" {
                rightValue = convert2sec(value: runningNumber)
                runningNumber = ""
                
                if currentOperation == .Add {
                    
                    resultSeconds = Int(leftValue)! + Int(rightValue)!
                    validResult(value: resultSeconds)
                    
                }else if currentOperation == .Subtrack {
                    
                    resultSeconds = Int(leftValue)! - Int(rightValue)!
                    validResult(value: resultSeconds)
                    
                }
                leftValue = String(resultSeconds)
                outputLbl.text = result
            }else{
                rightValue = convert2sec(value: runningNumber)
                runningNumber = ""
            }
            currentOperation = operation
        }else{
            convertInput(value: runningNumber)
            leftValue = convert2sec(value: runningNumber)
            runningNumber = ""
            currentOperation = operation
        }
    }
    
    func convertInput(value: String) {
        if value.contains(":") {
            let newstr = value
            var token = newstr.components(separatedBy: ":")
            if token[1] != "" {
                let afterColon = Int(token[1])!
                if afterColon >= 60 {
                    let minutes = afterColon / 60
                    let modulo = afterColon % 60
                    
                    let seconds: String
                    if modulo < 10 {
                        seconds = "0\(modulo)"
                    }else if modulo == 0 {
                        seconds = "00"
                    }else{
                        seconds = "\(modulo)"
                    }
                    let converted = "\(Int(token[0])! + Int(minutes)):\(seconds)"
                    outputLbl.text = converted
                }
            }else{
                if token[0] == "" {
                    outputLbl.text = "0:00"
                }else{
                    outputLbl.text = "\(token[0]):00"
                }
            }
        }
    }
    
    func convert2sec(value: String) -> String {
        if value != "" {
            if value.contains(":") {
                
                if value != ":" {
                    let newstr = value
                    var token = newstr.components(separatedBy: ":")
                    if token[1] != ""  {
                        var beforeColon = 0
                        if token[0] != "" {
                            beforeColon = Int(token[0])!
                        }
                        let seconds = "\(beforeColon * 60 + Int(token[1])!)"
                        
                        return seconds
                    }else{
                        let seconds = "\(Int(token[0])! * 60)"
                        return seconds
                    }
                }else{
                    let seconds = "\(0)"
                    return seconds
                }
            }
            return value
        }else{
            let seconds = "\(0)"
            return seconds
        }
    }
    
    func validResult (value: Int) {
        if value < 0 {
            let minutes = abs(value / 60)
            let seconds = abs(value % 60)
            if seconds < 10 {
                result = "-\(minutes):0\(seconds)"
            }else if seconds == 0 {
                result = "-\(minutes):00"
            }else{
                result = "-\(minutes):\(seconds)"
            }
        }else{
            let minutes = value / 60
            let seconds = value % 60
            
            if seconds < 10 {
                result = "\(minutes):0\(seconds)"
            }else if seconds == 0 {
                result = "\(minutes):00"
            }else{
                result = "\(minutes):\(seconds)"
            }
        }
    }
}



