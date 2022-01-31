//
//  SignInViewController.swift
//  demo
//
//  Created by Ryosuke Takemoto on 2022/01/31.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        print("Sign in button tapped")
    }
    @IBAction func registerNewAccountButtonTapped(_ sender: Any) {
        print("Register account button tapped")
        
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier:"RegisterUserViewController") as! RegisterUserViewController
        
        self.present(registerViewController, animated: true)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
