//
//  TableCell.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 14.04.2021..
//

import Foundation
import UIKit

class TableCell : UITableViewCell {
    
    var quiz:Quiz!
    var globalContainerView:UIView!
    var containerView:UIView!
    var quizImageView:UIImageView!
    var titleLabel:UILabel!
    var detailsLabel:UILabel!
    var ratingStack:UIStackView!
    var section:Int!
    var ratingStars:[UIImageView] = []

    
    required init ?(coder: NSCoder ) {
        fatalError ( "init(coder:) has not been implemented" )
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createViews()
        styleCell()
        setConstraints()
    }
    
    public func setQuiz(quiz:Quiz, section: Int){
        self.quiz = quiz
        detailsLabel.text = " \(quiz.description) "
        titleLabel.text = quiz.title
        self.section = section
        setRating()
        guard quiz.image != nil else { return }
        self.quizImageView.image = quiz.image!
    }
    
    private func setRating(){
        for i in 0..<3{
            if i < quiz.level{
                ratingStars[i].tintColor = sectionColors[section % sectionColors.count]
            }else{
                ratingStars[i].tintColor = .white
            }
        }
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
        globalContainerView = {
            let view = UIView()
            //view.backgroundColor = .green
            view.translatesAutoresizingMaskIntoConstraints = false
            view.clipsToBounds = true // this will make sure its children do not go out of the boundary
            return view
        }()
        ratingStack = {
            let sv = UIStackView()
            sv.axis = .horizontal
            sv.translatesAutoresizingMaskIntoConstraints = false
            sv.distribution = .equalSpacing
            for _ in 0..<3{
                let star = UIImageView(image: UIImage(systemName: "rhombus.fill"))
                star.contentMode = .scaleAspectFit
                ratingStars.append(star)
                sv.addArrangedSubview(star)
            }
            return sv
        }()
        
        quizImageView.image = UIImage(named:"QuizImage")
        
        self.addSubview(globalContainerView)
        globalContainerView.addSubview(quizImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailsLabel)
        containerView.addSubview(ratingStack)
        self.contentView.addSubview(containerView)
        self.layoutSubviews()
    }
    
    private func styleCell(){
        self.selectionStyle = .none
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.frame.size.width = containerView.frame.width - 24
        titleLabel.sizeToFit()
        
        detailsLabel.numberOfLines = 0
        detailsLabel.lineBreakMode = .byWordWrapping
        detailsLabel.frame.size.width = containerView.frame.width - 24
        detailsLabel.sizeToFit()
        
        ratingStack.backgroundColor = .clear
        
        self.backgroundColor = .clear
        globalContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        globalContainerView.layer.cornerRadius = 18
    }
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
        globalContainerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
        globalContainerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
        globalContainerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
        globalContainerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
               
        quizImageView.centerYAnchor.constraint(equalTo:self.globalContainerView.centerYAnchor),
        quizImageView.leadingAnchor.constraint(equalTo:self.globalContainerView.leadingAnchor, constant:10),
        quizImageView.widthAnchor.constraint(equalToConstant:100),
        quizImageView.heightAnchor.constraint(equalToConstant:100),
        
        containerView.centerYAnchor.constraint(equalTo:self.globalContainerView.centerYAnchor),
        containerView.leadingAnchor.constraint(equalTo:self.quizImageView.trailingAnchor, constant:10),
        containerView.trailingAnchor.constraint(equalTo:self.globalContainerView.trailingAnchor, constant:-10),
        containerView.heightAnchor.constraint(equalToConstant:143),
        
        titleLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor,constant: 20),
        titleLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor, constant: 10),
        titleLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant: -60),
        titleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor, constant: -10),
        detailsLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor, constant: 10),
        detailsLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor, constant: 10),
        detailsLabel.bottomAnchor.constraint(equalTo:self.containerView.bottomAnchor, constant: -10),
        detailsLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor, constant: 10),
        
        ratingStack.topAnchor.constraint(equalTo:self.containerView.topAnchor,constant: 20),
        ratingStack.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -10)
        ])
    }
    
    
    
    
    
}
