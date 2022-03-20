//
//  Items.swift
//  demo
//
//  Created by Ryosuke Takemoto on 2022/03/02.
//

import Foundation

//ChatRoomの構造体

struct Root: Decodable {
    let ItemsData: Items
}

struct Items: Decodable {
    //    let id_list: [idList]
    let chat_talk: [chatTalk]
    //    let is_deleted: String
}

//  struct idList: Codable {
//      let userUUID: String
//       }

struct chatTalk: Decodable {
    let text: String
    //            let userUUID: String
    //            let is_deleted: String
    //            let timestamp: String
}


////MeetupRoomの構造体
//
//struct Root2: Decodable {
//    let ItemsData2: Items2
//}
//
//struct Items2: Decodable {
//    let meetupID: String
//    let id_list: [idList]
//    let last_active_timestamp: String
//    let start_timestamp: String
//    
//}
//
//struct idList: Decodable {
//    let userUUID: String
//}
//
