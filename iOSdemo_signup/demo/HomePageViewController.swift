
import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userAgeLabel: UILabel!
    
    @IBOutlet weak var userHeightLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var argName = ""
    var argAge = ""
    var argHeight = ""

    @IBAction func signOutButtonTapped(_ sender: Any) {
        print("Sign out button tapped")
        
        let signInPage = self.storyboard?.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = signInPage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loadMemberProfileButtonTapped(_ sender: Any) {
        print("Load member profile button tapped")
        
        userNameLabel.text = argName
        userAgeLabel.text = argAge
        userHeightLabel.text = argHeight
        
    }
    
    func displayMessage(userMessage:String) -> Void {
          DispatchQueue.main.async
              {
                  let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                  
                  let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                      // Code in this block will trigger when OK button tapped.
                      print("Ok button tapped")
                  }
                  alertController.addAction(OKAction)
                  self.present(alertController, animated: true, completion:nil)
          }
      }

}
