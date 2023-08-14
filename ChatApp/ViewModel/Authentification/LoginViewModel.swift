//
//  LoginViewModel.swift
//  ChatApp
//
//  Created by Jérémy Perez on 14/08/2023.
//

import Foundation

protocol AuthentificationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthentificationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false
    }
}
