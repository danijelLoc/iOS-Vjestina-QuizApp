//
//  Button.swift
//  QuizApp
//
//  Created by Five on 13.04.2021..
//

import Foundation
import UIKit

class Button: UIButton{
    private let globalCornerRadius:CGFloat = 18
    private var backgroundColorLighter: UIColor = UIColor.init(hex: "#744FA3FF")!
    
    required init ?(coder: NSCoder ) {
        fatalError ( "init(coder:) has not been implemented" )
    }
    
    init(title:String){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.style()
        disable()
    }
    
    func style(){
        self.backgroundColor = .white
        self.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy)
        self.setTitleColor(backgroundColorLighter, for: .normal)
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
    
    
}
