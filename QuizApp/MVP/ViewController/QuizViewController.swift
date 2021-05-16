//
//  QuizzesPageViewController.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 05.05.2021..
//

import Foundation
import UIKit

class QuizViewController: UIPageViewController,QuizViewDelegate {
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
            let qvc = QuestionViewController(router: router, question: quiz.questions[i],qvc: self, index: i)
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
        quizPresenter.nextQusetion(currentQuestionResult: result)
    }
    
    func presentNextQuestion(displayedIndex:Int, result:Bool){
        setViewControllers([controllers[displayedIndex]], direction: .forward, animated: true,completion: nil)
        questionTrackerView.updateProgress(correctlyAnswered: result, nextIndex: displayedIndex)
    }
    
    func presentResults(displayedIndex:Int, result:Bool, correctAnswers:Int){
        DispatchQueue.main.async {
            self.questionTrackerView.updateProgress(correctlyAnswered: result, nextIndex: displayedIndex+1)
            self.router.showResultScreen(result: QuizResult(correctAnswers: correctAnswers, numberOfQuestions: self.quiz.questions.count))
        }
    }
    
    func presentFailedResultSending(error:RequestError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error Code: \(error.rawValue)", message: "Cant send results, \(error)", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert,animated: true)
        }
    }
    
    func presentReachabilityError(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "No connection", message: "Cannot send results. The Internet connection appears to be offline.", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (UIAlertAction) in
                self.quizPresenter.sendResultsAgain()
            }))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert,animated: true)
        }
    }

}
