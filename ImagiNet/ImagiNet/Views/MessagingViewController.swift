import Foundation
import UIKit

public class MessagingViewController: UITableViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let card = LoginViewController.extraCard
        
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = "\(String(describing: card!.firstname)) \(String(describing: card!.lastname))\n\("I'd love to get with you and discuss a potential opening within the company.")"
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
