import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController, UITextFieldDelegate {
    
    public static var deeplinkAction = ""
    public static var deeplinkAccessory = ""
    
    public static var myCard: BusinessCard?
    public static var extraCard: BusinessCard!
    public static var myUid: String!

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var welcomeText: UILabel!
    
    @IBAction func loginButton(_ sender: Any) {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            // MARK: Need to set up an incorrect login data alert.
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
            if let error = error {
                // Handle login error (e.g., show an alert)
                print("Login error: \(error.localizedDescription)")
                return
            }
            
            // Login successful, navigate to the rest of the app.
            print("Login successful")
            LoginViewController.myUid = Auth.auth().currentUser?.uid
            self!.showMainScreen()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print(LoginViewController.deeplinkAction)
        if (LoginViewController.deeplinkAction == "add") {
            welcomeText.text = "Please log in to add this user."
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showMainScreen() {
        
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
