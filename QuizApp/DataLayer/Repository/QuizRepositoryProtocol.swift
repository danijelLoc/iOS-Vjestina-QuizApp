//
//  QuizRepositoryProtocol.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 06.06.2021..
//

import Foundation


protocol QuizRepositoryProtocol {
    func getQuizzes(presenter:QuizzesPresenter)
    func getFilteredQuizzes(presenter:QuizzesPresenter, filterText:String?)
    func sendResults(quizResult:QuizResult, completionHandler: @escaping (Result<EmptyResponse, RequestError>) -> Void)
}
