//
//  InitialViewController.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 13.04.2021..
//

import Foundation
import PureLayout
import UIKit

class QuizzesViewController : UIViewController,QuizzesViewDelegate{
    
    private var titleLabel: TitleLabel!
    private var quizContainer:UIView!
    private var quizzesTableView : UITableView!
    private var funFactView : FunFactView!
    private var factNumber : Int = 0
    private var errorMessageView: ErrorView!
    private var presenter: QuizzesPresenter!
    private var categorisedQuizzes: [[Quiz]] = []

    convenience init(router: AppRouterProtocol) {
        self.init()
        self.presenter = QuizzesPresenter(quizzesViewDelegate: self, router: router)
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
        
        
        // container for views if quizzes are available
        quizContainer = UIView()
        self.createQuizzesViews()
        quizContainer.isHidden = true
        
        // error view
        errorMessageView = ErrorView()
        view.addSubview(errorMessageView)
        errorMessageView.isHidden = true
    }
    
    private func createQuizzesViews(){
        view.addSubview(quizContainer)
        funFactView = FunFactView()
        funFactView.setMessage(title: "Fun fact", description: String(factNumber))
        quizContainer.addSubview(funFactView)
        
        // table view
        quizzesTableView = UITableView(frame: .zero, style: .grouped)
        quizzesTableView.dataSource = self
        quizzesTableView.delegate = self
        quizzesTableView.register(TableCell.self, forCellReuseIdentifier: "Cell")
        quizzesTableView.backgroundColor = quizzesTableView.backgroundColor?.withAlphaComponent(0)
        quizzesTableView.rowHeight = UITableView.automaticDimension;
        quizContainer.addSubview(quizzesTableView)
        
        defineQuizzesLayoutForViews()
    }
    
    func showNoQuizzes(){
        DispatchQueue.main.async {
            self.errorMessageView.isHidden = true
            self.quizContainer.isHidden = true
        }
    }
    
    func showQuizzes(categorisedQuizzes: [[Quiz]], factNumber:Int) {
        DispatchQueue.main.async {
            self.errorMessageView.isHidden = true
            self.quizContainer.isHidden = false
            // update elements
            self.factNumber = factNumber
            self.funFactView.updateDesctiption(description: String(factNumber))
            self.categorisedQuizzes = categorisedQuizzes
            self.quizzesTableView.reloadData()
            self.quizzesTableView.reloadInputViews()
        }
    }
    
    func showErrorMessage(error: RequestError, desc:String){
        DispatchQueue.main.async {
            self.errorMessageView.isHidden = false
            self.errorMessageView.titleLabel.text = "Error \(error.rawValue)"
            self.errorMessageView.detailsLabel.text = desc
        }
    }
    
    func showReachabilityError(){
        DispatchQueue.main.async {
            self.errorMessageView.isHidden = false
            self.errorMessageView.titleLabel.text = "No connection"
            self.errorMessageView.detailsLabel.text = "Data can’t be reached. Connect to internet and try again."
        }
    }
    
    private func styleViews() {
        
        setGradientBackground(size: view.frame.size)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // bacause even empty navigation bar takes up space
        self.presenter.getQuizzes()
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.navigationBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    private func defineLayoutForViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            //button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),

            errorMessageView.topAnchor.constraint(equalTo:titleLabel.bottomAnchor, constant: 40),
            errorMessageView.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 0),
            errorMessageView.widthAnchor.constraint(equalToConstant: 300),
            errorMessageView.heightAnchor.constraint(equalToConstant: 300)
            
        ])
    }
    
    private func defineQuizzesLayoutForViews() {
        funFactView.translatesAutoresizingMaskIntoConstraints = false
        quizzesTableView.translatesAutoresizingMaskIntoConstraints = false
        quizContainer.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            quizContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            quizContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 0),
            quizContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: 0),
            quizContainer.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: 0),
            
            funFactView.centerXAnchor.constraint(equalTo: quizContainer.centerXAnchor),
            funFactView.leadingAnchor.constraint(equalTo: quizContainer.leadingAnchor,constant: 20),
            funFactView.trailingAnchor.constraint(equalTo: quizContainer.trailingAnchor,constant: -20),
            funFactView.heightAnchor.constraint(equalToConstant: 100),
            funFactView.topAnchor.constraint(equalTo: quizContainer.topAnchor, constant: 0),
            
            quizzesTableView.topAnchor.constraint(equalTo: funFactView.bottomAnchor, constant: 0),
            quizzesTableView.trailingAnchor.constraint(equalTo: quizContainer.trailingAnchor,constant: -10),
            quizzesTableView.leadingAnchor.constraint(equalTo: quizContainer.leadingAnchor,constant: 10),
            quizzesTableView.bottomAnchor.constraint(equalTo: quizContainer.bottomAnchor,constant: -20)
        ])
    }
}



extension QuizzesViewController : UITableViewDataSource ,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.categorisedQuizzes.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categorisedQuizzes[section].count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableCell else {fatalError("Unable to create TableCell")}
        let section = indexPath.section
        if(indexPath.row < self.categorisedQuizzes[section].count){
            let quiz = self.categorisedQuizzes[section][indexPath.row]
            cell.setQuiz(quiz: quiz, section: section)
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame:CGRect(x:0,y:0,width: tableView.frame.width,height: 70))
        let categoryName = UILabel(frame:CGRect(x:20,y:30,width: headerView.frame.width,height: 30))
        categoryName.text = categorisedQuizzes[section][0].category.rawValue
        categoryName.textColor = sectionColors[section % sectionColors.count]
        categoryName.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        headerView.addSubview(categoryName)
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    
    func tableView ( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selected_quiz = categorisedQuizzes[indexPath.section][indexPath.row]
        presenter.presentQuizScreen(selected_quiz: selected_quiz)
    }
    
}


