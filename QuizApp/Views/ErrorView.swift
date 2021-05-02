//
//  ErrorLabel.swift
//  QuizApp
//
//  Created by Five on 14.04.2021..
//

import Foundation


//
//  FunFactView.swift
//  QuizApp
//
//  Created by Five on 14.04.2021..
//

import Foundation

//
//  TableCell.swift
//  QuizApp
//
//  Created by Five on 14.04.2021..
//

import Foundation
import UIKit

class ErrorView : UIView{
    
    //private var quiz:Quiz!
    
    var quizImageView:UIImageView!
    var titleLabel:UILabel!
    var detailsLabel:UILabel!
    var containerView:UIView!
    
    
    required init ?(coder: NSCoder ) {
        fatalError ( "init(coder:) has not been implemented" )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    
    public func setUp(){
        createViews()
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.layer.cornerRadius = 18
        quizImageView.image = UIImage(systemName: "icloud.slash")
        quizImageView.tintColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = "Error"
        titleLabel.frame.size.width = containerView.frame.width - 24
        titleLabel.sizeToFit()
        
        detailsLabel.numberOfLines = 0
        detailsLabel.lineBreakMode = .byWordWrapping
        detailsLabel.text = "Data can’t be reached. Please try again"
        detailsLabel.frame.size.width = containerView.frame.width - 24
        detailsLabel.sizeToFit()
        
        self.addSubview(quizImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailsLabel)
        self.addSubview(containerView)
        self.layoutSubviews()
        
        setConstraints()
    }

    
    private func createViews(){
        quizImageView = {
            let img = UIImageView()
            img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
            img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
            img.layer.cornerRadius = 12
            img.clipsToBounds = true
            return img
        }()
        titleLabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 24, weight: UIFont.Weight.bold)
            label.textColor = .white
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        detailsLabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
            label.textColor =  .white
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }()
        containerView = {
            let view = UIView()
            //view.backgroundColor = .green
            view.translatesAutoresizingMaskIntoConstraints = false
            view.clipsToBounds = true // this will make sure its children do not go out of the boundary
            return view
        }()
    }
    
    
    private func setConstraints(){
        quizImageView.centerXAnchor.constraint(equalTo:self.centerXAnchor).isActive = true
        quizImageView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:10).isActive = true
        quizImageView.topAnchor.constraint(equalTo:self.topAnchor, constant:0).isActive = true
        quizImageView.widthAnchor.constraint(equalToConstant:50).isActive = true
        quizImageView.heightAnchor.constraint(equalToConstant:50).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo:self.centerYAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo:quizImageView.bottomAnchor, constant:5).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.leadingAnchor, constant:5).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.trailingAnchor, constant:-5).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:143).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor,constant: 10).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.quizImageView.trailingAnchor, constant: 10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant: -80).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor, constant: 10).isActive = true
        //titleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        detailsLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor, constant: 0).isActive = true
        detailsLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor, constant: 10).isActive = true
        detailsLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant: -10).isActive = true
        detailsLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor, constant: 10).isActive = true
    }
    
    
    
    
    
}
