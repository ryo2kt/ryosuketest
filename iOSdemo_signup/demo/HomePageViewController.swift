
import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userAgeLabel: UILabel!
    
    @IBOutlet weak var userHeightLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOutButtonTapped(_ sender: Any) {
        print("Sign out button tapped")
    }
    
    @IBAction func loadMemberProfileButtonTapped(_ sender: Any) {
        print("Load member profile button tapped")
    }
    

}
