
import UIKit

class ConverterTVC: UITableViewController {
    
    @IBOutlet var converterList: UITableView!
    
    //MARK: IBOutlets UIView top-bottom rounded declarations
    @IBOutlet weak var s1Top: UIView!
    @IBOutlet weak var s1Bottom: UIView!
    @IBOutlet weak var s2Top: UIView!
    @IBOutlet weak var s2Bottom: UIView!
    
    
    //MARK: IBOutlets unit labels declarations
    
    
    //MARK: IBOutlets values text fields declarations
    
    
    //MARK: App Lifecycle
    override func viewDidLoad() {
        self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0) // przesuniecie TV do góry
        
        title = "Zamiana jednostek"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        s1Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s1Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
        s2Top.roundCorners(corners: [.topRight, .topLeft], radius: 10)
        s2Bottom.roundCorners(corners: [.bottomLeft, .bottomRight ], radius: 10)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: tableView cystomize
    // wygląd nagłówka sekcji
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor=UIColor.white
        header.textLabel?.font = UIFont(name: "Avenir-Black", size: 12)!
    }
    
    //MARK: IBActions values text fields declarations
    
    //MARK: Functions
    
}
