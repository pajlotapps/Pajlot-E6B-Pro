
import Foundation

class MetarFetch: NSObject, XMLParserDelegate {
    
    private var currentElement = ""
    private var METAR: METARItem!
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var parserCompletionHandler: ((METARItem) -> Void)?
    
    func parseFeed(airfield: String, completionHandler: ((METARItem) -> Void)?){
        self.parserCompletionHandler = completionHandler
        
        let airfieldUrl = "http://awiacja.imgw.pl/rss/metarmil.php?airport=\(airfield)"
        let request = URLRequest(url: URL(string: airfieldUrl)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
    }
    
    // MARK: - XML Parser Delegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if currentElement == "item" {
            currentTitle = ""
            currentDescription = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        switch currentElement {
        case "title":
            var title = string
            title = title.replacingOccurrences(of: "Metar G30 ", with: "")
            currentTitle += title
            let airfield =  globalFunctions().findAirfield(ICAO: title)
            currentTitle += airfield
        case "description":
            var description = string
            description = description.replacingOccurrences(of: "  ", with: "")
            if description != "" {
                currentDescription += description
            }else{
                currentDescription += "Brak aktualnej depeszy"
            }
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            METAR = METARItem(title: currentTitle, description: currentDescription)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(METAR!)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}


