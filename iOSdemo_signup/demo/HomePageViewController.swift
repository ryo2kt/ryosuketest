
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
    
    @IBAction func startMeetupButtonTapped(_ sender: Any) {
        
        //devide_id = "Ryosuke" & Lambdaで指定したTimestampのMeetupの情報を取得
        countUsersInLatestMeetup()
                
        //ロジック部分：lambdaのfunctionでgetMeetupRoomStatus
        //新しいmeetupを作るの場合→ create(ここでroomUUID) + add（作ったのと同じのを使う）
        // 入るの場合→　add lambdaのfunctionで入れるroomUUIDをリターンするr
        
        //getStatusInMeetupでリターン返ってきたらaddNewUser
        //返ってこなかったらcreateNewchatRoom
        
//        ①UUIDはLambda上ではなくiOS上で発行してAPIに投げる
//
//  　　Startボタンを押した時
//          3人以下かつ五分未満 = ユーザー追加
//          それ以外は新しくルーム作る
        //　　入った瞬間からタイマーが始まる
        //  　10秒に1回自分が入ったroomの情報を取ってくる
        //      今の人数が3人以下の場合　何もしない
        //      4人の場合 meetup始める
        //    タイマーが5分になった時（CREATEMEETUPしたユーザーはこれ）
        //      今の人数が2人以下の場合　=> 解散
        //  　　　3人以上の場合 => meetupを始める
        //    roomtstatusで　started と　released を作る
        //     別パターン
        //        二人目以降は自分が入ったタイミングで生成時間 /　createdstampから入った時間で逆算
        
//
//        3人の場合は5分経ったら始まる
//        2人以下だったら5分経ったら解散
//        └デバイス側でタイマーを走らせる
//
//
//        5 or 10秒に1回持ってきて　4人いたら始まる
//        デバイス上でタイマーを動かしておいて5分時点で通話開始
//        1〜2人の場合はそのまま終了


        
        
        
        func countUsersInLatestMeetup(){
            
            struct Root2: Decodable {
                let ItemsData: Items2
            }

            struct Items2: Decodable {
                let device_id: String
                let id_list: [idList]
                let meetupID: String
                let last_active_timestamp: String
                let roomCreated_timestamp: String
                
            }

            struct idList: Decodable {
                let userUUID: String
            }

            let getStatus = URL(string: "https://jr87iicfdf.execute-api.ap-northeast-1.amazonaws.com/getTimestampOfMeetup_0307_01/")!
            var requestGetStatus = URLRequest(url: getStatus)
            requestGetStatus.addValue("Na7ECmE2c08r26FKNenBrgkkCyxk0Ng9JPxNer64", forHTTPHeaderField: "x-api-key")
          
            do {
                let task = URLSession.shared.dataTask(with: requestGetStatus) {(data, response, error) in
                    if (error != nil) {
                        print(error!.localizedDescription)
                    }
                    guard let _data = data else{ return }
                    let meetupStatus = try! JSONDecoder().decode([Items2].self, from: _data)
                    
                    var strRoomCreatedTime = ""
        
                    for x in meetupStatus {
                        let idList = x.id_list
                        print(idList)
                        //JSONデコードしたmeetupデータのid_list配列内の個数をカウント
                        //room作成時にuserIDをempty一つ規定にしているため -1 で調整
                        print("最新meetup内の待機人数: \(idList.count-1) 人")
                        let numberOfUsersInMeetup = idList.count
                        
                        // meetup内のid_listのユーザー人数が >4　(5以上） の時 新規meetup作成
                        // 規定のemptyがあるため4ではなく5
                        // userを作成した新規meetupに追加
                        
                        if  numberOfUsersInMeetup > 4
                        {
                            createMeetupRoom()
                            print("***新しいmeetupRoomを作成***")
                            addNewUserToMeetupRoom()
                            print("***新しいユーザー1名をmeetupに追加***")
                            
                        // 4 以下の時には最新のmeetupのcreatedtimeを取得
                            
                        } else {
                            
                            let roomCreatedTime = x.roomCreated_timestamp
                            strRoomCreatedTime.append(roomCreatedTime)
                            print("最新のmeetupが生成された時間: \(strRoomCreatedTime)")

                            // 取得したデータをAPIに投げる
                            
                            let roomCreated =
                            ["roomCreated_timestamp": strRoomCreatedTime,
                            ] as [String: String]
                            
                            let url6 = URL(string: "https://hffbn9j34c.execute-api.ap-northeast-1.amazonaws.com/addNewUserInMeetup_0313/")!
                            var request6 = URLRequest(url: url6)
                            request6.httpMethod = "POST"
                            request6.addValue("application/json", forHTTPHeaderField: "Content-type")
                            request6.addValue("V8xMVQrVf9a8iOGqKkoqs1kGclv8ddOk7Z1kKBqL", forHTTPHeaderField: "x-api-key")
                            request6.httpBody = try! JSONSerialization.data(withJSONObject: roomCreated, options: [])
                            URLSession.shared.dataTask(with: request6) { data, response, error in
                                guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
                            }.resume()
                            
                            //　投げられたデータでAPIを実行し最新のmeetupにユーザーを追加
                                                        
                            addNewUserToMeetupRoom()
                            print("***新しいユーザーを既存meetupに追加***")
                            
                            // adduserと同時に最新のmeetupのLastActiveTimestampを更新
                            
                            let url7 = URL(string: "https://8n9igtpsn1.execute-api.ap-northeast-1.amazonaws.com/setLastActiveTimestamp_0313_01")!
                            var request7 = URLRequest(url: url7)
                            request7.httpMethod = "POST"
                            request7.addValue("application/json", forHTTPHeaderField: "Content-type")
                            request7.addValue("7a2rHgQkQx9aP08xStC2m6bF1ZBmmfoR4ghmad79", forHTTPHeaderField: "x-api-key")
                            request7.httpBody = try! JSONSerialization.data(withJSONObject: roomCreated, options: [])
                            URLSession.shared.dataTask(with: request7) { data, response, error in
                                guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
                            }.resume()
                            
                            setLastActiveTimestampOnMeetUp()
                            print("***LastActiveTimestampを更新***")
                            
                    }
                    }

                    }
                task.resume()
            }
            
        }

        //Create meetup room　新規ミートアップ作成
        func createMeetupRoom(){
            let url = URL(string: "https://eahqi238af.execute-api.ap-northeast-1.amazonaws.com/createMeetup_0227_01/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("DPEcmZo36E5v4BByz40LD4FarSshIQot35aogxWV", forHTTPHeaderField: "x-api-key")
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
            }.resume()
        }
        
        //Add new user to meetup　ユーザーをミートアップに追加
        func addNewUserToMeetupRoom(){
            let url2 = URL(string: "https://hffbn9j34c.execute-api.ap-northeast-1.amazonaws.com/addNewUserInMeetup_0313/")!
            var request2 = URLRequest(url: url2)
            request2.httpMethod = "POST"
            request2.addValue("V8xMVQrVf9a8iOGqKkoqs1kGclv8ddOk7Z1kKBqL", forHTTPHeaderField: "x-api-key")
            URLSession.shared.dataTask(with: request2) { data, response, error in
                guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
            }.resume()
        }
        
        //Set LastActive timestamp　ミートアップのLastActivetimestampを更新
        func setLastActiveTimestampOnMeetUp(){
            
            let url3 = URL(string: "https://8n9igtpsn1.execute-api.ap-northeast-1.amazonaws.com/setLastActiveTimestamp_0313_01/")!
            var request3 = URLRequest(url: url3)
            request3.httpMethod = "POST"
            request3.addValue("7a2rHgQkQx9aP08xStC2m6bF1ZBmmfoR4ghmad79", forHTTPHeaderField: "x-api-key")
            URLSession.shared.dataTask(with: request3) { data, response, error in
                guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
            }.resume()
        }
    }
    
    @IBOutlet weak var meetupRoomStatus: UILabel!
    
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
