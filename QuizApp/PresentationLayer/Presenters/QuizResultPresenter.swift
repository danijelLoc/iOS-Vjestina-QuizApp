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
    private var router:AppRouterProtocol!

    init(router: AppRouterProtocol, delegate:QuizResultViewDelegate, quizResult:QuizResult){
        self.delegate = delegate
        self.networkService = NetworkService.shared
        self.quizResult = quizResult
        self.router = router
    }
    
    func presentReturnToQuizzes(){
        DispatchQueue.main.async {
            self.router.returnToQuizzes()
        }
    }
    
    func sendResults(){
        self.networkService.sendResults(quizResult: self.quizResult) {  (result: Result<EmptyResponse, RequestError>) in
                switch result {
                case .failure(let error):
                    // show error
                    switch error {
                    case .serverError:
                        self.delegate.showReachabilityError()
                    default:
                        self.delegate.showFailedResultSending(error: error)
                    }
                case .success( _):
                    print("Results have been sent successfully.")
                }
            }
    }
}
