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
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.networkService.checkReachability(){
                self.delegate.showReachabilityError()
                return
            }
            
            let url = URL(string: "https://iosquiz.herokuapp.com/api/session?username=\(username)&password=\(password)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            self.networkService.executeUrlRequest(request) { (result: Result<LoginResponse, RequestError>) in
                switch result {
                    case .failure(let error):
                        switch error {
                        case .clientError:
                            self.delegate.showLoginClientError()
                        default:
                            self.delegate.showLoginError(error:error)
                        }
                    case .success(let value):
                        let defaults = UserDefaults.standard
                        defaults.set(value.userId, forKey: "user_id")
                        defaults.set(value.token, forKey: "user_token")
                        print("username:\(username), password:\(password),\nuserId:\(value.userId), token:\(value.token)")
                        self.delegate.showGoodLogin()
                }
            }
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
