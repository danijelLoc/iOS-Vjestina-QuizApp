//
//  InitialViewController.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 10.04.2021..
//

import Foundation
import PureLayout
import UIKit
class LoginViewController : UIViewController {
    
    private var loginButton: Button!
    private var titleLabel: TitleLabel!
    private var mailTextField:InputField!
    private var passwordTextField:InputField!
    private var togglePasswordButton:UIButton!
    private var stackView:UIStackView!
    private let stackSpacing:CGFloat = 18.0
    private let globalCornerRadius:CGFloat = 18
    private var router: AppRouterProtocol!
    private var dataService:DataService!
    private var passwordToggleIconView:UIImageView!
    private let showPasswordImg = UIImage(named: "Show")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    private let hidePasswordImg = UIImage(named: "Hide")?.withTintColor(.white, renderingMode: .alwaysOriginal)
    
    convenience init(router: AppRouterProtocol) {
        self.init()
        self.router = router
        self.dataService = DataService()
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
        guard
            let mail = mailTextField.text,
            let password = passwordTextField.text
        else {
            return
        }
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
        togglePasswordButton = UIButton(type: .custom)
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
        passwordTextField.rightView = togglePasswordButton
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: UIControl.Event.touchDown)
        passwordTextField.rightViewMode = .always
    }
    
    // imported method :)
    @objc func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        passwordToggleIconView.image = passwordTextField.isSecureTextEntry ? showPasswordImg : hidePasswordImg

        if let existingText = passwordTextField.text, passwordTextField.isSecureTextEntry {
            /* When toggling to secure text, all text will be purged if the user
             continues typing unless we intervene. This is prevented by first
             deleting the existing text and then recovering the original text. */
            passwordTextField.deleteBackward()

            if let textRange = passwordTextField.textRange(from: passwordTextField.beginningOfDocument, to: passwordTextField.endOfDocument) {
                passwordTextField.replace(textRange, withText: existingText)
            }
        }

        /* Reset the selected text range since the cursor can end up in the wrong
         position after a toggle because the text might vary in width */
        if let existingSelectedTextRange = passwordTextField.selectedTextRange {
            passwordTextField.selectedTextRange = nil
            passwordTextField.selectedTextRange = existingSelectedTextRange
        }
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
            passwordToggleIconView.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor,constant: -10),
            passwordToggleIconView.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor,constant: 0)
        ])
    }
}






