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
    
    static func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        Firestore.firestore().collection("users").getDocuments { snapshot, error in
            snapshot?.documents.forEach({ document in
                let dictionary = document.data()
                let user = User(dictionnary: dictionary)
                
                users.append(user)
                completion(users)
            })
        }
    }
    
}
