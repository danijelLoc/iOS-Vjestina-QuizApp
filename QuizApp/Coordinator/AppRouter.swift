//
//  AppRouter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 02.05.2021..
//

import Foundation
import UIKit
import CoreData

protocol AppRouterProtocol: UINavigationControllerDelegate {
    func getCoreDataContext() -> NSManagedObjectContext
    func getQuizRepository() -> QuizRepository
    
    func setStartScreen(in window: UIWindow?)
    func quizzesControllerAsRootAndShow()
    func showQuizScreen(quiz:Quiz)
    func returnToQuizzes()
    func showResultScreen(result: QuizResult)
    func logOut()
}


class AppRouter: NSObject, AppRouterProtocol, UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate {
    
    
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
        self.navigationController?.delegate = self
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
        self.navigationController?.setViewControllers([lvc], animated: false)
    }
    
    
    func getCoreDataContext() -> NSManagedObjectContext {
        return self.coreDataContext
    }
    
    
    func getQuizRepository() -> QuizRepository {
        return self.quizRepository
    }
    
}


extension AppRouter{
    func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC is LoginViewController && toVC is UITabBarController {
            return self
        }else{
            return nil
        }
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval.init(0)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromVc = transitionContext
        .viewController(forKey: .from) as? LoginViewController,
           let toVc = transitionContext
        .viewController(forKey: .to) as? UITabBarController
        {
            animateOut(fromVc: fromVc, toVc: toVc, in: transitionContext)
        }else {
            return
        }
    }
    
    func animateOut(fromVc: LoginViewController, toVc: UITabBarController, in context: UIViewControllerContextTransitioning){
        
        fromVc.animateOut(){ _ in
            // set new view
            fromVc.view.removeFromSuperview()
            context.containerView.addSubview(toVc.view)
//            self.navigationController.setViewControllers([toVc], animated: false)
            context.completeTransition(true)
        }
    }
    
    
}
