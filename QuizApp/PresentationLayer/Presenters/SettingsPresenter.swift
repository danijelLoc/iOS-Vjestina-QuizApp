//
//  SettingsPresenter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 16.05.2021..
//

import Foundation

protocol SettingsViewDelegate: AnyObject {
}

class SettingsPresenter{
    
    weak var delegate: SettingsViewDelegate!
    private var router: AppRouterProtocol!
    private let userUseCase:UserUseCaseProtocol = UserUseCase()
    
    init(router: AppRouterProtocol, delegate:SettingsViewDelegate){
        self.delegate = delegate
        self.router = router
    }
    
    func logOut(){
        userUseCase.removeUser()
        DispatchQueue.main.async {
            self.router.logOut()
        }
    }
    
}
