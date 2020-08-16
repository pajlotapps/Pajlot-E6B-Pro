
import Foundation

enum DistanceUnit: Int {
    case km = 0, nMile, sMile
    
    static func allCases() -> [String] {
        var i = 0
        var list = [String]()
        while let unit = DistanceUnit(rawValue: i) {
            list.append(unit.description())
            i = i + 1
        }
        return list
    }
    
    func description() -> String {
        switch self {
        case .km:
            return "Kilometr"
        case .nMile:
            return "Mila morska"
        case .sMile:
            return "Mila lądowa"
        }
    }
    
    static func fromString(_ string: String) -> DistanceUnit? {
        if string == "Kilometr" {
            return .km
        } else if string == "Mila morska" {
            return .nMile
        } else if string == "Mila lądowa" {
            return .sMile
        } else {
            return nil
        }
    }
    
    func convertTo(unit to: DistanceUnit, value val: Double) -> Double {
        var constant = 1.0
        var res : Double
        switch self {
        case .km:
            if to == .nMile {
                constant = 0.539956803
            } else if to == .sMile {
                constant = 0.621371192
            }
            
        case .nMile:
            if to == .km {
                constant = 1.85200
            } else if to == .sMile {
                constant = 1.15077945
            }
            
        case .sMile:
            if to == .km {
                constant = 1.609344
            } else if to == .nMile {
                constant = 0.868976242
            }
        }
        //zaokrąglenie do 1 miejsca po przecinku
        res = round(10 * constant * val)/10
        return res
    }
}


