//
//  Button.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 13.04.2021..
//

import Foundation
import UIKit

class Button: UIButton {
    
    required init ?(coder: NSCoder ) {
        fatalError ( "init(coder:) has not been implemented" )
    }
    
    init(title:String){
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.style()
    }
    
    func style(){
        self.backgroundColor = .white
        self.titleLabel!.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.heavy)
        self.setTitleColor(backgroundColorLighter, for: .normal)
        self.layer.cornerRadius = globalCornerRadius
        self.clipsToBounds = true
    }
    
    func disable(){
        self.alpha = 0.5
        self.isUserInteractionEnabled = false
    }
    
    func enable(){
        self.alpha = 1
        self.isUserInteractionEnabled = true
    }
    
    
}
