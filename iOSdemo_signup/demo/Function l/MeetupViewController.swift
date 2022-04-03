
import UIKit
import SwiftUI
import Foundation
import Darwin

class MeetupViewController: UIViewController {
    
    struct Root2: Decodable {
        let ItemsData: Items2
    }
    
    struct Items2: Decodable {
        let device_id: String
        let roomCreated_timestamp: Int
        let id_list: [idList]
        let last_active_timestamp: Int
        let room_status: String
    }
    
    struct idList: Decodable {
        let userUUID: String
    }
    
    var timer = Timer()
    var timer2: Timer? = nil
    var roomCreatedTimeForTimer: TimeInterval? = nil
    var startTime: TimeInterval? = nil
    var intTimeDiff = Int()
    var intNumberOfUsersInMeetup = Int()
    var roomCreatedTime = Int()
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var memberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func startTimer() {
        
        let getStatusForTimer = URL(string: "https://jr87iicfdf.execute-api.ap-northeast-1.amazonaws.com/getTimestampOfMeetup_0307_01/")!
        var requestGetStatusForTimer = URLRequest(url: getStatusForTimer)
        requestGetStatusForTimer.addValue("Na7ECmE2c08r26FKNenBrgkkCyxk0Ng9JPxNer64", forHTTPHeaderField: "x-api-key")
        
        do {
            let task = URLSession.shared.dataTask(with: requestGetStatusForTimer) { [self](data, response, error) in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
                guard let _data = data else{ return }
                let meetupStatusForTimer = try! JSONDecoder().decode([Items2].self, from: _data)
                for x in meetupStatusForTimer {
                    self.roomCreatedTimeForTimer = TimeInterval(x.roomCreated_timestamp)
                }
            }
            task.resume()
        }
        timer.invalidate()
        self.startTime = Date.timeIntervalSinceReferenceDate
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    @objc func timerCounter() {
        
        guard let roomCreatedTimeForTimer = self.roomCreatedTimeForTimer else {return}
        let date: Date = Date()
        let unixtime: TimeInterval = date.timeIntervalSince1970
        let timeDiff = unixtime - roomCreatedTimeForTimer
        let intTimeDiff = Int(timeDiff)
        print("intTimeDiffのデータはここ：\(intTimeDiff)")
        
        guard let startTime = self.startTime else {return}
        let time = Date.timeIntervalSinceReferenceDate - startTime
        let min = Int(time / 60)
        let sec = Int(time) % 60
        self.timerLabel.text = String(format: "%02d:%02d", min, sec)
    }
    
    @IBAction func startMeetupButtonTapped(_ sender: Any) {
        // 10秒ごとに actionPer10Seconds が動く
        self.timer2 = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.actionPer10Seconds(_:)), userInfo: nil, repeats: true )
        countUsersAndTimepassedWhenFirstTapped()
        startTimer()
    }
    
    @objc func actionPer10Seconds(_ sender: Timer) {
        
        let getStatus = URL(string: "https://jr87iicfdf.execute-api.ap-northeast-1.amazonaws.com/getTimestampOfMeetup_0307_01/")!
        var requestGetStatus = URLRequest(url: getStatus)
        requestGetStatus.addValue("Na7ECmE2c08r26FKNenBrgkkCyxk0Ng9JPxNer64", forHTTPHeaderField: "x-api-key")
        
        do {
            let task = URLSession.shared.dataTask(with: requestGetStatus) { [self](data, response, error) in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
                guard let _data = data else{ return }
                let meetupStatus = try! JSONDecoder().decode([Items2].self, from: _data)
                for x in meetupStatus {
                    let idList = x.id_list
                    let numberOfUsersInMeetup = idList.count
                    self.intNumberOfUsersInMeetup = Int(numberOfUsersInMeetup) - 1
                    
                    guard let roomCreatedTimeForTimer = self.roomCreatedTimeForTimer else {return}
                    let date: Date = Date()
                    let unixtime: TimeInterval = date.timeIntervalSince1970
                    let timeDiff = unixtime - roomCreatedTimeForTimer
                    let intTimeDiff = Int(timeDiff)
                    
                    if intTimeDiff > 30 && intNumberOfUsersInMeetup > 2 {
                        print("meetup生成から30秒経過かつ参加人数3人以上")
                        print("10秒ごとのアクション　〇〇〇meetupを開始しました〇〇〇")
                        createMeetupRoom()
                        print("***新しいmeetupRoomを作成しました***")
                        timer2?.invalidate()
                        timer2 = nil
                        
                        DispatchQueue.main.async {
                            self.timerLabel.text = "00:00"
                            self.memberLabel.text = "meetupを開始しました-1"}
                    }
                    
                    if intTimeDiff > 30 && intNumberOfUsersInMeetup < 3 {
                        print("meetup生成から30秒経過かつ参加人数が3人未満")
                        timer2?.invalidate()
                        timer2 = nil
                        
                        DispatchQueue.main.async {
                            self.timerLabel.text = "00:00"
                            self.memberLabel.text = "meetupはリリースされました"}
                        
                        createMeetupRoom()
                        print("***新しいmeetupRoomを作成しました***")
                        
                        self.roomCreatedTimeForTimer = nil
                        let setIsClosed =  ["roomCreated_timestamp": roomCreatedTime as Int] as [String : Any]
                        let url0331 = URL(string: "https://8k5ahyp1vf.execute-api.ap-northeast-1.amazonaws.com/setIsClosedInMeetup_0331/")!
                        var request0331 = URLRequest(url: url0331)
                        request0331.httpMethod = "POST"
                        request0331.addValue("application/json", forHTTPHeaderField: "Content-type")
                        request0331.addValue("zcfawlN65g7txwld0FygZacTuW89OBA7oxiqoio8", forHTTPHeaderField: "x-api-key")
                        request0331.httpBody = try! JSONSerialization.data(withJSONObject: setIsClosed, options: [])
                        URLSession.shared.dataTask(with: request0331) { data, response, error in
                            guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
                        }.resume()
                        
                        setIsClosedInMeetup()
                        print("***既存のmeetupはリリースします***")
                    }
                }
            }
            task.resume()
        }
        
    }
    //devide_id = "Ryosuke" & Lambdaで指定したTimestampのMeetupの情報を取得
    func countUsersAndTimepassedWhenFirstTapped(){
        
        let getStatus = URL(string: "https://jr87iicfdf.execute-api.ap-northeast-1.amazonaws.com/getTimestampOfMeetup_0307_01/")!
        var requestGetStatus = URLRequest(url: getStatus)
        requestGetStatus.addValue("Na7ECmE2c08r26FKNenBrgkkCyxk0Ng9JPxNer64", forHTTPHeaderField: "x-api-key")
        
        do {
            let task = URLSession.shared.dataTask(with: requestGetStatus) { [self](data, response, error) in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
                guard let _data = data else{ return }
                let meetupStatus = try! JSONDecoder().decode([Items2].self, from: _data)
                var strRoomCreatedTime = ""
                for x in meetupStatus {
                    let idList = x.id_list
                    
                    //JSONデコードしたmeetupデータのid_list配列内の個数をカウント
                    //room作成時にuserIDをempty一つ規定にしているため -1 で調整
                    print("最新meetup内の待機人数: \(idList.count) 人")
                    let numberOfUsersInMeetup = idList.count
                    
                    DispatchQueue.main.async {
                        self.memberLabel.text = "現在の参加者は: \(idList.count)人です"}
                    
                    // meetup内のid_listのユーザー人数が >4　(5以上） の時 新規meetup作成 & meetup開始
                    // DB上でルームを作るときに作るUUIDのemptyがあるため　>4
                    // userを作成した新規meetupに追加
                    if  numberOfUsersInMeetup > 3 {
                        
                        DispatchQueue.main.async {
                            self.timerLabel.text = "00:00"
                            self.memberLabel.text = "meetupを開始しました"}
                        
                        setIsClosedInMeetup()
                        print("***既存のmeetupはリリースします***")
                        print("ボタンタップ時のアクション　〇〇〇meetupを開始しました〇〇〇")
                        createMeetupRoom()
                        print("***新しいmeetupRoomを作成しました***")
                        addNewUserToMeetupRoom()
                        print("***1名のユーザーを新規のmeetupに追加しました***")

                    } else {
                        self.roomCreatedTime = x.roomCreated_timestamp
                        let castStrRoomCreatedTime = roomCreatedTime.description
                        strRoomCreatedTime.append(castStrRoomCreatedTime)
                        print("最新のmeetupが生成された時間（UNIXTimestamp）: \(strRoomCreatedTime)")
                        
                        //meetupが生成された時間のデータとXcode上で発行したUserUUIDをAPIに投げる
                        let postRoomCreated =
                        ["roomCreated_timestamp": roomCreatedTime as Int ,"userUUID": UUID().uuidString as String
                        ] as [String : Any]
                        let url6 = URL(string: "https://hffbn9j34c.execute-api.ap-northeast-1.amazonaws.com/addNewUserInMeetup_0313/")!
                        var request6 = URLRequest(url: url6)
                        request6.httpMethod = "POST"
                        request6.addValue("application/json", forHTTPHeaderField: "Content-type")
                        request6.addValue("V8xMVQrVf9a8iOGqKkoqs1kGclv8ddOk7Z1kKBqL", forHTTPHeaderField: "x-api-key")
                        request6.httpBody = try! JSONSerialization.data(withJSONObject: postRoomCreated, options: [])
                        URLSession.shared.dataTask(with: request6) { data, response, error in
                            guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
                        }.resume()
                        
                        //　投げられたデータでAPIを実行し最新のmeetupにユーザーを追加
                        addNewUserToMeetupRoom()
                        print("***1名のユーザーをmeetupに追加しました***")
                        
                        // adduserと同時に最新のmeetupのLastActiveTimestampを更新
                        let url7 = URL(string: "https://8n9igtpsn1.execute-api.ap-northeast-1.amazonaws.com/setLastActiveTimestamp_0313_01")!
                        var request7 = URLRequest(url: url7)
                        request7.httpMethod = "POST"
                        request7.addValue("application/json", forHTTPHeaderField: "Content-type")
                        request7.addValue("7a2rHgQkQx9aP08xStC2m6bF1ZBmmfoR4ghmad79", forHTTPHeaderField: "x-api-key")
                        request7.httpBody = try! JSONSerialization.data(withJSONObject: postRoomCreated, options: [])
                        URLSession.shared.dataTask(with: request7) { data, response, error in
                            guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
                        }.resume()
                        setLastActiveTimestampOnMeetUp()
                        print("***LastActiveTimestampを更新しました***")
                    }
                }
            }
            task.resume()
        }
    }
    //新規のミートアップ作成
    func createMeetupRoom(){
        let url = URL(string: "https://eahqi238af.execute-api.ap-northeast-1.amazonaws.com/createMeetup_0227_01/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("DPEcmZo36E5v4BByz40LD4FarSshIQot35aogxWV", forHTTPHeaderField: "x-api-key")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
        }.resume()
    }
    
    //最新のミートアップにユーザーを追加
    func addNewUserToMeetupRoom(){
        let url2 = URL(string: "https://hffbn9j34c.execute-api.ap-northeast-1.amazonaws.com/addNewUserInMeetup_0313/")!
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "POST"
        request2.addValue("V8xMVQrVf9a8iOGqKkoqs1kGclv8ddOk7Z1kKBqL", forHTTPHeaderField: "x-api-key")
        URLSession.shared.dataTask(with: request2) { data, response, error in
            guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
        }.resume()
    }
    
    //最新のミートアップのLastActivetimestampを更新
    func setLastActiveTimestampOnMeetUp(){
        
        let url3 = URL(string: "https://8n9igtpsn1.execute-api.ap-northeast-1.amazonaws.com/setLastActiveTimestamp_0313_01/")!
        var request3 = URLRequest(url: url3)
        request3.httpMethod = "POST"
        request3.addValue("7a2rHgQkQx9aP08xStC2m6bF1ZBmmfoR4ghmad79", forHTTPHeaderField: "x-api-key")
        URLSession.shared.dataTask(with: request3) { data, response, error in
            guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
        }.resume()
    }
    
    // 最新のミートアップのroom_statusをis_closedに変更
    func setIsClosedInMeetup(){
        let url0331_2 = URL(string: "https://8k5ahyp1vf.execute-api.ap-northeast-1.amazonaws.com/setIsClosedInMeetup_0331/")!
        var request0331_2 = URLRequest(url: url0331_2)
        request0331_2.httpMethod = "POST"
        request0331_2.addValue("application/json", forHTTPHeaderField: "Content-type")
        request0331_2.addValue("zcfawlN65g7txwld0FygZacTuW89OBA7oxiqoio8", forHTTPHeaderField: "x-api-key")
        URLSession.shared.dataTask(with: request0331_2) { data, response, error in
            guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
        }.resume()
    }
    
}
