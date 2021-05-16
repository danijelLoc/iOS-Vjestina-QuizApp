//
//  QuizzesPageViewController.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 05.05.2021..
//

import Foundation
import UIKit

class QuizViewController: UIPageViewController, QuizViewDelegate {

    
    private var controllers: [QuestionViewController] = []
    private var router:AppRouterProtocol!
    private var quiz:Quiz!
    
    private var questionTrackerView:QuestionTrackerView!
    private var quizPresenter:QuizPresenter!
    
    init(router: AppRouterProtocol, quiz: Quiz) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.router = router
        self.quiz = quiz
        self.createQuizViewControllers()
        self.quizPresenter = QuizPresenter(delegate: self,quiz: self.quiz)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionTrackerView = QuestionTrackerView()
        questionTrackerView.setDimensions(numberOfQuestions: quiz.questions.count)
        view.addSubview(questionTrackerView)
        
        setGradientBackground(size: view.frame.size)
        navigationItem.titleView = TitleLabel(title: "PopQuiz",size: 24)
        self.hidesBottomBarWhenPushed = true
        
        guard let firstVC = controllers.first else { return }
        dataSource = nil
        setViewControllers([firstVC], direction: .forward, animated: true,completion: nil)
        
        self.setConstraints()
    }
    
    func createQuizViewControllers(){
        for i in 0..<quiz.questions.count{
            let qvc = QuestionViewController(router: router, question: quiz.questions[i],qvc: self)
            //qvc.view.backgroundColor = .clear
            controllers.append(qvc)
        }
    }
    
    func setConstraints(){
        let safeArea = self.view.safeAreaLayoutGuide
        questionTrackerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            questionTrackerView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            questionTrackerView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            questionTrackerView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -30)
        ])
    }
    
    func nextController(result:Bool){
        quizPresenter.nextQuestion(currentQuestionResult: result)
    }
    
    func showNextQuestion(displayedIndex:Int, result:Bool){
        setViewControllers([controllers[displayedIndex]], direction: .forward, animated: true,completion: nil)
        questionTrackerView.updateProgress(correctlyAnswered: result, nextIndex: displayedIndex)
    }
    
    func showResults(displayedIndex:Int, questionResult:Bool, quizResult:QuizResult){
        DispatchQueue.main.async {
            self.questionTrackerView.updateProgress(correctlyAnswered: questionResult, nextIndex: displayedIndex+1)
            self.router.showResultScreen(result: quizResult)
        }
    }
    


}
