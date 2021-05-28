//
//  QuizRepository.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 28.05.2021..
//

import Foundation

class QuizRepository{
    private let quizDatabaseSourece:QuizDatabaseDataSource!
    private let quizNetworkSource:QuizNetworkDataSource!
    
    init(quizDatabaseSource:QuizDatabaseDataSource, quizNetworkSource:QuizNetworkDataSource) {
        self.quizDatabaseSourece = quizDatabaseSource
        self.quizNetworkSource = quizNetworkSource
    }
}


