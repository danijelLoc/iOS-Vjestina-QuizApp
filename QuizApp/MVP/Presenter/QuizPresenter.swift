//
//  QuizPresenter.swift
//  QuizApp
//
//  Created by Five on 16.05.2021..
//

import Foundation

struct EmptyResponse:Decodable{}

protocol QuizViewDelegate: AnyObject {
    func presentFailedResultSending(error:RequestError)
    func presentNextQuestion(displayedIndex:Int, result:Bool)
    func presentResults(displayedIndex:Int, result:Bool, correctAnswers:Int)
    func presentReachabilityError()
}

class QuizPresenter{
    
    weak var delegate:QuizViewDelegate!
    var networkService:NetworkService!
    private var startDate:Date!
    private var quiz:Quiz!
    private var correctAnswers = 0
    private var displayedIndex = 0
    
    init(delegate:QuizViewDelegate,quiz:Quiz){
        self.delegate = delegate
        self.networkService = NetworkService()
        startDate = Date()
        self.quiz = quiz
    }
    
    func nextQusetion(currentQuestionResult:Bool){
        if currentQuestionResult {
            correctAnswers += 1
        }
        if displayedIndex < quiz.questions.count - 1 {
            displayedIndex += 1
            self.delegate.presentNextQuestion(displayedIndex:displayedIndex, result:currentQuestionResult)
        }else {
            self.delegate.presentResults(displayedIndex:displayedIndex, result:currentQuestionResult, correctAnswers:correctAnswers)
            sendResults(quizId: quiz.id, correctAnswers: correctAnswers)
        }
    }
    
    func sendResultsAgain(){
        sendResults(quizId: quiz.id, correctAnswers: correctAnswers)
    }
    
    
    func sendResults(quizId:Int,correctAnswers:Int){
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.networkService.checkReachability(){
                self.delegate.presentReachabilityError()
                return
            }
            
            
            let url = URL(string: "https://iosquiz.herokuapp.com/api/result")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            
            let timeInSeconds:Double = Date().timeIntervalSince(self.startDate)
            let defaults = UserDefaults.standard
            let json: [String: Any] = ["quiz_id": quizId,
                                       "user_id": defaults.integer(forKey: "user_id"),
                                       "time": timeInSeconds,
                                       "no_of_correct": correctAnswers]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue( defaults.string(forKey: "user_token"), forHTTPHeaderField: "Authorization")
            
            
            self.networkService.executeUrlRequest(request) { (result: Result<EmptyResponse, RequestError>) in
                switch result {
                case .failure(let error):
                    // show error
                    self.delegate.presentFailedResultSending(error: error)
                case .success( _):
                    print("Results have been sent successfully.")
                }
            }
        }
    }
}


