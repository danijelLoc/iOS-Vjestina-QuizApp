//
//  LoginPresenter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 15.05.2021..
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

protocol LoginViewDelegate: AnyObject {
    func presentGoodLogin()
    func presentLoginError(error:RequestError)
    // bad input, no need for alert
    func presentLoginClientError()
    
    func hidePassword(existingText:String)
    func showPassword()
}

class LoginPresenter{
    weak var delegate:LoginViewDelegate!
    var networkService:NetworkService!
    
    init(delegate:LoginViewDelegate){
        self.delegate = delegate
        self.networkService = NetworkService()
    }
    
    func login(username: String, password: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: "https://iosquiz.herokuapp.com/api/session?username=\(username)&password=\(password)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            self.networkService.executeUrlRequest(request) { (result: Result<LoginResponse, RequestError>) in
                switch result {
                    case .failure(let error):
                        switch error {
                        case .clientError:
                            self.delegate.presentLoginClientError()
                        default:
                            self.delegate.presentLoginError(error:error)
                        }
                    case .success(let value):
                        let defaults = UserDefaults.standard
                        defaults.set(value.userId, forKey: "user_id")
                        defaults.set(value.token, forKey: "user_token")
                        print(value)
                        self.delegate.presentGoodLogin()
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
