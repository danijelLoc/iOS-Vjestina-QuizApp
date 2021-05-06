//
//  AppRouter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 02.05.2021..
//

import Foundation
import UIKit

protocol AppRouterProtocol {
    func setStartScreen(in window: UIWindow?)
    func quizzesControllerAsRootAndShow(in window: UIWindow?)
    func showQuizScreen(quiz:Quiz)
    func returnToQuizzes()
    func showResultScreen(result: QuizResult)
    func logOut(in window: UIWindow?)
}

class AppRouter: AppRouterProtocol {
    
    private let navigationController: UINavigationController!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func setStartScreen(in window: UIWindow?) {
        let lvc = LoginViewController(router: self)
        navigationController.pushViewController(lvc, animated: true)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    
    func showQuizzes(in window: UIWindow?){
        let qvc = QuizzesViewController(router: self)
        let svc = SettingsViewController(router: self)
        
        // tabBar
        qvc.tabBarItem = UITabBarItem(title: "Quiz", image: UIImage(named:"Clock"), selectedImage: UIImage(named: "ClockSelected"))
        svc.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named:"Settings"), selectedImage: UIImage(named:"SettingsSelected"))
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [qvc,svc]
        tabBarController.tabBar.tintColor = backgroundColorDarker
        tabBarController.tabBar.barTintColor = .white
        navigationController.pushViewController(tabBarController, animated: true)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    
    func quizzesControllerAsRootAndShow(in window: UIWindow?){
        let newNavigationController = UINavigationController()
        let newAppRouter = AppRouter(navigationController: newNavigationController)
        newAppRouter.showQuizzes(in: window)
    }
    
    
    func showQuizScreen(quiz:Quiz) {
        let qc = QuizViewController(router: self, quiz: quiz)
        self.navigationController?.pushViewController(qc, animated: true)
    }
    
    
    func returnToQuizzes(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func showResultScreen(result:QuizResult){
        let rvc = QuizResultViewController(router: self, result: result)
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    
    
    func logOut(in window: UIWindow?) {
        let navigationController = UINavigationController()
        let appRouter = AppRouter(navigationController: navigationController)
        appRouter.setStartScreen(in: window)
    }
}
