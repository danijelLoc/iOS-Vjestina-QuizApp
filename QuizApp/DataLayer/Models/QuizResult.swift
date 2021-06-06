//
//  QuizResult.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 16.05.2021..
//

import Foundation

class QuizResult{
    var quizId: Int
    var correctAnswers: Int
    var totalQuestions: Int
    var time: Double
    
    init (quizId: Int, correctAnswers: Int, numberOfQuestions: Int, time: Double){
        self.quizId = quizId
        self.correctAnswers = correctAnswers
        self.totalQuestions = numberOfQuestions
        self.time = time
    }
    
    func getLabel() -> TitleLabel{
        return TitleLabel(title: "\(correctAnswers)/\(totalQuestions)", size: 88)
    }
}
