//
//  AppRouter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 02.05.2021..
//

import Foundation
import UIKit
import CoreData

protocol AppRouterProtocol {
    func getCoreDataContext() -> NSManagedObjectContext
    func getQuizRepository() -> QuizRepository
    
    func setStartScreen(in window: UIWindow?)
    func quizzesControllerAsRootAndShow()
    func showQuizScreen(quiz:Quiz)
    func returnToQuizzes()
    func showResultScreen(result: QuizResult)
    func logOut()
}


class AppRouter: AppRouterProtocol {
    
    private let navigationController: UINavigationController!
    public let coreDataContext: NSManagedObjectContext!
    public let quizRepository: QuizRepository!
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.coreDataContext = CoreDataStack.shared.managedContext
        let quizDatabaseSource = QuizDatabaseDataSource(coreDataContext: self.coreDataContext)
        let quizNetworkSource = QuizNetworkDataSource()
        self.quizRepository = QuizRepository(quizDatabaseSource: quizDatabaseSource, quizNetworkSource: quizNetworkSource)
    }
    
    
    func setStartScreen(in window: UIWindow?) {
        let lvc = LoginViewController(router: self)
        navigationController.pushViewController(lvc, animated: true)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    
    func quizzesControllerAsRootAndShow(){
        let qvc = QuizzesViewController(router: self)
        let search = SearchViewController(router: self)
        let svc = SettingsViewController(router: self)
        
        // tabBar
        qvc.tabBarItem = UITabBarItem(title: "Quiz", image: UIImage(named:"Clock"), selectedImage: UIImage(named: "ClockSelected"))
        search.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named:"Search"), selectedImage: UIImage(named:"SearchSelected"))
        svc.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(named:"Settings"), selectedImage: UIImage(named:"SettingsSelected"))
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [qvc,search,svc]
        tabBarController.tabBar.tintColor = backgroundColorDarker
        tabBarController.tabBar.barTintColor = .white
        
        navigationController.setViewControllers([tabBarController], animated: true)
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
    
    
    func logOut() {
        let lvc = LoginViewController(router: self)
        self.navigationController?.setViewControllers([lvc], animated: true)
    }
    
    
    func getCoreDataContext() -> NSManagedObjectContext {
        return self.coreDataContext
    }
    
    
    func getQuizRepository() -> QuizRepository {
        return self.quizRepository
    }
    
}
