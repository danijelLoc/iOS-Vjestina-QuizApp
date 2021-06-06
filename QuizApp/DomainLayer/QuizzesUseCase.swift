//
//  QuizzesUseCase.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 06.06.2021..
//

import Foundation

protocol QuizzesUseCaseProtocol {
    func getQuizzes(presenter:QuizzesPresenter)
    func getFilteredQuizzes(presenter:QuizzesPresenter, filterText:String?)
    func sendResults(quizResult:QuizResult, completionHandler: @escaping (Result<EmptyResponse, RequestError>) -> Void)
}

class QuizzesUseCase: QuizzesUseCaseProtocol {
    
    let quizRepository:QuizRepositoryProtocol!
    
    init() {
        let coreDataContext = CoreDataStack.shared.managedContext
        let quizDatabaseSource = QuizDatabaseDataSource(coreDataContext:coreDataContext)
        let quizNetworkSource = QuizNetworkDataSource()
        self.quizRepository = QuizRepository(quizDatabaseSource: quizDatabaseSource, quizNetworkSource: quizNetworkSource)
    }
    
    func getQuizzes(presenter: QuizzesPresenter) {
        self.quizRepository.getQuizzes(presenter: presenter)
    }
    
    func getFilteredQuizzes(presenter: QuizzesPresenter, filterText: String?) {
        self.quizRepository.getFilteredQuizzes(presenter: presenter, filterText: filterText)
    }
    
    func sendResults(quizResult: QuizResult, completionHandler: @escaping (Result<EmptyResponse, RequestError>) -> Void) {
        self.quizRepository.sendResults(quizResult: quizResult, completionHandler: completionHandler) 
    }
    
}
