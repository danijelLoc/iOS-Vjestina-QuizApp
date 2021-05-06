//
//  TableCell.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 14.04.2021..
//

import Foundation
import UIKit

class TableCell : UITableViewCell{
    
    var quiz:Quiz!
    var quizImageView:UIImageView!
    var titleLabel:UILabel!
    var detailsLabel:UILabel!
    var containerView:UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
    }
    
    required init ?(coder: NSCoder ) {
        fatalError ( "init(coder:) has not been implemented" )
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
        styleCell()
        setConstraints()
    }
    
    public func setQuiz(quiz:Quiz){
        self.quiz = quiz
        detailsLabel.text = " \(quiz.description) "
        titleLabel.text = quiz.title
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
            label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
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
        
        quizImageView.image = UIImage(named:"QuizImage")
        self.contentView.addSubview(quizImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailsLabel)
        self.contentView.addSubview(containerView)
        self.layoutSubviews()
    }
    
    private func styleCell(){
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.frame.size.width = containerView.frame.width - 24
        titleLabel.sizeToFit()
        
        detailsLabel.numberOfLines = 0
        detailsLabel.lineBreakMode = .byWordWrapping
        detailsLabel.frame.size.width = containerView.frame.width - 24
        detailsLabel.sizeToFit()
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        self.layer.cornerRadius = 18
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
        quizImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor),
        quizImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10),
        quizImageView.widthAnchor.constraint(equalToConstant:100),
        quizImageView.heightAnchor.constraint(equalToConstant:100),
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor),
        containerView.leadingAnchor.constraint(equalTo:self.quizImageView.trailingAnchor, constant:10),
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10),
        containerView.heightAnchor.constraint(equalToConstant:143),
        
        titleLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor,constant: 20),
        titleLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor, constant: 10),
        titleLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant: -60),
        titleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor, constant: 10),
        //titleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor),
        
        detailsLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor, constant: 10),
        detailsLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor, constant: 10),
        detailsLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant: -10),
        detailsLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor, constant: 10),
        ])
    }
    
    
    
    
    
}
