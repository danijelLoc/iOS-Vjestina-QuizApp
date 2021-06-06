//
//  UserUseCase.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 06.06.2021..
//

import Foundation

protocol UserUseCaseProtocol {
    func login(username: String, password: String, presenter:LoginPresenter, callback: @escaping (LoginResponse) -> Void)
    func setUser(loginResponse:LoginResponse)
    func removeUser()
    func getUserData() -> LoginResponse?
}

class UserUseCase: UserUseCaseProtocol {
    
    let networkService:NetworkServiceProtocol = NetworkService.shared
    let userServiceProtocol = UserService.shared
    
    func login(username: String, password: String, presenter: LoginPresenter, callback: @escaping (LoginResponse) -> Void) {
        networkService.login(username: username, password: password, presenter: presenter, callback: callback)
    }
    
    func setUser(loginResponse: LoginResponse) {
        userServiceProtocol.setUser(loginResponse: loginResponse)
    }
    
    func removeUser() {
        userServiceProtocol.removeUser()
    }
    
    func getUserData() -> LoginResponse? {
        return userServiceProtocol.getUserData()
    }
    
}
