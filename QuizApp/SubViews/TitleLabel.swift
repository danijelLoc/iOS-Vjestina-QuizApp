//
//  TitleLabel.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 13.04.2021..
//

import Foundation
import UIKit

class TitleLabel:UILabel{
    
    required init ?(coder: NSCoder ) {
        fatalError ( "init(coder:) has not been implemented" )
    }
    
    init(title:String, size:CGFloat = 32){
        super.init(frame: CGRect.zero)
        self.text = title
        self.font = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
        self.textColor = .white
    }
}

