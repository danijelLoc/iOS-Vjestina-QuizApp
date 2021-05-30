//
//  SearchViewController.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 29.05.2021..
//

import Foundation
import UIKit


class SearchViewController : UIViewController, QuizzesViewDelegate{
    
    private var quizContainer:UIView!
    private var quizzesTableView : UITableView!
    private var presenter: QuizzesPresenter!
    private var searchTextField:InputField!
    private var searchButton: Button!
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
        defineQuizzesLayoutForViews()
        styleViews()
    }
    
    private func createViews() {
        
        self.searchTextField = InputField(placeHolder:"", isProtected:false)
        self.searchButton = Button(title: "Search")
        self.searchButton.addTarget(self, action: #selector(customSearchAction), for: .touchUpInside)
        view.addSubview(searchTextField)
        view.addSubview(searchButton)
        
        // container for views if quizzes are available
        quizContainer = UIView()
        self.createQuizzesViews()
        quizContainer.isHidden = true
        
    }
    
    @objc
    private func customSearchAction(){
        self.presenter.getFilteredQuizzes(filterText: searchTextField.text)
    }
    
    private func createQuizzesViews(){
        view.addSubview(quizContainer)
        
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
            self.quizContainer.isHidden = true
        }
    }
    
    func showQuizzes(categorisedQuizzes: [[Quiz]], factNumber:Int) {
        DispatchQueue.main.async {
            self.quizContainer.isHidden = false
            // update elements
            self.categorisedQuizzes = categorisedQuizzes
            self.quizzesTableView.reloadData()
            self.quizzesTableView.reloadInputViews()
        }
    }
    
    func showErrorMessage(error: RequestError, desc: String) {
        
    }
    
    func showReachabilityError() {
        
    }
    
    private func styleViews() {
        setGradientBackground(size: view.frame.size)
        self.searchButton.backgroundColor = .clear
        self.searchButton.setTitleColor(.white, for: .normal)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // bacause even empty navigation bar takes up space
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.barStyle = .black
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController!.navigationBar.isHidden = false
        super.viewWillDisappear(animated)
    }
    
    
    private func defineQuizzesLayoutForViews() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        quizzesTableView.translatesAutoresizingMaskIntoConstraints = false
        quizContainer.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            searchTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 20),
            searchTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -100),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            searchButton.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 40),
            searchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor,constant: 5),
            searchButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: 0),
            searchButton.heightAnchor.constraint(equalToConstant: 40),
            
            quizContainer.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            quizContainer.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: 0),
            quizContainer.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: 0),
            quizContainer.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor,constant: 0),
            
            
            quizzesTableView.topAnchor.constraint(equalTo: quizContainer.topAnchor, constant: 10),
            quizzesTableView.trailingAnchor.constraint(equalTo: quizContainer.trailingAnchor,constant: -10),
            quizzesTableView.leadingAnchor.constraint(equalTo: quizContainer.leadingAnchor,constant: 10),
            quizzesTableView.bottomAnchor.constraint(equalTo: quizContainer.bottomAnchor,constant: -20)
        ])
    }
}



extension SearchViewController : UITableViewDataSource ,UITableViewDelegate {
    
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
