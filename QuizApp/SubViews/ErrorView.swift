//
//  ErrorLabel.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 14.04.2021..
//

import Foundation
import UIKit

class ErrorView : UIView{
    
    // will be implemented later with network introduction
    
    var errorImageView:UIImageView!
    var titleLabel:UILabel!
    var detailsLabel:UILabel!
    
    required init ?(coder: NSCoder ) {
        fatalError ( "init(coder:) has not been implemented" )
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    public func create(){
        createViews()
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        self.layer.cornerRadius = 18
        errorImageView.image = UIImage(named: "Error")
        
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.text = "Error"
        titleLabel.sizeToFit()
        
        detailsLabel.numberOfLines = 0
        detailsLabel.lineBreakMode = .byWordWrapping
        detailsLabel.text = "Data can’t be reached. Please try again"
        detailsLabel.textAlignment = .center
        detailsLabel.frame.size.width = self.frame.width - 20
        detailsLabel.sizeToFit()
        
        self.addSubview(errorImageView)
        self.addSubview(titleLabel)
        self.addSubview(detailsLabel)
        self.layoutSubviews()
        
        setConstraints()
    }
    
    private func createViews(){
        errorImageView = {
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
    }
    
    
    private func setConstraints(){
        NSLayoutConstraint.activate([
            
            errorImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            errorImageView.topAnchor.constraint(equalTo:self.topAnchor, constant:20),
            errorImageView.widthAnchor.constraint(equalToConstant:70),
            errorImageView.heightAnchor.constraint(equalToConstant:70),
            
            titleLabel.topAnchor.constraint(equalTo:self.errorImageView.bottomAnchor,constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            
            detailsLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor, constant: 10),
            detailsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            detailsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
    }
    
    
    
}
