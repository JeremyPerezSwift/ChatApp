//
//  Service.swift
//  ChatApp
//
//  Created by Jérémy Perez on 29/08/2023.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Service {
    
    // MARK: - Fetch
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        COLLECTION_USERS.getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionnary: dictionary)
                
                users.append(user)
                completion(users)
            })
        }
    }
    
    static func fetchUser(withUid uid: String ,completion: @escaping(User) -> Void) {
        COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            guard let dictionnary = snapshot?.data() else { return }
            
            let user = User(dictionnary: dictionnary)
            completion(user)
        }
    }
    
    static func fetchMessages(forUser user: User, completion: @escaping([Message]) -> Void) {
        var messages = [Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(currentUid).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionnary = change.document.data()
                    messages.append(Message(dictionnary: dictionnary))
                    completion(messages)
                }
            })
        }
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void) {
        var conversations = [Conversation]()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                let dictionnary = change.document.data()
                let message = Message(dictionnary: dictionnary)
                
                self.fetchUser(withUid: message.toId) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }

    }
    
    
    // MARK: - Upload
    
    static func uploadMessage(_ message: String, to user: User, completion: ((Error?) -> Void)?) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        let data = ["text": message, "fromId": currentUid, "toId": user.uid, "timestamp": Timestamp(date: Date())] as [String: Any]
        
        COLLECTION_MESSAGES.document(currentUid).collection(user.uid).addDocument(data: data) { error in
            COLLECTION_MESSAGES.document(user.uid).collection(currentUid).addDocument(data: data, completion: completion)
            
            COLLECTION_MESSAGES.document(currentUid).collection("recent-messages").document(user.uid).setData(data)
            COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUid).setData(data)
        }
    }
}
