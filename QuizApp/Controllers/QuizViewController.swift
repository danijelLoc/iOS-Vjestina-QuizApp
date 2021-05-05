//
//  QuizzesPageViewController.swift
//  QuizApp
//
//  Created by Five on 05.05.2021..
//

import Foundation
import UIKit

class QuizViewController: UIPageViewController {
    var controllers: [QuestionViewController] = []
    private var displayedIndex = 0
    private var router:AppRouterProtocol!
    var quiz:Quiz!
    private var correctAnswers = 0
    
    init(router: AppRouterProtocol, quiz: Quiz) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.router = router
        self.quiz = quiz
        self.createQuizViewControllers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .black
        
        setGradientBackground(size: view.frame.size)
        navigationItem.titleView = TitleLabel(title: "PopQuiz",size: 24)
        self.hidesBottomBarWhenPushed = true
        
        guard let firstVC = controllers.first else { return }
        //postavljanje boje indikatora stranice
        let pageAppearance = UIPageControl.appearance()
        pageAppearance.currentPageIndicatorTintColor = .black
        pageAppearance.pageIndicatorTintColor = .lightGray
        dataSource = nil
        setViewControllers([firstVC], direction: .forward, animated: true,completion: nil)
    }
    
    func createQuizViewControllers(){
        for i in 0..<quiz.questions.count{
            let qvc = QuestionViewController(router: router, question: quiz.questions[i],qvc: self, index: i)
            //qvc.view.backgroundColor = .clear
            controllers.append(qvc)
        }
    }
    
    func nextController(result:Bool){
        if result {
            correctAnswers += 1
        }
        print(displayedIndex)
        if displayedIndex < self.quiz.questions.count - 1 {
            displayedIndex += 1
            setViewControllers([controllers[displayedIndex]], direction: .forward, animated: true,completion: nil)
        }else{
            router.showResultScreen(result: QuizResult(correctAnswers: correctAnswers, numberOfQuestions: quiz.questions.count))
        }
    }

}
