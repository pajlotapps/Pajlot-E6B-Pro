
import Foundation

enum TimeUnit: Int {
    case hms = 0, ms, ss
    
    static func allCases() -> [String] {
        var i = 0
        var list = [String]()
        while let unit = TimeUnit(rawValue: i) {
            list.append(unit.description())
            i = i + 1
        }
        return list
    }
    
    func description() -> String {
        switch self {
        case .hms:
            return "Godziny, minuty, sekundy"
        case .ms:
            return "Minuty, sekundy"
        case .ss:
            return "Sekundy"
        }
    }
    
    static func fromString(_ string: String) -> TimeUnit? {
        if string == "Godziny, minuty, sekundy" {
            return .hms
        } else if string == "Minuty, sekundy" {
            return .ms
        } else if string == "Sekundy" {
            return .ss
        } else {
            return nil
        }
    }
    
    func convertTo(unit to: TimeUnit, value val: Double) -> Double {
        var constant = 1.0
        var res : Double
        switch self {
        case .hms:
            if to == .ms {
                constant = 0.539956803
            } else if to == .ss {
                constant = 0.621371192
            }
            
        case .ms:
            if to == .hms {
                constant = 1.852
            } else if to == .ss {
                constant = 1.151
            }
            
        case .ss:
            if to == .hms {
                constant = 1.609
            } else if to == .ms {
                constant = 0.868976242
            }
        }
        //zaokrąglenie do 1 miejsca po przecinku
        res = round(10 * constant * val)/10
        return res
    }
}


