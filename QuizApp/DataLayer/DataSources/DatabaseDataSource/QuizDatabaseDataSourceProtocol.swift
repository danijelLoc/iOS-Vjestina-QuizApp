//
//  QuizDatabaseDataSourceProtocol.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 06.06.2021..
//

import Foundation


protocol QuizDatabaseDataSourceProtocol {
    func fetchQuizzesFromCoreData(filter: FilterSettings) -> [Quiz]
    func saveNewQuizzes(_ quizzes: [Quiz], imagesDictionary:[Int:Data?])
    func deleteQuiz(withId id: Int)
    func deleteAllQuizzesExcept(withId ids: [Int]) throws
    func deleteAllQuizzes() throws
}
