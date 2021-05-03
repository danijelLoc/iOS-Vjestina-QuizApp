//
//  AppRouter.swift
//  QuizApp
//
//  Created by Five on 02.05.2021..
//

import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func quizzesControllerAsRootAndShow()
    func showQuizScreen(quiz:Quiz)
    func returnToQuizzes()
}

class AppRouter: AppRouterProtocol {
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func setStartScreen(in window: UIWindow?) {
        let qvc = QuizzesViewController(router: self)
        let lvc = LoginViewController(router: self)
        navigationController.pushViewController(qvc, animated: false)
        navigationController.pushViewController(lvc, animated: false)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        let aaaa = 3;
        // REVERT TO lvc ############
        // ##########################
        // ######################remove
        navigationController.popToRootViewController(animated: false)
    }
    
    func quizzesControllerAsRootAndShow(){
        navigationController.popToRootViewController(animated: false)
    }
    
    func showQuizScreen(quiz:Quiz) {
        let qc = QuizViewController(router: self, quiz: quiz)
        self.navigationController?.pushViewController(qc, animated: true)
    }
    
    func returnToQuizzes(){
        self.navigationController?.popToRootViewController(animated: true)
    }
}
