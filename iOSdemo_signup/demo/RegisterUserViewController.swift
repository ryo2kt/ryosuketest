
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
        
        if (emailTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)! ||
            (useridTextField.text?.isEmpty)! ||
            (nameTextField.text?.isEmpty)! ||
            (ageTextField.text?.isEmpty)! ||
            (heightTextField.text?.isEmpty)!
              {
                  // Display Alert message and return
                  displayMessage(userMessage: "All fields are required to fill in")
                  return
              }
        
        if ((passwordTextField.text?.elementsEqual(repeatPasswordTextField.text!))! != true)
            {
                // Display alert message and return
                displayMessage(userMessage: "Please make sure that passwords match")
                return
            }
        
        let postString = ["email": emailTextField.text!,
                          "pass": passwordTextField.text!,
                          "user_id": useridTextField.text!,
                          "name": nameTextField.text!,
                          "age": ageTextField.text!,
                          "height": heightTextField.text!
                          
        ] as [String: String]
        
        let url = URL(string:  "https://0n6on8lv0m.execute-api.us-east-2.amazonaws.com/demoRegister?")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //Compose a query String
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        request.addValue("tFNfJdubc83lzdnwO1sDS5USmFlIfY1x1puJCQ19", forHTTPHeaderField: "x-api-key")
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: postString, options: [])
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let d = data, let s = String(data: d, encoding: .utf8) else { return }
        }.resume()
        
        displayMessage(userMessage: "Successfully Registered a New Account")
                
    }
    
    func displayMessage(userMessage:String) -> Void {
           DispatchQueue.main.async
               {
                   let alertController = UIAlertController(title: "Notification", message: userMessage, preferredStyle: .alert)
                   
                   let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                       // Code in this block will trigger when OK button tapped.
                       print("Ok button tapped")
                       DispatchQueue.main.async
                           {
                               self.dismiss(animated: true, completion: nil)
                       }
                   }
                   alertController.addAction(OKAction)
                   self.present(alertController, animated: true, completion:nil)
           }
       }
    
    
    
}
