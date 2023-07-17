import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    public static var myCard: BusinessCard?
    public static var extraCard: BusinessCard!

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBAction func loginButton(_ sender: Any) {
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        
        if loginSuccessful(email: email, password: password) {
            showMainScreen()
        } else {
            // Handle unsuccessful login (e.g., display an error message)
            print("Invalid credentials")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showMainScreen() {
        
        LoginViewController.myCard? = BusinessCard(first: "John", last: "Appleseed")
        LoginViewController.extraCard = BusinessCard(first: "Jane", last: "Applelover", company: "Apple, Inc", jobtitle: "Example Coordinator", about: "A short little description of a person, which they've wrote for you to see.", website: nil, photo: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Replace "Main" with your storyboard name if different
        
        let tabBarController = UITabBarController()
        let messagingVC = storyboard.instantiateViewController(withIdentifier: "MessagingViewController") as! MessagingViewController
        let connectionsVC = storyboard.instantiateViewController(withIdentifier: "ConnectionsViewController") as! ConnectionsViewController
        let addCardVC = storyboard.instantiateViewController(withIdentifier: "AddCardViewController") as! AddCardViewController
        let myCardVC = storyboard.instantiateViewController(withIdentifier: "MyCardViewController") as! MyCardViewController
        let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        // Set titles for the tabs
        messagingVC.title = "Messaging"
        connectionsVC.title = "Connections"
        addCardVC.title = "Add Card"
        myCardVC.title = "My Card"
        settingsVC.title = "Settings"
        
        // Create an array of the view controllers
        let viewControllers = [messagingVC, connectionsVC, addCardVC, myCardVC, settingsVC]
        
        // Set the view controllers for the tab bar controller
        tabBarController.viewControllers = viewControllers.map { UINavigationController(rootViewController: $0) }
        
        // Set the tab bar controller as the root view controller
        UIApplication.shared.windows.first?.rootViewController = tabBarController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func loginSuccessful(email: String, password: String) -> Bool {
        return (email == "test@testing.com" && password == "password")
    }
}
