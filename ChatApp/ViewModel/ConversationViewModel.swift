//
//  ConversationViewModel.swift
//  ChatApp
//
//  Created by Jérémy Perez on 05/09/2023.
//

import Foundation

struct ConversationViewModel {
    
    private let conversation: Conversation
    
    var profileImageURL: URL? {
        let user = conversation.user
        return URL(string: user.profileImageUrl)
    }
    
    var timestamp: String {
        let date = conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
    
}
