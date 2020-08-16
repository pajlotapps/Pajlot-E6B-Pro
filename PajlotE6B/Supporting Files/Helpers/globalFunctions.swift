
import UIKit
import StoreKit
import SafariServices

class globalFunctions: UIViewController {
    
    func findAirfield(ICAO: String) -> String {
        var airfield: String = ""
        switch ICAO {
        case "EPCE":
            airfield = " - Cewice"
        case "EPDA":
            airfield = " - Darłowo"
        case "EPDE":
            airfield = " - Dęblin"
        case "EPIR":
            airfield = " - Inowrocław"
        case "EPKS":
            airfield = " - Krzesiny"
        case "EPLK":
            airfield = " - Łask"
        case "EPLY":
            airfield = " - Łęczyca"
        case "EPMB":
            airfield = " - Malbork"
        case "EPMI":
            airfield = " - Mirosławiec"
        case "EPMM":
            airfield = " - Mińsk Mazowiecki"
        case "EPNA":
            airfield = " - Nadarzyce"
        case "EPOK":
            airfield = " - Oksywie"
        case "EPPR":
            airfield = " - Pruszcz Gdański"
        case "EPPW":
            airfield = " - Powidz"
        case "EPSN":
            airfield = " - Świdwin"
        case "EPTM":
            airfield = " - Tomaszów Mazowiecki"
        default:
            airfield = ""
        }
        return airfield
    }
    
    func checkReachability(){
        if currentReachabilityStatus == .reachableViaWiFi {
            isConnected = true
            print("User is connected to the internet via wifi.")
        }else if currentReachabilityStatus == .reachableViaWWAN {
            isConnected = true
            print("User is connected to the internet via WWAN.")
        } else {
            isConnected = false
            print("There is no internet connection")
        }
    }
    
    func showSafariVC(for url: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

