import Firebase
import FirebaseAuth
import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // Get user input from email and password fields
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            // Display an error to the user that all fields are required
            displayAlert(title: "Missing information...", message: "One or more of the fields are empty. Try again!")
            return
        }

        // Validate email format
        if !isValidEmail(email) {
            displayAlert(title: "Invalid Email...", message: "There's an issue with the email you provided. Try again!")
            return
        }

        // Check if password and confirm password match
        if password != confirmPassword {
            displayAlert(title: "Mismatched passwords...", message: "The passwords you entered do not match. Try again!")
            return
        }

        // Call the registration function
        registerUser(email: email, password: password)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func registerUser(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.displayAlert(title: "Could not register...", message:"Ensure the email isn't in use, and all fields are properly formatted.")
                return
            }
            
            LoginViewController.myUid = Auth.auth().currentUser?.uid
            self.showMainScreen()
        }
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



}
