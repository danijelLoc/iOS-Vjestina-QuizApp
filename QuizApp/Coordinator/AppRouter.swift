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
        let defaults = UserDefaults.standard
        guard let _ = defaults.object(forKey: "user_id"),
              let _ = defaults.object(forKey: "user_token")
        else {
            // if user is not logged in
            let lvc = LoginViewController(router: self)
            let lp = LoginPresenter(delegate: lvc, router: self)
            lvc.setPresenter(presenter: lp)
            navigationController.pushViewController(lvc, animated: true)
            
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            return
        }
        // else skip login
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        quizzesControllerAsRootAndShow()
        return
    }
    
    
    func quizzesControllerAsRootAndShow(){
        let qvc = QuizzesViewController(router: self)
        let qp = QuizzesPresenter(quizzesViewDelegate: qvc, router: self)
        qvc.setPresenter(presenter: qp)
        let search = SearchViewController(router: self)
        let sqp = QuizzesPresenter(quizzesViewDelegate: search, router: self)
        search.setPresenter(presenter: sqp)
        let svc = SettingsViewController(router: self)
        let sp = SettingsPresenter(router: self, delegate: svc)
        svc.setPresenter(presenter: sp)
        
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
        let qp = QuizPresenter(router: self, delegate: qc, quiz: quiz)
        qc.setPresenter(presenter: qp)
        self.navigationController?.pushViewController(qc, animated: true)
    }
    
    
    func returnToQuizzes(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func showResultScreen(result:QuizResult){
        let rvc = QuizResultViewController(router: self, result: result)
        let rp = QuizResultPresenter(router: self, delegate: rvc, quizResult: result)
        rvc.setPresenter(presenter: rp)
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    
    
    func logOut() {
        let lvc = LoginViewController(router: self)
        let lp = LoginPresenter(delegate: lvc, router: self)
        lvc.setPresenter(presenter: lp)
        self.navigationController?.setViewControllers([lvc], animated: true)
    }
    
    
    func getCoreDataContext() -> NSManagedObjectContext {
        return self.coreDataContext
    }
    
    
    func getQuizRepository() -> QuizRepository {
        return self.quizRepository
    }
    
}
