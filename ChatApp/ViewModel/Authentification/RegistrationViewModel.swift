//
//  RegistrationViewModel.swift
//  ChatApp
//
//  Created by Jérémy Perez on 14/08/2023.
//

import Foundation

struct RegistrationViewModel: AuthentificationProtocol {
    var email: String?
    var password: String?
    var fullname: String?
    var username: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false && password?.isEmpty == false && fullname?.isEmpty == false && username?.isEmpty == false
    }
}
