
import UIKit

var isConnected = false

let gf = globalFunctions()

var availableUnits = [["KPH", "KT", "MPH"],                 //0 speed
                      ["km", "NM", "SM"],                   //1 distance
                      ["HH : MM : SS", "MM : SS", "SS"],    //2 time
                      ["m/s", "ft/min"],                    //3 vspeed
                      ["m", "ft", "FL"],                    //4 height
                      ["m/s", "KT", "KPH"],                 //5 wind speed
                      ["l/h", "kg/h", "lbs/h"],             //6 fuel flow
                      ["m", "ft"],                          //7 Elevation
                      ["l", "m³"],                          //8 volume
                      ["kg", "lb"],                         //9 weight
                      ["°C", "°F", "K"],                    //10 temperature
                      ["hPa", "mmHg", "inHg"],              //11 pressure
                      ["°", "rad"],                         //12 angle
                      ["l", "kg", "lb"],                    //13 usablefuel
                      ["E", " W"]]                          //14 variaton

var unitsArray = ["Speed", "Distance", "Time", "Vspeed", "Height", "Wind", "FuelFlow", "Elev", "Vol", "Weight", "Temp", "Press", "Angle", "VariationDirection", "UsableFuel"]

var selectedUnits = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]

var defUnits = ["KPH", "km", "HH : MM : SS", "m/s", "m", "m/s", "l/h", "m", "l", "kg", "°C", "hPa", "°", "l", "E"]

var hours : Int = 0
var minutes : Int = 0
var seconds : Int = 0

var varDir = ""
var defVarDir = "E"

var fuelType = ""
var defFuelType = "JET A1"

var defaultsArray =  ["Speed", "Distance", "Pressure", "Temperature", "Elevation", "WindSpeed", "WindDirection", "FuelFlow", "FuelType", "MagneticDeclination"]
var setValues: [Float] = [0, 0, 0, 0, 0, 0, 0, 0, 0]
var defValues: [Float] = [300, 300, 1013.25, 15, 84, 5, 090, 300, 5]

struct METARItem {
    var title: String
    var description: String
}

struct TAFItem {
    var title: String
    var description: String
}

var ICAOcodesMIL = ["EPIR", "EPCE", "EPDA", "EPDE", "EPKS", "EPLK", "EPLY", "EPMB", "EPMI", "EPMM", "EPNA", "EPOK", "EPPR", "EPPW", "EPSN", "EPTM"]

var ICAOcodesDescription = ["Inowrocław", "Cewice", "Darłowo", "Dęblin", "Krzesiny", "Łask", "Łęczyca", "Malbork", "Mirosławiec", "Mińsk Mazowiecki", "Nadarzyce", "Oksywie", "Pruszcz Gdański", "Powidz", "Świdwin", "Tomaszów Mazowiecki"]

struct GVar {
    static var speed            : Float = 0.0
    static var distance         : Float = 0.0
    static var time             : Float = 0.0
    static var vSpeed           : Float = 0.0
    
    static var speedU           : String!
    static var distanceU        : String!
    static var timeU            : String!
    static var timeString       : String!
    
    static var vspeedU          : String!
    static var heightU          : String!
}

struct GUnit {
    static var speed            : Int = 0
    static var distance         : Int = 0
    static var time             : Int = 0
    static var vSpeed           : Int = 0
    static var height           : Int = 0
}

struct uTypes {
    //podstawowe
    static var speed            : [String] = [" km/h", " kt", " mph"]
    static var distance         : [String] = [" km", " NM", " SM"]
    static var time             : [String] = [" hh:mm:ss", " mm:ss", " ss"]
    static var vspeed           : [String] = [" m/s", " ft/min"]
    static var height           : [String] = [" m", " m", "FL "]
    //inne
    static var wind             : [String] = [" m/s", " km/h", " kt"]
    static var fuel             : [String] = [" l/h", " kg/h", " lbs/h"]
    static var elevation        : [String] = [" m", " ft"]
    //dodatkowe
    static var volume           : [String] = [" l", " m3"]
    static var weight           : [String] = [" kg", " lb"]
    static var temp             : [String] = [" °C", " °F" , " K"]
    static var pressure         : [String] = [" hPa", " mmHg" , " inHg"]
    static var angle            : [String] = [" deg", " rad"]
    static var usableFuel       : [String] = [" l", " kg", " lb"]
}

struct selUnits {
    //Podstawowe
    static var speed            : String!
    static var distance         : String!
    static var time             : String!
    static var vspeed           : String!
    static var height           : String!

    //Inne
    static var wind             : String!
    static var fuelflow         : String!
    static var elevation        : String!
    //Dodatkowe
    static var volume           : String!
    static var weight           : String!
    static var temp             : String!
    static var pressure         : String!
    static var angle: String!
    static var useableFuel: String!
    static var magDec: String!
}

struct selValues {
    //Podstawowe
    static var speed            : String!
    static var distance         : String!
    static var hh               : String!
    static var mm               : String!
    static var ss               : String!
    static var vspeed           : String!
    static var height           : String!
    static var initialH         : String!
    static var targetH          : String!
    
    //Inne
    static var windSpeed: String!
    static var windDirection: String!
    static var crsDirection: String!
    
    static var fuelflow: String!
    static var useableFuel: String!
    static var elevation: String!
    //Dodatkowe
    static var volume           : String!
    static var weight           : String!
    static var temp             : String!
    static var pressure         : String!
    static var angle            : String!
    
    //Wartości domyślne
    
}
