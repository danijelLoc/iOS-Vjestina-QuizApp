//
//  QuizzesPresenter.swift
//  QuizApp
//
//  Created by Five on 15.05.2021..
//

import Foundation


struct QuizzesResponse:Codable{
    let quizzes:[Quiz]
}

protocol QuizzesViewDelegate: AnyObject{
    func showQuizzes(categorisedQuizzes:[[Quiz]], factNumber:Int)
    func showNoQuizzes()
    func showErrorMessage()
}

class QuizzesPresenter{
    weak var delegate:QuizzesViewDelegate!
    private var networkService:NetworkService!
    
    init(quizzesViewDelegate:QuizzesViewDelegate) {
        self.delegate=quizzesViewDelegate
        self.networkService = NetworkService()
    }
    
    func getQuizzes(){
        DispatchQueue.global(qos: .userInitiated).async {
            let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            self.networkService.executeUrlRequest(request) { (result: Result<QuizzesResponse, RequestError>) in
                switch result {
                    case .failure(_):
                        // show error on delegate
                        self.delegate.showNoQuizzes()
                        self.delegate.showErrorMessage()
                    case .success(let value):
                        if value.quizzes.count == 0 {
                            self.delegate.showNoQuizzes()
                        }else{
                            self.proccesAndShowQuizzes(allQuizzes: value.quizzes)
                        }
                }
                }
            }
    }
    func proccesAndShowQuizzes(allQuizzes: [Quiz]){
        let categories = [QuizCategory.sport,QuizCategory.science]
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
}
