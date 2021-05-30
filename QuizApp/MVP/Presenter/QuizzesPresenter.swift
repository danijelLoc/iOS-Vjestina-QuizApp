//
//  QuizzesPresenter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 15.05.2021..
//

import Foundation


struct QuizzesResponse:Codable{
    let quizzes:[Quiz]
}

protocol QuizzesViewDelegate: AnyObject{
    func showQuizzes(categorisedQuizzes:[[Quiz]], factNumber:Int)
    func showNoQuizzes()
    func showErrorMessage(error:RequestError, desc: String)
    func showReachabilityError()
}

class QuizzesPresenter{
    weak var delegate:QuizzesViewDelegate!
    private var networkService:NetworkService!
    private var quizRepository:QuizRepository!
    private var router:AppRouterProtocol!
    
    init(quizzesViewDelegate:QuizzesViewDelegate, router: AppRouterProtocol) {
        self.delegate=quizzesViewDelegate
        self.networkService = NetworkService.shared
        self.quizRepository = router.getQuizRepository()
        self.router = router
    }
    
    func getQuizzes(){
        self.quizRepository.getQuizzes(presenter:self)
    }
    
    func getFilteredQuizzes(filterText:String?){
        self.quizRepository.getFilteredQuizzes(presenter: self, filterText: filterText)
    }
    
    func proccesAndShowQuizzes(allQuizzes: [Quiz]){
        var categories = Array(Set(allQuizzes.map({ (quiz) -> QuizCategory in
            quiz.category
        })))
        categories.sort {
            $0.rawValue > $1.rawValue
        }
        
        // categorise quizzes
        let categorisedQuizzes = categories.map { (quizCategory) -> [Quiz] in
            return allQuizzes.filter { (quiz) -> Bool in
                switch quiz.category{
                case quizCategory:
                    return true
                default:
                    return false
                }
            }
        }
        
        // get fun fact number
        var num = 0
        for quiz in allQuizzes{
            for question in quiz.questions{
                if question.question.contains("NBA") { num = num + 1 }
            }
        }
        let factNumber = num
        // show quizes if there is any
        self.delegate.showQuizzes(categorisedQuizzes: categorisedQuizzes, factNumber: factNumber)
    }
    
    
    func presentQuizScreen(selected_quiz: Quiz){
        router.showQuizScreen(quiz: selected_quiz)
    }
    
    
}
