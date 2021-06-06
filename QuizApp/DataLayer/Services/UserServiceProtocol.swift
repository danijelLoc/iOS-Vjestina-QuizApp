//
//  UserServiceProtocol.swift
//  QuizApp
//
//  Created by Five on 06.06.2021..
//

import Foundation

struct LoginResponse:Codable{
    let token:String
    let userId:Int
    
    enum CodingKeys: String, CodingKey {
        case token
        case userId = "user_id"
    }
}


protocol UserServiceProtocol {
    
    func setUser(loginResponse:LoginResponse)
    func removeUser()
    func getUserData() -> LoginResponse?
}
