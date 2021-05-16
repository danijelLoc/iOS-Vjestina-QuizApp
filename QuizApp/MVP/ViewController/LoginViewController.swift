
//
//  InitialViewController.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 10.04.2021..
//

import Foundation
import UIKit
class LoginViewController : UIViewController, LoginViewDelegate {

    
    private var loginButton: Button!
    private var titleLabel: TitleLabel!
    private var mailTextField:InputField!
    private var passwordTextField:InputField!
    private var passwordToggleIconView:UIImageView!
    private var stackView:UIStackView!
    private let stackSpacing:CGFloat = 18.0
    private let globalCornerRadius:CGFloat = 18
    
    private var router: AppRouterProtocol!
    private var presenter: LoginPresenter!

    private let showPasswordImg = UIImage(named: "Show")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    private let hidePasswordImg = UIImage(named: "Hide")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
        self.presenter = LoginPresenter(delegate: self)
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
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.addArrangedSubview(mailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.spacing = stackSpacing
        
        // password visibility toggle
        addPasswordToggle()
    }

    private func addPasswordToggle(){
        passwordTextField.rightViewMode = .unlessEditing
        passwordToggleIconView = {
            let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
            iv.contentMode = .scaleAspectFill
            iv.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
            iv.layer.cornerRadius = 12
            iv.clipsToBounds = true
            iv.image = showPasswordImg
            return iv
        }()
        passwordTextField.addSubview(passwordToggleIconView)
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.togglePasswordVisibility))
        passwordToggleIconView.addGestureRecognizer(singleTap)
        passwordToggleIconView.isUserInteractionEnabled = true
        passwordTextField.rightViewMode = .always
    }
    
    @objc
    func customLoginAction () {
        guard
            let mail = mailTextField.text,
            let password = passwordTextField.text
        else {
            return
        }
        presenter.login(username: mail, password: password)
    }
    
    
    @objc func togglePasswordVisibility() {
        presenter.togglePassword(isSecureTextEntry: passwordTextField.isSecureTextEntry, text: passwordTextField.text)
    }
    
    func presentGoodLogin() {
        DispatchQueue.main.async {
            self.router.quizzesControllerAsRootAndShow(in: self.view.window)
        }
    }
    
    func presentLoginError(error:RequestError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error Code: \(error.rawValue)", message: "\(error)", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert,animated: true)
        }
    }
    
    func presentLoginClientError() {
        DispatchQueue.main.async {
            self.mailTextField.showInvalid()
            self.passwordTextField.showInvalid()
        }
    }
    
    func hidePassword(existingText: String) {
        passwordTextField.isSecureTextEntry = true
        passwordToggleIconView.image = showPasswordImg
        passwordTextField.deleteBackward()
        if let textRange = passwordTextField.textRange(from: passwordTextField.beginningOfDocument, to: passwordTextField.endOfDocument) {
            passwordTextField.replace(textRange, withText: existingText)
        }
        let existingSelectedTextRange = passwordTextField.selectedTextRange
        passwordTextField.selectedTextRange = nil
        passwordTextField.selectedTextRange = existingSelectedTextRange
    }
    
    func showPassword() {
        passwordTextField.isSecureTextEntry = false
        passwordToggleIconView.image = hidePasswordImg
        let existingSelectedTextRange = passwordTextField.selectedTextRange
        passwordTextField.selectedTextRange = nil
        passwordTextField.selectedTextRange = existingSelectedTextRange
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
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -40),
            passwordToggleIconView.heightAnchor.constraint(equalToConstant: 30),
            passwordToggleIconView.widthAnchor.constraint(equalToConstant: 30),
            passwordToggleIconView.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor,constant: -5),
            passwordToggleIconView.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor,constant: 0)
        ])
    }
}
