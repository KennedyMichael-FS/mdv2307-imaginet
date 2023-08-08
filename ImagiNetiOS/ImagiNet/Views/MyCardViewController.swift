import Foundation
import UIKit
import FirebaseFirestore

public class MyCardViewController: UITableViewController {
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onApplyClicked(_ sender: Any) {
        saveRemoteCard()
    }
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var suffixField: UITextField!
    
    @IBOutlet weak var jobtitle: UITextField!
    @IBOutlet weak var company: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var yearstarted: UITextField!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var otherSocialField: UITextField!
    
    func saveRemoteCard() {
        
        if let firstName = firstNameField.text,
           let lastName = lastNameField.text,
           let jobTitle = jobtitle.text {

            let db = Firestore.firestore()
            let usersCollection = db.collection("users")

            let documentRef = usersCollection.document(LoginViewController.myUid)

            // Create a dictionary with the data to be set in the document
            var data: [String: Any] = ["firstName": firstName,
                                       "lastName": lastName,
                                       "jobtitle": jobTitle]

            // Add other fields if they are not nil
            if let suffix = suffixField.text {
                data["suffixField"] = suffix
            }

            if let company = company.text {
                data["company"] = company
            }

            if let description = descriptionField.text {
                data["description"] = description
            }

            if let yearStarted = yearstarted.text {
                data["yearstarted"] = yearStarted
            }

            if let email = emailField.text {
                data["email"] = email
            }

            if let phone = phoneField.text {
                data["phone"] = phone
            }

            if let otherSocials = otherSocialField.text {
                data["otherSocials"] = otherSocials
            }
            
            loadConnections { connections in
                if let connections = connections {
                    data["connections"] = connections

                    // Update the document with the data
                    documentRef.setData(data, merge: true) { error in
                        if let error = error {
                            print("Error updating document: \(error.localizedDescription)")
                        } else {
                            print("Document updated successfully.")
                        }
                    }
                } else {
                    print("Error: Some required fields were empty.")
                }
            }

            // Update the document with the data
            documentRef.setData(data, merge: true) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document updated successfully.")
                }
            }
        } else {
            print("Error: Some required fields were empty.")
        }
    }
    
    func loadConnections(completion: @escaping ([String]?) -> Void){
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        
        let documentRef = usersCollection.document(LoginViewController.myUid)
        
        documentRef.getDocument { (documentSnapshot, error) in
            if let error = error {
                // Handle the error
                print("Error fetching document: \(error.localizedDescription)")
                return
            }
            
            // Check if the document exists
            guard let document = documentSnapshot, document.exists else {
                print("Document not found.")
                return
            }
            
            if let userData = document.data(), let connections = userData["connections"] as? [String] {
                completion(connections)
                return
            } else {
                print("Connections array not available or is of the wrong type.")
                completion(nil)
            }
        }
        
    }
    
}
