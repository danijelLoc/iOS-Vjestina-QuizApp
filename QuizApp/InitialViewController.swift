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
    
    private var loginButton: Button!
    private var titleLabel: TitleLabel!
    private var backgroundColorLighter: UIColor = UIColor.init(hex: "#744FA3FF")!
    private var backgroundColorDarker: UIColor = UIColor.init(hex: "#272F76FF")!
    
    //private let whiteColorTransparent: UIColor = UIColor.init(hex: "#FFFFFF70")!
    
    private var mailTextField:InputField!
    private var passwordTextField:InputField!
    private var stackView:UIStackView!
    private let stackSpacing:CGFloat = 18.0
    private let globalCornerRadius:CGFloat = 18
    //private let textFieldPadding:CGFloat = 22
    
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
    
    @objc
    func customLoginAction () {
        let dataService = DataService()
        let mail = mailTextField.text!
        let password = passwordTextField.text!
        let status_:LoginStatus = dataService.login(email: mail, password: password)
        switch status_{
        case LoginStatus.success:
            print(mail)
            print(password)
            let notifyView = UIView()
            notifyView.backgroundColor = .green
            
        case LoginStatus.error:
            print(status_)
        }
    }
    
    private func createViews() {
        // title label
        titleLabel = TitleLabel(title: "PopQuiz")
        view.addSubview(titleLabel)
        
        // mail text field
        mailTextField = InputField(placeHolder:"Email", isProtected:false)
        
        // password text field
        passwordTextField = InputField(placeHolder: "Password", isProtected: true)
        
        mailTextField.addSelectionListener(inputField: passwordTextField)
        passwordTextField.addSelectionListener(inputField: mailTextField)
        
        // login button
        loginButton = Button(title:"Login")
        loginButton.addTarget( self , action: #selector(customLoginAction), for : .touchUpInside)
        
        passwordTextField.addEmptinessListener(button: loginButton)
        mailTextField.addEmptinessListener(button: loginButton)
        
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
        
        setGradientBackground(size: view.frame.size)
        //view.backgroundColor = backgroundColorLighter
        
        
        
        
        
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
        gradientLayer.frame.size = CGSize(width: size.height, height: size.height)
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




