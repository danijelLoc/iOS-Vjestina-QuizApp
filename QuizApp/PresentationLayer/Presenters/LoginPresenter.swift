//
//  LoginPresenter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 15.05.2021..
//

import Foundation
import Reachability



protocol LoginViewDelegate: AnyObject {
    func showLoginError(error:RequestError)
    func showReachabilityError()
    // bad input, no need for alert, only mark input fileds
    func showLoginClientError()

    func hidePassword(existingText:String)
    func showPassword()
}

class LoginPresenter{
    weak var delegate:LoginViewDelegate!
    private var userUseCase: UserUseCaseProtocol!
    private var router: AppRouterProtocol!
    
    init(delegate:LoginViewDelegate, router: AppRouterProtocol){
        self.delegate = delegate
        self.userUseCase = UserUseCase()
        self.router = router
    }
    
    func login(username: String, password: String) {
        self.userUseCase.login(username: username, password: password, presenter: self) {loginResponse  in
            self.userUseCase.setUser(loginResponse: loginResponse)
            print("username:\(username), password:\(password),\nuserId:\(loginResponse.userId), token:\(loginResponse.token)")
            self.presentGoodLogin()
        }
    }
    
    func presentGoodLogin(){
        DispatchQueue.main.async {
            self.router.quizzesControllerAsRootAndShow()
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
    
    func isUserLoggedId() -> Bool{
        let data = userUseCase.getUserData()
        return data == nil ? false : true
    }
    

}
