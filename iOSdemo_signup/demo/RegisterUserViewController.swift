
import UIKit

class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var useridTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("Cancel button tapped")
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        print("Sign up button tapped")
        
        //Validate required fields are not empty
        if (emailTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)! ||
            (useridTextField.text?.isEmpty)! ||
            (nameTextField.text?.isEmpty)! ||
            (heightTextField.text?.isEmpty)!
        {
            // Display Alert message and return
            displayMessage(userMessage: "All fields are required to fill in")
            return
        }
        
        //Validate password
        if
            ((passwordTextField.text?.elementsEqual(repeatPasswordTextField.text!))! != true)
        {
            // Display Alert message and return
            displayMessage(userMessage: "Please make sure that passwords match")
            return
        }
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(style:UIActivityIndicatorView.Style.medium)
        
        //Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        //If needed, you can prevent Activity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        //Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        //Send HTTP Request to Register user
        let myUrl = URL(string:  "https://0n6on8lv0m.execute-api.us-east-2.amazonaws.com/demoRegister?")
        var request = URLRequest(url: myUrl!)
        request.addValue("tFNfJdubc83lzdnwO1sDS5USmFlIfY1x1puJCQ19", forHTTPHeaderField: "x-api-key")
        request.httpMethod = "POST" //Compose a query String
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = ["email": emailTextField.text!,
                          "pass": passwordTextField.text!,
                          "user_id": useridTextField.text!,
                          "name": nameTextField.text!,
                          "age": ageTextField.text!,
                          "height": heightTextField.text!
        ] as [String: String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong. Try again.")
            return
            
        }
        
        let task = URLSession.shared.dataTask(with: request){ (data: Data?, response:URLResponse?,error: Error?)in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil
            {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            //Let's convert response sent from a server side code to a NSDictionary object:
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    let user_id = parseJSON["user_id"] as? String
                    print("user_id: \(String(describing: user_id!))")
                    
                    if (user_id?.isEmpty)!
                    {
                        //Display an alert dialog with a friendly error message
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                        return
                    } else {
                        self.displayMessage(userMessage: "Successfully Registered a New Account. Please proceed to Sign in")
                    }
                } else {
                    //Display an Alert dialog with a friendly error message
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                }
            } catch {
                self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                
                // Display an Alert dialog with a friendly error message
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print(error)
            }
        }
        
        task.resume()
        
    }
    
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
    {
        DispatchQueue.main.async {
            
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
        }
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: "Alert", message:userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default){ (action:UIAlertAction!)in
                //Code in this block will trigger when OK button tappled.
                print("Ok button tapped")
                DispatchQueue.main.async
                {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
