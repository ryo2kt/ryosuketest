
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
        print("intTimeDiff????????????????????????\(intTimeDiff)")
        
        guard let startTime = self.startTime else {return}
        let time = Date.timeIntervalSinceReferenceDate - startTime
        let min = Int(time / 60)
        let sec = Int(time) % 60
        self.timerLabel.text = String(format: "%02d:%02d", min, sec)
    }
    
    @IBAction func startMeetupButtonTapped(_ sender: Any) {
        // 10???????????? actionPer10Seconds ?????????
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
                        print("meetup????????????30???????????????????????????3?????????")
                        print("10???????????????????????????????????????meetup??????????????????????????????")
                        createMeetupRoom()
                        print("***?????????meetupRoom?????????????????????***")
                        timer2?.invalidate()
                        timer2 = nil
                        
                        DispatchQueue.main.async {
                            self.timerLabel.text = "00:00"
                            self.memberLabel.text = "meetup?????????????????????-1"}
                    }
                    
                    if intTimeDiff > 30 && intNumberOfUsersInMeetup < 3 {
                        print("meetup????????????30??????????????????????????????3?????????")
                        timer2?.invalidate()
                        timer2 = nil
                        
                        DispatchQueue.main.async {
                            self.timerLabel.text = "00:00"
                            self.memberLabel.text = "meetup??????????????????????????????"}
                        
                        createMeetupRoom()
                        print("***?????????meetupRoom?????????????????????***")
                        
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
                        print("***?????????meetup????????????????????????***")
                    }
                }
            }
            task.resume()
        }
        
    }
    //devide_id = "Ryosuke" & Lambda???????????????Timestamp???Meetup??????????????????
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
                    
                    //JSON??????????????????meetup????????????id_list?????????????????????????????????
                    //room????????????userID???empty????????????????????????????????? -1 ?????????
                    print("??????meetup??????????????????: \(idList.count) ???")
                    let numberOfUsersInMeetup = idList.count
                    
                    DispatchQueue.main.async {
                        self.memberLabel.text = "?????????????????????: \(idList.count)?????????"}
                    
                    // meetup??????id_list???????????????????????? >4???(5????????? ?????? ??????meetup?????? & meetup??????
                    // DB???????????????????????????????????????UUID???empty??????????????????>4
                    // user?????????????????????meetup?????????
                    if  numberOfUsersInMeetup > 3 {
                        
                        DispatchQueue.main.async {
                            self.timerLabel.text = "00:00"
                            self.memberLabel.text = "meetup?????????????????????"}
                        
                        setIsClosedInMeetup()
                        print("***?????????meetup????????????????????????***")
                        print("???????????????????????????????????????????????????meetup??????????????????????????????")
                        createMeetupRoom()
                        print("***?????????meetupRoom?????????????????????***")
                        addNewUserToMeetupRoom()
                        print("***1??????????????????????????????meetup?????????????????????***")

                    } else {
                        self.roomCreatedTime = x.roomCreated_timestamp
                        let castStrRoomCreatedTime = roomCreatedTime.description
                        strRoomCreatedTime.append(castStrRoomCreatedTime)
                        print("?????????meetup???????????????????????????UNIXTimestamp???: \(strRoomCreatedTime)")
                        
                        //meetup???????????????????????????????????????Xcode??????????????????UserUUID???API????????????
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
                        
                        //??????????????????????????????API?????????????????????meetup????????????????????????
                        addNewUserToMeetupRoom()
                        print("***1?????????????????????meetup?????????????????????***")
                        
                        // adduser?????????????????????meetup???LastActiveTimestamp?????????
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
                        print("***LastActiveTimestamp?????????????????????***")
                    }
                }
            }
            task.resume()
        }
    }
    //?????????????????????????????????
    func createMeetupRoom(){
        let url = URL(string: "https://eahqi238af.execute-api.ap-northeast-1.amazonaws.com/createMeetup_0227_01/")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("DPEcmZo36E5v4BByz40LD4FarSshIQot35aogxWV", forHTTPHeaderField: "x-api-key")
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
        }.resume()
    }
    
    //???????????????????????????????????????????????????
    func addNewUserToMeetupRoom(){
        let url2 = URL(string: "https://hffbn9j34c.execute-api.ap-northeast-1.amazonaws.com/addNewUserInMeetup_0313/")!
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "POST"
        request2.addValue("V8xMVQrVf9a8iOGqKkoqs1kGclv8ddOk7Z1kKBqL", forHTTPHeaderField: "x-api-key")
        URLSession.shared.dataTask(with: request2) { data, response, error in
            guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
        }.resume()
    }
    
    //??????????????????????????????LastActivetimestamp?????????
    func setLastActiveTimestampOnMeetUp(){
        
        let url3 = URL(string: "https://8n9igtpsn1.execute-api.ap-northeast-1.amazonaws.com/setLastActiveTimestamp_0313_01/")!
        var request3 = URLRequest(url: url3)
        request3.httpMethod = "POST"
        request3.addValue("7a2rHgQkQx9aP08xStC2m6bF1ZBmmfoR4ghmad79", forHTTPHeaderField: "x-api-key")
        URLSession.shared.dataTask(with: request3) { data, response, error in
            guard let d = data, let s_ = String(data: d, encoding: .utf8) else { return }
        }.resume()
    }
    
    // ??????????????????????????????room_status???is_closed?????????
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
