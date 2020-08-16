
import Foundation

enum VSpeedUnit: Int {
    case mps = 0, ftpmin
    
    static func allCases() -> [String] {
        var i = 0
        var list = [String]()
        while let unit = VSpeedUnit(rawValue: i) {
            list.append(unit.description())
            i = i + 1
        }
        return list
    }
    
    func description() -> String {
        switch self {
        case .mps:
            return "Metry na sekundę"
        case .ftpmin:
            return "Stopy na minutę"
        }
    }
    
    static func fromString(_ string: String) -> VSpeedUnit? {
        if string == "Metry na sekundę" {
            return .mps
        } else if string == "Stopy na minutę" {
            return .ftpmin
        } else {
            return nil
        }
    }
    
    func convertTo(unit to: VSpeedUnit, value val: Double) -> Double {
        var constant = 1.0
        var res : Double
        switch self {
        case .mps:
            if to == .ftpmin {
                constant = 196.85
            }
            
        case .ftpmin:
            if to == .mps {
                constant = 0.00508
            }
        }
        //zaokrąglenie do 1 miejsca po przecinku
        res = round(10 * constant * val)/10
        return res
    }
}


