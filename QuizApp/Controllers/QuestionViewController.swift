//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 02.05.2021..
//

import Foundation
import PureLayout
import UIKit
class QuestionViewController : UIViewController {

    private var backgroundColorLighter: UIColor = UIColor.init(hex:"#744FA3FF")!
    private var backgroundColorDarker: UIColor = UIColor.init(hex:"#272F76FF")!
    
    var backButton:UIBarButtonItem!
    private var stackView:UIStackView!
    private let stackSpacing:CGFloat = 18.0
    private let globalCornerRadius:CGFloat = 18
    private var router: AppRouterProtocol!
    private var question: Question!
    private var questionLabel:UILabel!
    private var answerButtons:[AnswerButton] = []
    private var qvc : QuizViewController!
    
    private var index:Int!
    
    convenience init(router: AppRouterProtocol, question: Question, qvc: QuizViewController, index:Int) {
        self.init()
        self.router = router
        self.question = question
        self.qvc = qvc
        self.index = index
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
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        questionLabel = UILabel()
        questionLabel.numberOfLines = 0
        questionLabel.lineBreakMode = .byWordWrapping
        questionLabel.text = question.question
        questionLabel.frame.size.width = view.frame.width - 30
        questionLabel.sizeToFit()
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
            answerButtons.append(AnswerButton(title: question.answers[i],index: i))
            answerButtons[i].addTarget(self, action: #selector(self.handleAnswerButton(_:)), for: .touchUpInside)
        }
    }
    
    @objc func handleReturnButton() {
        router.returnToQuizzes()
    }
    
    @objc func handleAnswerButton(_ sender: AnswerButton) {
        stackView.isUserInteractionEnabled = false
        let answer = sender.index!
        let correctAnswer:Int = question.correctAnswer
        if answer == correctAnswer {
            answerButtons[answer].markCorrect()
        }else{
            answerButtons[answer].markIncorrect()
            answerButtons[correctAnswer].markCorrect()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.qvc.nextController(result: answer == correctAnswer)
        }
    }
    
    private func styleViews() {
        questionLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        questionLabel.textColor = .white
        stackView.spacing = stackSpacing
        
        self.view.backgroundColor = .clear
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barStyle = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
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
            questionLabel.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: 30+30),
            questionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            questionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
            
            stackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -30),
        ])
    }
    
}






