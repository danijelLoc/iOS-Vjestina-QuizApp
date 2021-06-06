//
//  QuestionPresenter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 15.05.2021..
//

import Foundation

protocol QuestionViewDelegate: AnyObject {
    
    func disableInteraciton()
    func showCorrectAnswer(selectedIndex:Int)
    func showWrongAnswer(correctIndex:Int, wrongIndex:Int)
    func showNextQuestion(result:Bool)
}

class QuestionPresenter{
    
    weak var delegate: QuestionViewDelegate!
    private var router: AppRouterProtocol!
    
    init(delegate: QuestionViewDelegate, router: AppRouterProtocol){
        self.delegate = delegate
        self.router = router
    }
    
    func handleAnsweredQuestion(selectedIndex: Int, correctIndex:Int){
        self.delegate.disableInteraciton()
        if correctIndex == selectedIndex {
            self.delegate.showCorrectAnswer(selectedIndex: selectedIndex)
        }else{
            self.delegate.showWrongAnswer(correctIndex: correctIndex, wrongIndex: selectedIndex)
        }
        self.delegate.showNextQuestion(result: correctIndex==selectedIndex)
    }
}
