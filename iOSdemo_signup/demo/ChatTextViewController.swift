//
//  ChatTextViewController.swift
//  demo
//
//  Created by Ryosuke Takemoto on 2022/03/01.
//

import UIKit
import Foundation

class ChatTextViewController: UITableViewController {
    
    @IBOutlet weak var chatTableView: UITableView!
        
//    var chatInfo = [ItemsWrapData] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchChatDataByAPIGetTextInChatRoom()

        // Do any additional setup after loading the view.
    }
    
    func fetchChatDataByAPIGetTextInChatRoom(){
            
        let url5 = URL(string:  "https://6vip20gd9i.execute-api.ap-northeast-1.amazonaws.com/getTextInChatRoom_0227_01/")!
            var request5 = URLRequest(url: url5)
            request5.addValue("TylM3L3zFH8N41mkrbqEx92rNiPJICsCaEbSobn8", forHTTPHeaderField: "x-api-key")
        
        do{
        let task = URLSession.shared.dataTask(with: request5) {(data, response, error) in
            if (error != nil) {
                print(error!.localizedDescription)
            }
            guard let _data = data else{ return }
            print(_data)
            
////            let chatInfo = try! JSONDecoder().decode([ItemsWrapData].self, from: _data)
//            print("ここがchatInfo")
//            print(chatInfo)
            
//            for row in chatInfo {てs
//                let chatText = "message:\(row.chat_talk)"
                DispatchQueue.main.async {
                self.tableView.reloadData()
//                }
            }
        }
            task.resume()
    }
}

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) ->
//
//    Int {
//            return chatInfo.count
//        }
//
//        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
//            let chat = chatInfo[indexPath.row]
//
//            cell.textLabel?.text = "\(chat.Items)"
//
//            return cell
//    }

}
