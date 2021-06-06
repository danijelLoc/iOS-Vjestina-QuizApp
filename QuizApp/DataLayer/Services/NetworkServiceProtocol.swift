//
//  NetworkServiceProtocol.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 06.06.2021.
//

import Foundation

import Foundation
import Reachability

protocol NetworkServiceProtocol{
    func login(username: String, password: String, presenter:LoginPresenter, callback: @escaping (LoginResponse) -> Void)
    func sendResults(quizResult:QuizResult, completionHandler: @escaping (Result<EmptyResponse, RequestError>) -> Void)
    func getQuizzesAndPresent(presenter:QuizzesPresenter, completionHandler: @escaping (Result<QuizzesResponse, RequestError>) -> Void)
    func getQuizzes(completionHandler: @escaping (Result<QuizzesResponse, RequestError>) -> Void)
    func checkReachability() -> Bool
}
