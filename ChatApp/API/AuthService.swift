//
//  AuthService.swift
//  ChatApp
//
//  Created by Jérémy Perez on 28/08/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

struct RegistrationCredentitals {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    
    static let shared = AuthService()
    
    func logUserIn(email: String, password: String, completion: @escaping ((AuthDataResult?, Error?) -> Void)) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUSer(credentials: RegistrationCredentitals, completion: ((Error?) -> Void)?) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        ref.putData(imageData) { meta, errorImageData in
            if let error = errorImageData {
                print("DEBUg: Failed to upload image with error \(error.localizedDescription)")
                completion!(error)
                return
            }
            
            ref.downloadURL { url, errorUrl in
                guard let profileImageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, errorCreateUser in
                    if let error = errorCreateUser {
                        print("DEBUg: Failed to create user with error \(error.localizedDescription)")
                        completion!(error)
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let data = ["email": credentials.email, "fullname": credentials.fullname, "username": credentials.username, "profileImageUrl": profileImageUrl, "uid": uid] as [String: Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                    
                    Firestore.firestore().collection("users").document(uid).setData(data) { errorFsUser in
                        
                        if let error = errorFsUser {
                            print("DEBUg: Failed to upload user data with error \(error.localizedDescription)")
                            completion!(error)
                            return
                        }
                        
                        print("DEBUG: Did create user...")
//                        self.dismiss(animated: true)
                    }
                    
                }
            }
        }
    }
    
}
