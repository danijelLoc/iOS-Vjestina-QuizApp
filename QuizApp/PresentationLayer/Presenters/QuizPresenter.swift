//
//  QuizPresenter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 16.05.2021..
//

import Foundation

protocol QuizViewDelegate: AnyObject {
    func showNextQuestion(displayedIndex:Int, result:Bool)
    func showResults(displayedIndex:Int, questionResult:Bool, quizResult:QuizResult)
}

class QuizPresenter{
    
    weak var delegate:QuizViewDelegate!
    private var startDate:Date!
    private var quiz:Quiz!
    private var correctAnswers = 0
    private var displayedIndex = 0
    private var router:AppRouterProtocol!
    
    init(router: AppRouterProtocol, delegate:QuizViewDelegate,quiz:Quiz){
        self.delegate = delegate
        self.startDate = Date()
        self.quiz = quiz
        self.router = router
    }
    
    func nextQuestion(currentQuestionResult:Bool){
        if currentQuestionResult {
            correctAnswers += 1
        }
        if displayedIndex < quiz.questions.count - 1 {
            displayedIndex += 1
            self.delegate.showNextQuestion(displayedIndex:displayedIndex, result:currentQuestionResult)
        }else {
            let time:Double = Date().timeIntervalSince(self.startDate)
            let quizResult = QuizResult(quizId: quiz.id, correctAnswers: correctAnswers, numberOfQuestions: quiz.questions.count, time: time)
            self.delegate.showResults(displayedIndex: displayedIndex, questionResult: currentQuestionResult, quizResult: quizResult)
            DispatchQueue.main.async {
                self.router.showResultScreen(result: quizResult)
            }
        }
    }
    
    
}


