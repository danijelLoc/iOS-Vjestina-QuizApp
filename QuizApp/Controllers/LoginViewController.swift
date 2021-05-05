//
//  InitialViewController.swift
//  QuizApp
//
//  Created by Five on 10.04.2021..
//

import Foundation
import PureLayout
import UIKit
class LoginViewController : UIViewController {
    
    private var loginButton: Button!
    private var titleLabel: TitleLabel!
    private var mailTextField:InputField!
    private var passwordTextField:InputField!
    private var stackView:UIStackView!
    private let stackSpacing:CGFloat = 18.0
    private let globalCornerRadius:CGFloat = 18
    private var router: AppRouterProtocol!
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
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
            self.router.quizzesControllerAsRootAndShow(in: view.window)
        case LoginStatus.error:
            print(status_)
            mailTextField.showInvalid()
            passwordTextField.showInvalid()
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
        loginButton.disable()
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
        
        self.setGradientBackground(size: view.frame.size)
        self.navigationController!.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    private func defineLayoutForViews() {
        let safeArea = self.view.safeAreaLayoutGuide
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20)
            
        ])
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -40),
        ])
    }
}

extension UIViewController{

    public func setGradientBackground(size: CGSize){
        let backgroundColorLighter: UIColor = UIColor.init(hex: "#744FA3FF")!
        let backgroundColorDarker: UIColor = UIColor.init(hex: "#272F76FF")!
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        let largerAxis = max(size.height,size.width)
        gradientLayer.frame.size = CGSize(width: largerAxis, height: largerAxis)
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




