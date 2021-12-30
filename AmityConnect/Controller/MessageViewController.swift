//
//  MessageViewController.swift
//  AmityConnect
//
//  Created by Karthik  Ramu on 12/29/21.
//

import UIKit
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind

}

class MessageViewController: MessagesViewController, MessagesDataSource,MessagesLayoutDelegate, MessagesDisplayDelegate {

    let currentUser = Sender(senderId: "self", displayName: "Hasbulla")

    let otherUser = Sender(senderId: "other", displayName: "Abdu Rozik")

    var messages = [MessageType]()



    override func viewDidLoad() {
        super.viewDidLoad()

        messages.append(Message(sender: currentUser, messageId: "1", sentDate: Date().addingTimeInterval(-86400), kind: .text("Hello World")))

        messages.append(Message(sender: otherUser, messageId: "2", sentDate: Date().addingTimeInterval(-70000), kind: .text("Hello World")))

        messages.append(Message(sender: currentUser, messageId: "3", sentDate: Date().addingTimeInterval(-66400), kind: .text("Hello World")))

        messages.append(Message(sender: otherUser, messageId: "4", sentDate: Date().addingTimeInterval(-56400), kind: .text("Hello World")))

        messages.append(Message(sender: currentUser, messageId: "5", sentDate: Date().addingTimeInterval(-46400), kind: .text("Hello World")))

        messages.append(Message(sender: otherUser, messageId: "6", sentDate: Date().addingTimeInterval(-26400), kind: .text("Hello World")))

        // Do any additional setup after loading the view.
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self

    }

    func currentSender() -> SenderType {
        return currentUser
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }


}
