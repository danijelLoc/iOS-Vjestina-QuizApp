//
//  InitialViewController.swift
//  QuizApp
//
//  Created by Five on 13.04.2021..
//

import Foundation
import PureLayout
import UIKit
class QuizzesViewController : UIViewController{
    // TODO ##########################################################
    // razmak između čelija
    // u header stviti pozadinu jer je sticky -- vise nije sticky ... good?
    // guard kod dohvacanja texta iz textFielda u logiinu!!
    // ###############################################################
    
    private var quizButton: Button!
    private var titleLabel: TitleLabel!
    private var quizContainer:UIView!
    private var quizzesTableView : UITableView!
    private var funFactView : FunFactView!
    private var factNumber : Int = 0
    private var router: AppRouterProtocol!
    let dataService : DataService = DataService()
    private var categorisedQuizzes:[[Quiz]] = []
    private let stackSpacing:CGFloat = 18.0
    private let globalCornerRadius:CGFloat = 18
    

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
    func customGetQuizzesAction () {
        let allQuizzes = dataService.fetchQuizes()
        let categories = [QuizCategory.sport,QuizCategory.science]
        // categorise quizzes
        let categorisedQuizzes = categories.map { (quizCategory) -> [Quiz] in
            return allQuizzes.filter { (quiz) -> Bool in
                switch quiz.category{
                case quizCategory:
                    return true
                default:
                    return false
                }
            }
        }
        // get fun fact number
        var num = 0
        for quiz in allQuizzes{
            for question in quiz.questions{
                if question.question.contains("NBA"){
                    num = num + 1
                }
            }
        }
        
        self.factNumber = num
        // show quizes if there is any
        if allQuizzes.count != 0 {
            quizContainer.isHidden = false
        }else{
            quizContainer.isHidden = true
        }
        
        self.funFactView.updateDesctiption(description: String(factNumber))
        self.categorisedQuizzes = categorisedQuizzes
        self.quizzesTableView.reloadData()
        self.quizzesTableView.reloadInputViews()
    }
    
    private func createViews() {
        // title label
        titleLabel = TitleLabel(title: "PopQuiz")
        view.addSubview(titleLabel)
        
        
        // get quizzes button
        quizButton = Button(title:"Get Quiz")
        view.addSubview(quizButton)
        quizButton.addTarget( self , action: #selector(customGetQuizzesAction), for : .touchUpInside)
        
        // container for views if quizzes are avaible
        quizContainer = UIView()
        
        self.initQuizzesViews()
        quizContainer.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // bacause even empty navigation bar takes up space
        self.navigationController!.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.navigationBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    
    private func styleViews() {
        
        setGradientBackground(size: view.frame.size)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func defineLayoutForViews() {
        quizButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            //button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 10),
            quizButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quizButton.widthAnchor.constraint(equalToConstant: 300),
            quizButton.heightAnchor.constraint(equalTo: safeArea.heightAnchor, multiplier: 0.07),
            quizButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30),
            
        ])
    }
    
    private func initQuizzesViews(){
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
    
    private func defineQuizzesLayoutForViews() {
        funFactView.translatesAutoresizingMaskIntoConstraints = false
        quizzesTableView.translatesAutoresizingMaskIntoConstraints = false
        quizContainer.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            quizContainer.topAnchor.constraint(equalTo: quizButton.bottomAnchor, constant: 10),
            quizContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 0),
            quizContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: 0),
            quizContainer.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: 0),
            
            funFactView.centerXAnchor.constraint(equalTo: quizContainer.centerXAnchor),
            funFactView.leadingAnchor.constraint(equalTo: quizContainer.leadingAnchor,constant: 20),
            funFactView.trailingAnchor.constraint(equalTo: quizContainer.trailingAnchor,constant: -20),
            funFactView.heightAnchor.constraint(equalToConstant: 100),
            funFactView.topAnchor.constraint(equalTo: quizContainer.topAnchor, constant: 0),
            
            quizzesTableView.topAnchor.constraint(equalTo: funFactView.bottomAnchor, constant: 0),
            quizzesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -10),
            quizzesTableView.leadingAnchor.constraint(equalTo: quizContainer.leadingAnchor,constant: 20),
            quizzesTableView.bottomAnchor.constraint(equalTo: quizContainer.bottomAnchor,constant: -40)
        ])
    }
}



extension QuizzesViewController : UITableViewDataSource ,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //print(self.quizzes.count)
        return self.categorisedQuizzes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categorisedQuizzes[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? TableCell else {fatalError("Unable to create TableCell")}
        let section = indexPath.section
        if(indexPath.row < self.categorisedQuizzes[section].count){
            cell.setQuiz(quiz: self.categorisedQuizzes[section][indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame:CGRect(x:0,y:0,width: tableView.frame.width,height: 70))
        
        //headerView.backgroundColor = .clear
        let categoryName = UILabel(frame:CGRect(x:20,y:30,width: headerView.frame.width,height: 30))
        categoryName.text = categorisedQuizzes[section][0].category.rawValue
        
        let colors = [UIColor.yellow, UIColor(hex: "#56CCF2FF"), UIColor.red, UIColor.green]
        categoryName.textColor = colors[section % colors.count]
        
        categoryName.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        headerView.addSubview(categoryName)
        
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView ( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let selected_quiz = categorisedQuizzes[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true )
        router.showQuizScreen(quiz: selected_quiz)
    }
    
}


