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
        self.networkService = NetworkService.shared
        self.quizResult = quizResult
    }
    
    
    func sendResults(){
        self.networkService.sendResults(quizResult: self.quizResult, presenter: self) {  (result: Result<EmptyResponse, RequestError>) in
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
