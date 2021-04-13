//
//  TitleLabel.swift
//  QuizApp
//
//  Created by Five on 13.04.2021..
//

import Foundation
import UIKit

class TitleLabel:UILabel{
    
    private let mainFont = UIFont.systemFont(ofSize: 32, weight: UIFont.Weight.bold)
    
    required init ?(coder: NSCoder ) {
        fatalError ( "init(coder:) has not been implemented" )
    }
    
    init(title:String){
        super.init(frame: CGRect.zero)
        self.text = title
        self.font = mainFont
        self.textColor = .white
    }
}

