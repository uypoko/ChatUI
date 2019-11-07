//
//  FirstViewController.swift
//  ChatUI
//
//  Created by Ryan on 11/6/19.
//  Copyright © 2019 Daylighter. All rights reserved.
//

import UIKit

class ListMessagesViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendsMessagesStackView: UIStackView!
    @IBOutlet weak var friendsCollectionView: UICollectionView!
    @IBOutlet weak var messagesTableView: UITableView!
    
    let friends = ["Izzie", "Cristina", "George"]
    let senders = ["Derek", "Meredith", "Alex"]
    let lastMessages = ["How you doing?", "Bye", "If the frame is a square, setting the radius"]
    let lastMessageTimes = ["Today", "Yesterday", "Today"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        messagesTableView.dataSource = self
        messagesTableView.delegate = self
        friendsCollectionView.dataSource = self
    }

}

extension ListMessagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return senders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! ListMessageCell
        cell.senderNameLabel.text = senders[indexPath.row]
        cell.lastMessageContentLabel.text = lastMessages[indexPath.row]
        cell.lastMessageTimeLabel.text = lastMessageTimes[indexPath.row]
        return cell
    }
}

extension ListMessagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListMessagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        friends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCell", for: indexPath) as! ListFriendsCell
        cell.friendNameLabel.text = friends[indexPath.row]
        //cell.friendImageView.image = nil
        return cell
    }
}
