import Foundation
import UIKit

public class MessagingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 220/255, green: 247/255, blue: 215/255, alpha: 1.0)
        return tableView
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // Add the container view to the main view and center it with fixed width
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 320), // Adjust the width as needed
            containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
        
        // Add the table view to the container view and set its delegate and data source
        containerView.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        // Apply constraints to the table view to match its size with the container view
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    // MARK: UITableViewDataSource methods
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let card = LoginViewController.extraCard
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.backgroundColor = UIColor(red: 192/255, green: 228/255, blue: 181/255, alpha: 1.0) // Mint background color for cell
        
        // Remove existing subviews to avoid duplicate content
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text? = "\(String(describing: card?.firstname)) \(String(describing: card?.lastname))"
        cell.contentView.addSubview(titleLabel)
        
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = "No messages available."
        cell.contentView.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            // Constraints for titleLabel
            titleLabel.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -12),
            
            // Constraints for messageLabel
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            messageLabel.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -12),
            messageLabel.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -12)
        ])
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension // Use automatic cell height to fit the content
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120  // Estimated cell height for better scrolling performance
    }
}
