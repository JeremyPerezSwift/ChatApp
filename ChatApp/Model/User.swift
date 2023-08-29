//
//  User.swift
//  ChatApp
//
//  Created by Jérémy Perez on 29/08/2023.
//

import Foundation

struct User {
    let uid: String
    let profileImageUrl: String
    let username: String
    let fullname: String
    let email: String
    
    init(dictionnary: [String: Any]) {
        self.uid = dictionnary["uid"] as? String ?? ""
        self.profileImageUrl = dictionnary["profileImageUrl"] as? String ?? ""
        self.username = dictionnary["username"] as? String ?? ""
        self.fullname = dictionnary["fullname"] as? String ?? ""
        self.email = dictionnary["email"] as? String ?? ""
    }
}
