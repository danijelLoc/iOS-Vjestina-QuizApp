//
//  QuestionTrackerView.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 06.05.2021..
//

import Foundation
import Foundation
import UIKit

class QuestionTrackerView : UIView{

    var progressLabel:UILabel!
    var progressButtons:[UIButton]!
    var progressStack:UIStackView!
    var containerView:UIView!
    
    var numberOfCorrectAnswers:Int!
    var numberOfQuestions:Int = 0
    var currentIndex:Int = 0
    
    required init ?(coder: NSCoder ) {
        fatalError ( "init(coder:) has not been implemented" )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public func updateProgress(correctlyAnswered:Bool,nextIndex:Int){
        progressButtons[currentIndex].backgroundColor = (correctlyAnswered == true ? customGreen : customRed)
        if nextIndex < numberOfQuestions{
            currentIndex = nextIndex
            progressLabel.text = "\(currentIndex+1)/\(numberOfQuestions)"
            progressButtons[currentIndex].backgroundColor = .white
        }
    }
    
    public func setDimensions(numberOfQuestions: Int){
        self.numberOfQuestions = numberOfQuestions
        createSubViews()
        setConstraints()
    }
    
    private func createSubViews(){
        progressLabel = UILabel()
        progressLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        progressLabel.textColor = .white
        progressLabel.text = "\(currentIndex+1)/\(numberOfQuestions)"
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(progressLabel)
        
        progressStack = UIStackView()
        progressStack.axis = .horizontal
        progressStack.alignment = .fill
        progressStack.distribution = .fillEqually
        progressStack.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(progressStack)
        populateProgressStack()
        
    }
    
    private func populateProgressStack(){
        progressButtons = []
        for _ in 0..<numberOfQuestions{
            let b = UIButton()
            b.setTitle(" ", for: .normal)
            b.setTitleColor(.blue, for: .normal)
            b.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            b.isEnabled = false
            b.layer.cornerRadius = 5
            progressButtons.append(b)
            progressStack.addArrangedSubview(b)
        }
        progressStack.spacing = 5
        progressButtons[0].backgroundColor = .white
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            progressLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            progressLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            
            progressStack.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 5),
            progressStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            progressStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -0),
            progressStack.heightAnchor.constraint(equalToConstant: 5)
        ])
    }
}
