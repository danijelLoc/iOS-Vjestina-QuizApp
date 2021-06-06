//
//  QuizNetworkDataSource.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 28.05.2021..
//

import Foundation


class QuizNetworkDataSource : QuizNetworkDataSourceProtocol {
    
    let networkService = NetworkService.shared
    
    func getQuizzes(completionHandler: @escaping (Result<QuizzesResponse, RequestError>) -> Void){
        self.networkService.getQuizzes(completionHandler: completionHandler)
    }
    
    func checkReachability() -> Bool {
        return self.networkService.checkReachability()
    }
    
    func sendResults(quizResult: QuizResult, completionHandler: @escaping (Result<EmptyResponse, RequestError>) -> Void) {
        self.networkService.sendResults(quizResult: quizResult, completionHandler: completionHandler)
    }
}
