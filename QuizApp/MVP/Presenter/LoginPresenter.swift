//
//  LoginPresenter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 15.05.2021..
//

import Foundation
import Reachability

struct LoginResponse:Codable{
    let token:String
    let userId:Int
    
    enum CodingKeys: String, CodingKey {
        case token
        case userId = "user_id"
    }
}

protocol LoginViewDelegate: AnyObject {
    func showGoodLogin()
    func showLoginError(error:RequestError)
    func showReachabilityError()
    // bad input, no need for alert, only mark input fileds
    func showLoginClientError()

    func hidePassword(existingText:String)
    func showPassword()
}

class LoginPresenter{
    weak var delegate:LoginViewDelegate!
    var networkService:NetworkServiceProtocol!
    
    
    init(delegate:LoginViewDelegate){
        self.delegate = delegate
        self.networkService = NetworkService()
    }
    
    func login(username: String, password: String) {
        self.networkService.login(username: username, password: password, presenter: self) {loginResponse  in
            let defaults = UserDefaults.standard
            defaults.set(loginResponse.userId, forKey: "user_id")
            defaults.set(loginResponse.token, forKey: "user_token")
            print("username:\(username), password:\(password),\nuserId:\(loginResponse.userId), token:\(loginResponse.token)")
            self.delegate.showGoodLogin()
        }
    }
    
    func togglePassword(isSecureTextEntry:Bool,text:String?){
        let newIsSecureTextEntry = !isSecureTextEntry
        
        if let existingText = text, newIsSecureTextEntry {
            delegate.hidePassword(existingText: existingText)
        }else{
            delegate.showPassword()
        }
    }
    

}
