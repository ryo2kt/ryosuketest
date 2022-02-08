

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
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
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
    
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    struct User: Codable {
        let user_id: String
        let age: String
        let email: String
        let height: String
        let name: String
        let pass: String
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign in button tapped")
        
        // Read values from text fields
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        
        // Check if required fields are not empty
        if (userEmail?.isEmpty)! || (userPassword?.isEmpty)!
        {
            // Display alert message here
            print("User email \(String(describing: userEmail))or password \(String(describing: userPassword)) is empty")
            displayMessage(userMessage: "One of the required fields is missing")
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

        let myUrl = URL(string:  "https://0n6on8lv0m.execute-api.us-east-2.amazonaws.com/demo-2?")
        var request = URLRequest(url: myUrl!)
        request.addValue("tFNfJdubc83lzdnwO1sDS5USmFlIfY1x1puJCQ19", forHTTPHeaderField: "x-api-key")
        
        let postString = ["userEmail": userEmail!, "userPassword": userPassword!] as [String: String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong...")
            return
        }
    
        URLSession.shared.dataTask(with: request){ (data: Data?, response: URLResponse?, error: Error?) in
        
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil{
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            guard let _data = data else{ return }
        
            // Let's convert response sent from a server side code to a NSDictionary object:
            
            do{
                let users = try JSONDecoder().decode([User].self, from: _data)
                
                for row in users {
                    
                    if (userEmail == \row.email && userPassword == \row.pass){
                       
                        DispatchQueue.main.async{
                            let homePage =
                            self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window??.rootViewController = homePage

                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                        return
                    }
            
                } else {
                    // Display an Alert
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
        
    
    @IBAction func registerNewAccountButtonTapped(_ sender: Any) {
        print("Register account button tapped")
        
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier:"RegisterUserViewController") as! RegisterUserViewController
        
        self.present(registerViewController, animated: true)
        
    }

    }
}
}
