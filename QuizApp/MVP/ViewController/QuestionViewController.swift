//
//  QuizViewController.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 02.05.2021..
//

import Foundation
import PureLayout
import UIKit
class QuestionViewController : UIViewController,QuestionViewDelegate {

    var backButton:UIBarButtonItem!
    private var stackView:UIStackView!
    private var router: AppRouterProtocol!
    private var question: Question!
    private var questionLabel:UILabel!
    private var answerButtons:[AnswerButton] = []
    private var qvc : QuizViewController!
    private var presenter:QuestionPresenter!
    
    convenience init(router: AppRouterProtocol, question: Question, qvc: QuizViewController) {
        self.init()
        self.router = router
        self.question = question
        self.qvc = qvc
        self.presenter = QuestionPresenter(delegate: self)
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
        backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action: nil)
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
    
    @objc func handleAnswerButton(_ sender: AnswerButton) {
        self.presenter.handleAnsweredQuestion(selectedIndex: sender.index!, correctIndex: question.correctAnswer)
    }
    
    
    func disableInteraciton(){
        stackView.isUserInteractionEnabled = false
    }
        
    func showCorrectAnswer(selectedIndex:Int){
        answerButtons[selectedIndex].markCorrect()
    }
    
    func showWrongAnswer(correctIndex:Int, wrongIndex:Int){
        answerButtons[wrongIndex].markIncorrect()
        answerButtons[correctIndex].markCorrect()
    }
    
    func showNextQuestion(result:Bool){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.qvc.nextController(result: result)
        }
    }
    
    
    private func styleViews() {
        questionLabel.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
        questionLabel.textColor = .white
        stackView.spacing = globalStackSpacing
        
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






