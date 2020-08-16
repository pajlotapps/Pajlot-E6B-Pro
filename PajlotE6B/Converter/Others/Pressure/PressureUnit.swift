
import Foundation

enum PressureUnit: Int {
    case hPa = 0, mmHg, inHg
    
    static func allCases() -> [String] {
        var i = 0
        var list = [String]()
        while let unit = PressureUnit(rawValue: i) {
            list.append(unit.description())
            i = i + 1
        }
        return list
    }
    
    func description() -> String {
        switch self {
        case .hPa:
            return "Hektopaskal (hPa)"
        case .mmHg:
            return "Milimetry słupa rtęci (mmHg)"
        case .inHg:
            return "Cale słupa rtęci (inHg)"
        }
    }
    
    static func fromString(_ string: String) -> PressureUnit? {
        if string == "Hektopaskal (hPa)" {
            return .hPa
        } else if string == "Milimetry słupa rtęci (mmHg)" {
            return .mmHg
        } else if string == "Cale słupa rtęci (inHg)" {
            return .inHg
        } else {
            return nil
        }
    }
    
    func convertTo(unit to: PressureUnit, value val: Double) -> Double {
        var constant = 1.0
        
        var res : Double
        switch self {
        case .hPa:
            if to == .mmHg {
                constant = 0.750061561303
            } else if to == .inHg {
                constant = 0.0295299830714
            }
            
        case .mmHg:
            if to == .hPa {
                constant = 1.3332239
            } else if to == .inHg {
                constant = 0.0393700791974
            }
            
        case .inHg:
            if to == .hPa {
                constant = 33.8638866667
            } else if to == .mmHg {
                constant = 25.399999705
            }
        }
        //zaokrąglenie do 1 miejsca po przecinku
        res = round(10 * val * constant)/10
        return res
    }
}


