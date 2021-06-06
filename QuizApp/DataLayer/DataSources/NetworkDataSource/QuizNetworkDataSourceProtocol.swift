//
//  QuizNetworkDataSourceProtocol.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 06.06.2021..
//

import Foundation

protocol QuizNetworkDataSourceProtocol {
    func getQuizzes(completionHandler: @escaping (Result<QuizzesResponse, RequestError>) -> Void)
    func checkReachability() -> Bool
    func sendResults(quizResult:QuizResult, completionHandler: @escaping (Result<EmptyResponse, RequestError>) -> Void)
}
