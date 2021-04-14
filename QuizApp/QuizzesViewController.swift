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
    
    
    
    private var quizButton: Button!
    private var titleLabel: TitleLabel!
    private var quizContainer:UIView!
    private var quizzesTableView : UITableView!
    private var backgroundColorLighter: UIColor = UIColor.init(hex: "#744FA3FF")!
    private var backgroundColorDarker: UIColor = UIColor.init(hex: "#272F76FF")!
    private var funFactView : FunFactView!
    private var factNumber : Int = 0
    
    
    let dataService : DataService = DataService()
    private var categorisedQuizzes:[[Quiz]] = []
    private var currentCategory:Int = 0
    
    private let stackSpacing:CGFloat = 18.0
    private let globalCornerRadius:CGFloat = 18
    
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
        for quiz in dataService.fetchQuizes(){
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
        self.currentCategory = 0
        
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
        quizButton.enable()
        view.addSubview(quizButton)
        quizButton.addTarget( self , action: #selector(customGetQuizzesAction), for : .touchUpInside)
        
        // container for views if quizzes are avaible
        quizContainer = UIView()
        
        self.initQuizzesViews()
        quizContainer.isHidden = true
        
    }
    private func styleViews() {
        
        setGradientBackground(size: view.frame.size)
        //view.backgroundColor = backgroundColorLighter
        
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
            quizButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 60),
            quizButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -60),
            quizButton.heightAnchor.constraint(equalToConstant: 44),
            quizButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 35),
            
        ])
    }
    
    private func initQuizzesViews(){
        view.addSubview(quizContainer)
        funFactView = FunFactView()
        funFactView.setMessage(title: "Fun fact", description: String(factNumber))
        quizContainer.addSubview(funFactView)
        // table view
        quizzesTableView = UITableView()
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
            quizContainer.topAnchor.constraint(equalTo: quizButton.bottomAnchor, constant: 20),
            quizContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 0),
            quizContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: 0),
            quizContainer.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: 0),
            
            funFactView.centerXAnchor.constraint(equalTo: quizContainer.centerXAnchor),
            funFactView.leadingAnchor.constraint(equalTo: quizContainer.leadingAnchor,constant: 20),
            funFactView.trailingAnchor.constraint(equalTo: quizContainer.trailingAnchor,constant: -20),
            funFactView.heightAnchor.constraint(equalToConstant: 100),
            funFactView.topAnchor.constraint(equalTo: quizContainer.topAnchor, constant: 0),
            
            quizzesTableView.topAnchor.constraint(equalTo: funFactView.bottomAnchor, constant: 10),
            quizzesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            quizzesTableView.leadingAnchor.constraint(equalTo: quizContainer.leadingAnchor,constant: 20),
            quizzesTableView.bottomAnchor.constraint(equalTo: quizContainer.bottomAnchor,constant: -40)
        ])
    }
    
    private func setGradientBackground(size: CGSize){
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
        if(indexPath.row < self.categorisedQuizzes[currentCategory].count){
            cell.setQuiz(quiz: self.categorisedQuizzes[currentCategory][indexPath.row])
        }
        if indexPath.row == self.categorisedQuizzes[currentCategory].count-1 && categorisedQuizzes.count-1 > self.currentCategory{
            self.currentCategory = currentCategory + 1
        }
        //print(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame:CGRect(x:0,y:0,width: tableView.frame.width,height: 70))
        
        //self.quizzes = self.categorisedQuizzes[section]
        headerView.backgroundColor = .clear
        
        let categoryName = UILabel(frame:CGRect(x:20,y:30,width: headerView.frame.width,height: 30))
        categoryName.text = categorisedQuizzes[section][0].category.rawValue
        if section % 2 == 0{
            categoryName.textColor = .yellow
        }else{
            categoryName.textColor = UIColor(hex: "#56CCF2FF")
        }
        categoryName.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        headerView.addSubview(categoryName)
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView ( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true )
    }
    
}


