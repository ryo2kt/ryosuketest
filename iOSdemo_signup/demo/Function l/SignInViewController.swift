

import UIKit


class SignInViewController: UIViewController {
    
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userInfoTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userEmailTextField.text = ""
        userPasswordTextField.text = ""
        userInfoTextView.text = ""
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign in button tapped")
        
        struct User: Codable {
            let user_id: String
            let age: String
            var email: String
            let height: String
            let name: String
            let pass: String
        }
        
        let emailInfo: String? = userEmailTextField.text
        let passInfo: String? = userPasswordTextField.text
        
        if emailInfo?.isEmpty ?? true {
            userInfoTextView.text = "Please enter email"
            return;
        }
        
        if passInfo?.isEmpty ?? true {
            userInfoTextView.text = "Please enter password"
            return;
        }
        
        let url = URL(string:  "https://0n6on8lv0m.execute-api.us-east-2.amazonaws.com/demo-2?")!
        var request = URLRequest(url: url)
        request.addValue("tFNfJdubc83lzdnwO1sDS5USmFlIfY1x1puJCQ19", forHTTPHeaderField: "x-api-key")
        
        do{
            let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
                
                guard let _data = data else{ return }
                let users = try! JSONDecoder().decode([User].self, from: _data)
                
                for row in users {
                    if (row.email == emailInfo && row.pass == passInfo) {
                        DispatchQueue.main.async {
                            let homePage = self.storyboard?.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
                            let appDelegate = UIApplication.shared.delegate
                            appDelegate?.window??.rootViewController = homePage
                            homePage.argName = "name:\(row.name)"
                            homePage.argAge = "age:\(row.age) "
                            homePage.argHeight = "height:\(row.height)"
                            self.userEmailTextField.text = ""
                            self.userPasswordTextField.text = ""
                            self.present(homePage, animated: true)
                        }
                    } else {
                        // ここにエラーメッセージ出るようにしたい。diaplayMessaget使うとログインが進まず、userInfo使うとサインインしてサインアウトしても「Login Falied」が残る
                    }
                }
            }
            task.resume()
        }
        userInfoTextView.text = ""
    }
    
    @IBAction func registerNewAccountButtonTapped(_ sender: Any) {
        print("Register account button tapped")
        
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier:"RegisterUserViewController") as! RegisterUserViewController
        
        self.present(registerViewController, animated: true)
        
        userEmailTextField.text = ""
        userPasswordTextField.text = ""
        
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
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
