//
//  ChatListViewController.swift
//  demo
//
//  Created by Ryosuke Takemoto on 2022/02/23.
//

import Foundation

import UIKit

class ChatListViewController: UIViewController {
    
    private let cellId = "cellId"
    
    @IBOutlet weak var chatListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatListTableView.delegate = self
        chatListTableView.dataSource = self

    }
}
    
extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatListTableView.dequeueReusableCell(withIdentifier: cellId, for:indexPath)
        return cell
    }
}

class ChatListTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    @IBOutlet weak var partnerLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
            super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 35
        }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
