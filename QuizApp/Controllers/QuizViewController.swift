//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Five on 02.05.2021..
//

import Foundation
import PureLayout
import UIKit
class QuizViewController : UIViewController {

    private var backgroundColorLighter: UIColor = UIColor.init(hex:"#744FA3FF")!
    private var backgroundColorDarker: UIColor = UIColor.init(hex:"#272F76FF")!
    
    var backButton:UIBarButtonItem!
    private var stackView:UIStackView!
    private let stackSpacing:CGFloat = 18.0
    private let globalCornerRadius:CGFloat = 18
    private var router: AppRouterProtocol!
    private var quiz: Quiz!
    private var questionLabel:UILabel!
    private var answerButtons:[AnswerButton] = []
    
    private var currentQuestion:Int = 0
    private var correctAnswers:Int = 0
    
    
    convenience init(router: AppRouterProtocol, quiz: Quiz) {
        self.init()
        self.router = router
        self.quiz = quiz
        
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
        navigationItem.titleView = TitleLabel(title: "PopQuiz",size: 24)
        
        self.navigationItem.hidesBackButton = false
        backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: #selector(handleReturnButton))
        backButton.tintColor = .white
        //self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        
        questionLabel = UILabel()
        
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.text = quiz.questions[currentQuestion].question
        questionLabel.frame.size.width = view.frame.width - 30
        questionLabel.sizeToFit()
        //questionLabel.backgroundColor = .red
        
        view.addSubview(questionLabel)
        createButtons()
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.addArrangedSubview(answerButtons[0])
        stackView.addArrangedSubview(answerButtons[1])
        stackView.addArrangedSubview(answerButtons[2])
        stackView.addArrangedSubview(answerButtons[3])
        
    }
    
    private func createButtons(){
        for i in 0..<4{
            answerButtons.append(AnswerButton(title: quiz.questions[currentQuestion].answers[i],index: i))
            answerButtons[i].addTarget(self, action: #selector(self.handleAnswerButton(_:)), for: .touchUpInside)
        }
    }
    
    func updateQuestion(){
        if currentQuestion < quiz.questions.count - 1{
            currentQuestion += 1
            questionLabel.text = quiz.questions[currentQuestion].question
            for i in 0..<4{
                answerButtons[i].backgroundColor = UIColor.white.withAlphaComponent(0.3)
                answerButtons[i].setTitle(quiz.questions[currentQuestion].answers[i], for: .normal)
            }
            
        }
        else{
            router.returnToQuizzes()
            let results = 2
            // TODO add results screen
        }
        
    }
    
    @objc func handleReturnButton() {
        router.returnToQuizzes()
    }
    
    @objc func handleAnswerButton(_ sender: AnswerButton) {
        let answer = sender.index!
        let correctAnswer:Int = quiz.questions[currentQuestion].correctAnswer
        if answer == correctAnswer {
            answerButtons[answer].markCorrect()
        }else{
            answerButtons[answer].markIncorrect()
            answerButtons[correctAnswer].markCorrect()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.updateQuestion()
        }
    }
    
    private func styleViews() {
        questionLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        questionLabel.textColor = .white
        stackView.spacing = stackSpacing
        setGradientBackground(size: view.frame.size)
        self.navigationController!.navigationBar.isHidden = false
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barStyle = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
 
    
    private func defineLayoutForViews() {
        let safeArea = self.view.safeAreaLayoutGuide
        stackView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<4{
            answerButtons[i].translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                answerButtons[i].heightAnchor.constraint(equalToConstant: 35)
            ])
        }
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 100),
            questionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            questionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            stackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
//            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -200)
        ])
        
        
    }
    
}






