//
//  UserService.swift
//  QuizApp
//
//  Created by Five on 06.06.2021..
//

import Foundation

class UserService : UserServiceProtocol {
    
    static let shared = UserService()
    
    func setUser(loginResponse: LoginResponse) {
        let defaults = UserDefaults.standard
        defaults.set(loginResponse.userId, forKey: "user_id")
        defaults.set(loginResponse.token, forKey: "user_token")
    }
    
    func removeUser() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "user_id")
        defaults.removeObject(forKey: "user_token")
    }
    
    func getUserData() -> LoginResponse? {
        let defaults = UserDefaults.standard
        guard let user_id = defaults.object(forKey: "user_id"),
              let user_token = defaults.object(forKey: "user_token")
        else{
            return nil
        }
        return LoginResponse(token: user_token as! String, userId: user_id as! Int)
    }
    
    
}
