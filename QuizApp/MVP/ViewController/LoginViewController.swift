
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
    private var usernameTextField:InputField!
    private var passwordTextField:InputField!
    private var passwordToggleIconView:UIImageView!
    private var stackView:UIStackView!
    
    private var router: AppRouterProtocol!
    private var presenter: LoginPresenter!
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
        self.presenter = LoginPresenter(delegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // remember login
        let defaults = UserDefaults.standard
        guard let _ = defaults.object(forKey: "user_id"),
              let _ = defaults.object(forKey: "user_token")
        else{
            buildViews()
            return
        }
        self.styleViews()
        self.showGoodLogin()
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
        
        // username text field
        usernameTextField = InputField(placeHolder:"Username or email", isProtected:false)
        
        // password text field
        passwordTextField = InputField(placeHolder: "Password", isProtected: true)
        
        usernameTextField.addSelectionListener(inputField: passwordTextField)
        passwordTextField.addSelectionListener(inputField: usernameTextField)
        
        // login button
        loginButton = Button(title:"Login")
        loginButton.disable()
        loginButton.addTarget( self , action: #selector(customLoginAction), for : .touchUpInside)
        passwordTextField.addEmptinessListener(button: loginButton)
        usernameTextField.addEmptinessListener(button: loginButton)
        
        // stack
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.addArrangedSubview(usernameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(loginButton)
        stackView.spacing = globalStackSpacing
        
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
            let username = usernameTextField.text,
            let password = passwordTextField.text
        else { return }
        presenter.login(username: username, password: password)
    }
    
    
    @objc func togglePasswordVisibility() {
        presenter.togglePassword(isSecureTextEntry: passwordTextField.isSecureTextEntry, text: passwordTextField.text)
    }
    
    func showGoodLogin() {
        DispatchQueue.main.async {
            self.router.quizzesControllerAsRootAndShow()
        }
    }
    
    func showLoginError(error:RequestError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error Code: \(error.rawValue)", message: "\(error)", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert,animated: true)
        }
    }
    
    func showReachabilityError(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "No connection", message: "The Internet connection appears to be offline.", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert,animated: true)
        }
    }
    
    func showLoginClientError() {
        DispatchQueue.main.async {
            self.usernameTextField.showInvalid()
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
