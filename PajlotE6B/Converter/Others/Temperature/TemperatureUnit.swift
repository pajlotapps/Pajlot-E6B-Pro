
import Foundation

enum TemperatureUnit: Int {
    case C = 0, F, K
    
    static func allCases() -> [String] {
        var i = 0
        var list = [String]()
        while let unit = TemperatureUnit(rawValue: i) {
            list.append(unit.description())
            i = i + 1
        }
        return list
    }
    
    func description() -> String {
        switch self {
        case .C:
            return "Stopnie Celsjusza (°C)"
        case .F:
            return "Stopnie Farenheit'a (°F)"
        case .K:
            return "Stopnie Kelvina (K)"
        }
    }
    
    static func fromString(_ string: String) -> TemperatureUnit? {
        if string == "Stopnie Celsjusza (°C)" {
            return .C
        } else if string == "Stopnie Farenheit'a (°F)" {
            return .F
        } else if string == "Stopnie Kelvina (K)" {
            return .K
        } else {
            return nil
        }
    }
    
    func convertTo(unit to: TemperatureUnit, value val: Double) -> Double {
        var calculation = 1.0
        
        var res : Double
        switch self {
        case .C:
            if to == .F {
                calculation = (val * 1.8) + 32.0
            } else if to == .K {
                calculation = val + 273.15
            }
            
        case .F:
            if to == .C {
                calculation = (val - 32) / 1.8
            } else if to == .K {
                calculation = (val - 32) / 1.8 + 273.15
            }
            
        case .K:
            if to == .C {
                calculation = val - 273.15
            } else if to == .F {
                calculation = val * 9.0 / 5.0 - 459.67
            }
        }
        //zaokrąglenie do 1 miejsca po przecinku
        res = round(100 * calculation)/100
        return res
    }
}


