//
//  AnswerButton.swift
//  QuizApp
//
//  Created by Five on 03.05.2021..
//

import Foundation
import UIKit

class AnswerButton: UIButton{
    private let globalCornerRadius:CGFloat = 18
    private var backgroundColorLighter: UIColor = UIColor.init(hex: "#744FA3FF")!
    public var index: Int!
    
    required init ?(coder: NSCoder ) {
        fatalError ( "init(coder:) has not been implemented" )
    }
    
    init(title:String, index:Int){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.style()
        self.index = index
    }
    
    func style(){
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        self.titleLabel!.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.heavy)
        
        self.contentHorizontalAlignment = .leading
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = globalCornerRadius
        self.clipsToBounds = true
    }
    
    func disable(){
        self.alpha = 0.6
        self.isUserInteractionEnabled = false
    }
    
    func enable(){
        self.alpha = 1
        self.isUserInteractionEnabled = true
    }
    
    func markCorrect(){
        self.backgroundColor = UIColor(hex: "#6FCF97FF")
    }
    
    func markIncorrect(){
        self.backgroundColor = UIColor(hex: "#FC6565FF")
    }
    
}
