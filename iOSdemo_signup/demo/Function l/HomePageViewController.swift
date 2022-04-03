
import UIKit
import SwiftUI
import Foundation

class HomePageViewController: UIViewController {
    
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userAgeLabel: UILabel!
    
    @IBOutlet weak var userHeightLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    @IBAction func goMeetupButtonTapped(_ sender: Any) {
        
        DispatchQueue.main.async {
            let meetUp = self.storyboard?.instantiateViewController(withIdentifier: "MeetupViewController") as! MeetupViewController
            let appDelegate = UIApplication.shared.delegate
            appDelegate?.window??.rootViewController = meetUp
            self.present(meetUp, animated: true)
        }
        
    }
    
        
    @IBOutlet weak var inputChatText: UITextField!
    
    @IBAction func sendTextButtonTapped(_ sender: Any) {
        
        postTextInChatTalk()
        
        getTextInChatTalk()
        
        //Post text in chat talk
        func postTextInChatTalk(){
            
            let postString =
            ["text": inputChatText.text!,
            ] as [String: String]
            
            let url4 = URL(string: "https://d0uredhuhh.execute-api.ap-northeast-1.amazonaws.com/postTextInChatRoom_0227_01/")!
            var request4 = URLRequest(url: url4)
            request4.httpMethod = "POST"
            request4.addValue("application/json", forHTTPHeaderField: "Content-type")
            request4.addValue("5myG8ke5IC9D1yJd3Seuu2PCgr7FtvyS5sAwcqCe", forHTTPHeaderField: "x-api-key")
            request4.httpBody = try! JSONSerialization.data(withJSONObject: postString, options: [])
            URLSession.shared.dataTask(with: request4) { data, response, error in
                guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
            }.resume()
            self.inputChatText.text = ""
        }
        
        //Get text in chat talk
        func getTextInChatTalk(){
            let url5 = URL(string:  "https://6vip20gd9i.execute-api.ap-northeast-1.amazonaws.com/getTextInChatRoom_0227_01/")!
            var request5 = URLRequest(url: url5)
            request5.addValue("TylM3L3zFH8N41mkrbqEx92rNiPJICsCaEbSobn8", forHTTPHeaderField: "x-api-key")
            
            do{
                let task = URLSession.shared.dataTask(with: request5) {(data, response, error) in
                    if (error != nil) {
                        print(error!.localizedDescription)
                    }
                    guard let _data = data else{ return }
                    
                    let chatInfo = try! JSONDecoder().decode([Items].self, from: _data)
                    
                    var ChatText = ""
                    
                    for x in chatInfo {
                        let chatTalk = x.chat_talk
                        for y in chatTalk {
                            let textInChat = y.text
                            ChatText.append(textInChat)
                            ChatText.append("\n")
                        }
                    }

                    DispatchQueue.main.async {
                        print(ChatText)
                        self.displayChatText.text = ChatText
                    }
                }
                task.resume()
            }
        }
        
    }
    
    @IBOutlet weak var displayChatText: UITextView!
    
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
