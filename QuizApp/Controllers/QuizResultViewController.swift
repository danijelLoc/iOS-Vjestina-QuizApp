//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by Five on 04.05.2021..
//

import Foundation
import PureLayout
import UIKit
class QuizResultViewController : UIViewController {


    private var router: AppRouterProtocol!
    
    private var quizResult: QuizResult! 
    private var resultLabel: UILabel!
    private var finishButton: Button!
    
    
    convenience init(router: AppRouterProtocol, result: QuizResult) {
        self.init()
        self.router = router
        self.quizResult = result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
    }
    

    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    

    private func createViews() {
        resultLabel = quizResult.getLabel()
        view.addSubview(resultLabel)
        
        finishButton = Button(title: "Finish Quiz")
        finishButton.addTarget(self, action: #selector(handleFinishButton), for: .touchDown)
        view.addSubview(finishButton)
    }
    

    
    @objc func handleFinishButton() {
        router.returnToQuizzes()
    }
    
    private func styleViews() {
        setGradientBackground(size: view.frame.size)
        self.navigationController!.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.isHidden = true
        super.viewWillAppear(animated)
    }
 
    
    private func defineLayoutForViews() {
        let safeArea = self.view.safeAreaLayoutGuide
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -50),
            resultLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            finishButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -44),
            finishButton.heightAnchor.constraint(equalToConstant: 44),
            finishButton.widthAnchor.constraint(equalToConstant: 300),
            finishButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
//            finishButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
//            finishButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
        ])
        
        
    }
    
}

class QuizResult{
    var correctAnswers: Int
    var totalQuestions: Int
    
    init (correctAnswers: Int,numberOfQuestions: Int){
        self.correctAnswers = correctAnswers
        self.totalQuestions = numberOfQuestions
    }
    
    func getLabel() -> TitleLabel{
        return TitleLabel(title: "\(correctAnswers)/\(totalQuestions)", size: 88)
    }
    
}






