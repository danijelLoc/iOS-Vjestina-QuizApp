//
//  SettingsPresenter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 16.05.2021..
//

import Foundation

protocol SettingsViewDelegate: AnyObject {
    func showLogOut()
}

class SettingsPresenter{
    
    weak var delegate:SettingsViewDelegate!
    
    init(delegate:SettingsViewDelegate){
        self.delegate = delegate
    }
    
    func logOut(){
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "user_id")
        defaults.removeObject(forKey: "user_token")
        self.delegate.showLogOut()
    }
    
}
