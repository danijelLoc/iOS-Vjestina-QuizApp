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
    
    init(router: AppRouterProtocol, delegate:SettingsViewDelegate){
        self.delegate = delegate
        self.router = router
    }
    
    func logOut(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "user_id")
        defaults.removeObject(forKey: "user_token")
        router.logOut()
    }
    
}
