
import Foundation

enum SpeedUnit: Int {
    case KPH = 0, KT, MPH
    
    static func allCases() -> [String] {
        var i = 0
        var list = [String]()
        while let unit = SpeedUnit(rawValue: i) {
            list.append(unit.description())
            i = i + 1
        }
        return list
    }
    
    func description() -> String {
        switch self {
        case .KPH:
            return "Kilometry na godzinę"
        case .KT:
            return "Węzły (Knoty)"
        case .MPH:
            return "Mile na godzinę"
        }
    }
    
    static func fromString(_ string: String) -> SpeedUnit? {
        if string == "Kilometry na godzinę" {
            return .KPH
        } else if string == "Węzły (Knoty)" {
            return .KT
        } else if string == "Mile na godzinę" {
            return .MPH
        } else {
            return nil
        }
    }
    
    func convertTo(unit to: SpeedUnit, value val: Double) -> Double {
        var constant = 1.0
        var res : Double
        switch self {
        case .KPH:
            if to == .KT {
                constant = 0.539956803
            } else if to == .MPH {
                constant = 0.621371192
            }
            
        case .KT:
            if to == .KPH {
                constant = 1.852
            } else if to == .MPH {
                constant = 1.151
            }
            
        case .MPH:
            if to == .KPH {
                constant = 1.609
            } else if to == .KT {
                constant = 0.868976242
            }
        }
        //zaokrąglenie do 1 miejsca po przecinku
        res = round(10 * constant * val)/10
        return res
    }
}
