//
//  Message.swift
//  ChatApp
//
//  Created by Jérémy Perez on 04/09/2023.
//

import Firebase

struct Message {
    let text: String
    let toId: String
    let fromId: String
    let timestamp: Timestamp!
    var user: User?
    
    let isFromCurrentUser: Bool
    
    init(dictionnary: [String: Any]) {
        self.text = dictionnary["text"] as? String ?? ""
        self.toId = dictionnary["toId"] as? String ?? ""
        self.fromId = dictionnary["fromId"] as? String ?? ""
        self.timestamp = dictionnary["text"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
}

struct Conversation {
    let user: User
    let message: Message
}
