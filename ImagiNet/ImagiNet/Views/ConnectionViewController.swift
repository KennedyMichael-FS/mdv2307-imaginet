import UIKit
import Foundation

class ConnectionsViewController: UITableViewController {
    
    @IBOutlet var connectionsView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionsView.dataSource = self
        connectionsView.delegate = self
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let card = LoginViewController.extraCard
        
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = "\(String(describing: card!.firstname)) \(String(describing: card!.lastname))\n\(card?.jobtitle ?? "Unspecified Title")"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
}
