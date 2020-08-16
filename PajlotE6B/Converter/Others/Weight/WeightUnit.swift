
import Foundation

enum WeightUnit: Int {
    case kg = 0, lb
    
    static func allCases() -> [String] {
        var i = 0
        var list = [String]()
        while let unit = WeightUnit(rawValue: i) {
            list.append(unit.description())
            i = i + 1
        }
        return list
    }
    
    func description() -> String {
        switch self {
        case .kg:
            return "Kilogram (kg)"
        case .lb:
            return "Funt (Pound - lb)"
        }
    }
    
    static func fromString(_ string: String) -> WeightUnit? {
        if string == "Kilogram (kg)" {
            return .kg
        } else if string == "Funt (Pound - lb)" {
            return .lb
        } else {
            return nil
        }
    }
    
    func convertTo(unit to: WeightUnit, value val: Double) -> Double {
        var constant = 1.0
        
        var res : Double
        switch self {
        case .kg:
            if to == .lb {
                constant = 2.2046
            }
            
        case .lb:
            if to == .kg {
                constant = 1/2.204623
            }
        }
        //zaokrąglenie do 1 miejsca po przecinku
        res = round(10 * val * constant)/10
        return res
    }
}


