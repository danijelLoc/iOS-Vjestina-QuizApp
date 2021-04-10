//
//  InitialViewController.swift
//  QuizApp
//
//  Created by Five on 10.04.2021..
//

import Foundation
import PureLayout
import UIKit
class InitialViewController : UIViewController {
    
    private var loginButton: UIButton!
    private var titleLabel: UILabel!
    private var backgroundColorLighter: UIColor = UIColor.init(hex: "#744FA3FF")!
    private var backgroundColorDarker: UIColor = UIColor.init(hex: "#272F76FF")!
    
    private let whiteColorTransparent: UIColor = UIColor.init(hex: "#FFFFFF70")!
    private let mainFontName = "Times New Roman Bold"
    private var mailTextField:UITextField!
    private var passwordTextField:UITextField!
    private var stackView:UIStackView!
    private let stackSpacing:CGFloat = 18.0
    private let globalCornerRadius:CGFloat = 18
    private let textFieldPadding:CGFloat = 22
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil, completion: {
            _ in
            //self.setGradientBackground(size: size)
        })
    }
    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews() {
        // title label
        titleLabel = UILabel()
        view.addSubview(titleLabel)
        titleLabel.text = "PopQuiz"
        
        
        
        // mail text field
        mailTextField = UITextField()
        mailTextField.attributedPlaceholder =
            NSAttributedString(string: "Email", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        // password text field
        passwordTextField = UITextField()
        passwordTextField.attributedPlaceholder =
            NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        // login button
        loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        
        // stack
        stackView = UIStackView()
        
        stackView.axis = .vertical // 1.
        stackView.alignment = .fill // 2.
        stackView.distribution = .fillEqually // 3.
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.addArrangedSubview(mailTextField) // 4.
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.spacing = stackSpacing
        
        
    }
    private func styleViews() {
        
        //setGradientBackground(size: view.frame.size)
        view.backgroundColor = backgroundColorLighter
        
        titleLabel.font = UIFont(name: mainFontName, size: 32)
        titleLabel.textColor = .white
        
        mailTextField.backgroundColor = whiteColorTransparent
        mailTextField.textColor = .white
        
        mailTextField.layer.cornerRadius = globalCornerRadius
        mailTextField.clipsToBounds = true
        mailTextField.setLeftPaddingPoints(textFieldPadding)
        mailTextField.setRightPaddingPoints(textFieldPadding)
        
        
        passwordTextField.backgroundColor = whiteColorTransparent
        passwordTextField.textColor = .white
        passwordTextField.layer.cornerRadius = globalCornerRadius
        passwordTextField.clipsToBounds = true
        passwordTextField.setLeftPaddingPoints(textFieldPadding)
        passwordTextField.setRightPaddingPoints(textFieldPadding)
        
        loginButton.backgroundColor = .white
        loginButton.titleLabel!.font = UIFont(name: mainFontName, size: 20)
        loginButton.setTitleColor(backgroundColorLighter, for: .normal)
        loginButton.layer.cornerRadius = globalCornerRadius
        loginButton.clipsToBounds = true
    }
    
    private func defineLayoutForViews() {
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            //button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            //loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //loginButton.widthAnchor.constraint(equalToConstant: 300),
            //loginButton.heightAnchor.constraint(equalToConstant: 50),
            //loginButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80)
            
        ])
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            //stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -500)
        ])
    }
    
    private func setGradientBackground(size: CGSize){
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = size
        gradientLayer.colors = [backgroundColorLighter.cgColor,backgroundColorDarker.withAlphaComponent(1).cgColor]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        //Use diffrent colors
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

class GradientView: UIView {
    
    private var backgroundColorLighter: UIColor = UIColor.init(hex: "#744FA3FF")!
    private var backgroundColorDarker: UIColor = UIColor.init(hex: "#272F76FF")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        guard let theLayer = self.layer as? CAGradientLayer else {
            return;
        }
        
        theLayer.colors = [backgroundColorLighter.cgColor, backgroundColorDarker.withAlphaComponent(1).cgColor]
        theLayer.locations = [0.0, 1.0]
        theLayer.frame = self.bounds
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
}
