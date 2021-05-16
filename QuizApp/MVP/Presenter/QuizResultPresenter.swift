//
//  QuizResultPresenter.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 16.05.2021..
//

import Foundation

struct EmptyResponse:Decodable{}

protocol QuizResultViewDelegate: AnyObject {
    func showReachabilityError()
    func showFailedResultSending(error:RequestError)
}

class QuizResultPresenter{
    
    weak var delegate:QuizResultViewDelegate!
    var networkService:NetworkService!
    private var quizResult:QuizResult!

    init(delegate:QuizResultViewDelegate,quizResult:QuizResult){
        self.delegate = delegate
        self.networkService = NetworkService()
        self.quizResult = quizResult
    }
    
    func sendResultsAgain(){
        sendResults(quizId: quizResult.quizId, correctAnswers: quizResult.correctAnswers)
    }
    
    
    func sendResults(quizId:Int,correctAnswers:Int){
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.networkService.checkReachability(){
                self.delegate.showReachabilityError()
                return
            }
            
            
            let url = URL(string: "https://iosquiz.herokuapp.com/api/result")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            
            let defaults = UserDefaults.standard
            let json: [String: Any] = ["quiz_id": quizId,
                                       "user_id": defaults.integer(forKey: "user_id"),
                                       "time": self.quizResult.time,
                                       "no_of_correct": correctAnswers]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue( defaults.string(forKey: "user_token"), forHTTPHeaderField: "Authorization")
            
            
            self.networkService.executeUrlRequest(request) { (result: Result<EmptyResponse, RequestError>) in
                switch result {
                case .failure(let error):
                    // show error
                    self.delegate.showFailedResultSending(error: error)
                case .success( _):
                    print("Results have been sent successfully.")
                }
            }
        }
    }
}
