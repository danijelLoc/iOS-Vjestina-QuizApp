//
//  SettingsViewController.swift
//  QuizApp
//
//  Created by Five on 04.05.2021..
//

import Foundation
import PureLayout
import UIKit
class SettingsViewController : UIViewController {


    private var router: AppRouterProtocol!
    private var usernameLabel: UILabel!
    private var nameLabel:UILabel!
    private var logOutButton: Button!
    
    
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
    

    private func createViews() {
        usernameLabel = UILabel()
        usernameLabel.text = "USERNAME"
        view.addSubview(usernameLabel)
        
        nameLabel = UILabel()
        nameLabel.text = "Danijel Stracenski"
        view.addSubview(nameLabel)
        
        logOutButton = Button(title: "Log out")
        logOutButton.addTarget(self, action: #selector(handleLogOut), for: .touchDown)
        view.addSubview(logOutButton)
    }
    
    @objc func handleLogOut() {
        router.logOut()
    }
    
    private func styleViews() {
        setGradientBackground(size: view.frame.size)
        self.navigationController!.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        
        usernameLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        usernameLabel.textColor = .white
        
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = .white
        
        logOutButton.setTitleColor(UIColor(hex: "#FC6565FF"), for: .normal)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.isHidden = true
        super.viewWillAppear(animated)
    }
 
    
    private func defineLayoutForViews() {
        let safeArea = self.view.safeAreaLayoutGuide
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
       
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            usernameLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 30),
            logOutButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -30),
            logOutButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            logOutButton.widthAnchor.constraint(equalToConstant: 300),
            logOutButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        
    }
    
}






