import UIKit
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

class ConnectionsViewController: UITableViewController {
    
    var db: Firestore!
    public static var connections: [BusinessCard] = []
    
    @IBOutlet var connectionsView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connectionsView.dataSource = self
        connectionsView.delegate = self
        
        db = Firestore.firestore()
        
        getConnections { (connectionID, error) in
            if let error = error {
                // Handle the error
                print("Error fetching connection ID: \(error.localizedDescription)")
                return
            }
            
            if let connectionID = connectionID {
                print("Connection ID: \(connectionID)")
                
                // Call loadCards here, after you have the connectionID
                self.loadCards(forConnectionID: connectionID)
            } else {
                // 'connections' field not found or is of the wrong type
                print("Error: Connection ID not available or is of the wrong type.")
            }
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let card = ConnectionsViewController.connections[indexPath.row]
        
        cell.textLabel?.numberOfLines = 2
        cell.textLabel?.text = "\(String(describing: card.firstname)) \(String(describing: card.lastname))\n\(card.jobtitle )"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Creating tableView with num of rows: \(ConnectionsViewController.connections.count)")
        return ConnectionsViewController.connections.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCardSegue", sender: indexPath.row)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCardSegue" {
            if let destinationVC = segue.destination as? CardViewer,
               let selectedCardIndex = sender as? Int {
                let selectedCard = ConnectionsViewController.connections[selectedCardIndex]
                CardViewer.businessCard = selectedCard
            }
        }
    }

    
    func getUserDocumentByID(documentID: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        // Reference to the specific document using its documentID
        let documentRef = usersCollection.document(documentID)
        
        // Fetch the document
        documentRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                // Handle the error
                completion(nil, error)
                return
            }
            
            // Check if the document exists
            guard let document = documentSnapshot, document.exists else {
                // Document does not exist
                completion(nil, nil)
                return
            }
            
            // Return the document
            completion(document, nil)
        }
    }
    
    func getConnections(completion: @escaping (String?, Error?) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        // Reference to the specific document using its documentID
        let documentRef = usersCollection.document(LoginViewController.myUid)
        
        // Fetch the document
        documentRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                // Handle the error
                print("Error fetching document: \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            // Check if the document exists
            guard let document = documentSnapshot, document.exists else {
                // Document does not exist
                print("Document does not exist for UID: \(String(describing: LoginViewController.myUid))")
                completion(nil, nil)
                return
            }
            
            // Check if the 'connections' field exists and is of type String
            if let userData = document.data(), let connectionID = userData["connections"] as? String {
                // Print the 'connectionID' to verify if it's correct
                print("Connection ID: \(connectionID)")
                // Return the 'connectionID'
                completion(connectionID, nil)
            } else {
                // 'connections' field does not exist or is of the wrong type
                print("Error: 'connections' field not available or is of the wrong type.")
                completion(nil, nil)
            }
        }
    }

    
    func loadCards(forConnectionID connectionID: String) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        // Fetch the document for the provided connectionID
        usersCollection.document(connectionID).getDocument { (documentSnapshot, error) in
            if let error = error {
                // Handle the error
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            
            // Check if the document exists
            guard let document = documentSnapshot, document.exists else {
                // Document does not exist
                print("Document does not exist.")
                return
            }
            
            // Extract the data fields from the document
            if let firstName = document["firstName"] as? String,
               let lastName = document["lastName"] as? String,
               let jobTitle = document["jobtitle"] as? String {
                ConnectionsViewController.connections.append(BusinessCard(first: firstName, last: lastName, jtitle: jobTitle))
                print(ConnectionsViewController.connections)
                self.tableView.reloadData()
            }
        }
    }

    
    
}
