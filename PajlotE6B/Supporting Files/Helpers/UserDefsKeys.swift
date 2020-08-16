import UIKit

//UserDefaults
var prefs = UserDefaults.standard

//klucze
struct Keys {
    
    static let lang = "LanguageSelected"
    
    static let selectedLanguage = "selectedLanguage"

    static let welcome = "welcomePagesDisplayed"
    static let skipped = "welcomePagesSkipped"
    static let launch = "launchedBefore"
    static let wizard = "filledWizard"
    static let showWizard = "showWizardAtLaunch"
    static let showWelcome = "showWelcomeAtLaunch"
    static let showQR = "showQRcode"
    static let disclaimer = "showDisclaimerInfo"

    static let units = "selectedUnitsArray"
    static let defValues = "defaultValuesArray"

    //Podstawowe
    static let speed = "selectedSpeedUnit"

    static let distance = "selectedDistanceUnit"

    static let time = "selectedTimeUnit"
    static let vspeed = "selectedVspeedUnit"

    static let height = "selectedHeightUnit"
    
    //Inne
    static let wind = "selectedWindUnit"

    static let fuel = "selectedFuelFlowUnit"
    static let useableFuel = "selectedUseableFuelUnit"

    static let elev = "selectedElevUnit"

    //Dodatkowe
    static let vol = "selectedVolUnit"
    static let weight = "selectedWeightUnit"
    static let temp = "selectedTempUnit"
    static let press = "selectedPressUnit"
    static let angle = "selectedAngleUnit"

    //Wartości predefiniowane
    static let speedV = "defaultSpeedValue"
    static let distanceV = "defaultDistanceValue"
    
    static let pressV = "defaultPressureValue"
    static let tempV = "defaultTemperatureValue"
    static let elevV = "defaultElevationValue"
    static let windV = "defaultWindSpeedValue"
    static let windDirV = "defaultWindDirectionValue"
    
    static let fuelV = "defaultFuelFlowValue"
    static let fuelTypeV = "defaultFuelTypeValue"

    static let magDecV = "defaultMagneticDeclinationValue"
    static let varDirV = "defaultVariationDirectionValue"


}

