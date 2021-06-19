//
//  QuizResultViewController.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 04.05.2021..
//

import Foundation
import PureLayout
import UIKit



class QuizResultViewController : UIViewController,QuizResultViewDelegate {

    private var quizResult: QuizResult!
    private var resultLabel: UILabel!
    private var finishButton: Button!
    private var presenter: QuizResultPresenter!
    
    
    convenience init(router: AppRouterProtocol, result: QuizResult) {
        self.init()
        self.quizResult = result
    }
    
    func setPresenter(presenter: QuizResultPresenter){
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViews()
        // send result to server
        presenter.sendResults()
    }

    private func buildViews() {
        createViews()
        styleViews()
        defineLayoutForViews()
    }
    
    private func createViews() {
        resultLabel = quizResult.getLabel()
        view.addSubview(resultLabel)
        
        finishButton = Button(title: "Finish Quiz")
        finishButton.addTarget(self, action: #selector(handleFinishButton), for: .touchDown)
        view.addSubview(finishButton)
    }
    
    func showFailedResultSending(error:RequestError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error Code: \(error.rawValue)", message: "Cant send results, \(error)", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert,animated: true)
        }
    }
    
    func showReachabilityError(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "No connection", message: "Cannot send results. The Internet connection appears to be offline.", preferredStyle:.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (UIAlertAction) in
                self.presenter.sendResults()
            }))
            alert.overrideUserInterfaceStyle = .dark
            self.present(alert,animated: true)
        }
    }

    @objc func handleFinishButton() {
        presenter.presentReturnToQuizzes()
    }
    
    private func styleViews() {
        setGradientBackground(size: view.frame.size)
        self.navigationController!.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.isHidden = true
        super.viewWillAppear(animated)
    }
 
    
    private func defineLayoutForViews() {
        let safeArea = self.view.safeAreaLayoutGuide
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultLabel.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor, constant: -50),
            resultLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            finishButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: -44),
            finishButton.heightAnchor.constraint(equalToConstant: 44),
            finishButton.widthAnchor.constraint(equalToConstant: 300),
            finishButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
        ])
        
        
    }
    
}







