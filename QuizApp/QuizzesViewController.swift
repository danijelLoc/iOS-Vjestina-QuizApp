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
    private var quizzesTableView : UITableView!
    private var backgroundColorLighter: UIColor = UIColor.init(hex: "#744FA3FF")!
    private var backgroundColorDarker: UIColor = UIColor.init(hex: "#272F76FF")!
    
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
        
        // table view
        quizzesTableView = UITableView()
        quizzesTableView.dataSource = self
        quizzesTableView.delegate = self
        quizzesTableView.register(TableCell.self, forCellReuseIdentifier: "Cell")
        quizzesTableView.backgroundColor = quizzesTableView.backgroundColor?.withAlphaComponent(0)
        quizzesTableView.rowHeight = UITableView.automaticDimension;
        view.addSubview(quizzesTableView)
        
    }
    private func styleViews() {
        
        setGradientBackground(size: view.frame.size)
        //view.backgroundColor = backgroundColorLighter
        
    }
    
    private func defineLayoutForViews() {
        quizButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        quizzesTableView.translatesAutoresizingMaskIntoConstraints = false
        //quizzesTableView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        NSLayoutConstraint.activate([
            //button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            quizButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            quizButton.widthAnchor.constraint(equalToConstant: 311),
            quizButton.heightAnchor.constraint(equalToConstant: 44),
            quizButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            quizzesTableView.topAnchor.constraint(equalTo: quizButton.bottomAnchor, constant: 50),
            quizzesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            quizzesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            quizzesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -40)
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
        cell.setQuiz(quiz: self.categorisedQuizzes[currentCategory][indexPath.row])
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


