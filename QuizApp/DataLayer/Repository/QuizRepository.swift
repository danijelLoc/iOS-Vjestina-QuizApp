//
//  QuizRepository.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 28.05.2021..
//

import Foundation

class QuizRepository : QuizRepositoryProtocol {
    
    public let quizDatabaseSourece:QuizDatabaseDataSource!
    public let quizNetworkSource:QuizNetworkDataSource!
    private var imagesDictionary: [Int:Data?] = [:]
    
    init(quizDatabaseSource:QuizDatabaseDataSource, quizNetworkSource:QuizNetworkDataSource) {
        self.quizDatabaseSourece = quizDatabaseSource
        self.quizNetworkSource = quizNetworkSource
    }
    
    public func getQuizzes(presenter:QuizzesPresenter){
        // print("Get quizzes")
        DispatchQueue.global(qos: .default).async {
                // no internet
                if !self.quizNetworkSource.checkReachability(){
                    let quizzes:[Quiz] = self.quizDatabaseSourece.fetchQuizzesFromCoreData(filter: FilterSettings(searchText: nil))
                    if quizzes.isEmpty{
                        presenter.delegate.showNoQuizzes()
                    }else{
                        presenter.proccesAndShowQuizzes(allQuizzes: quizzes)
                    }
                }else {
                // network
                    self.quizNetworkSource.getQuizzes(){
                    (result: Result<QuizzesResponse, RequestError>) in
                        switch result {
                            case .failure(let error):
                                // dont show error, offline mode is here
                                // self.showError(error: error,presenter: presenter)
                                print(error)
                            case .success(let value):
                                if value.quizzes.count == 0 {
                                    self.quizDatabaseSourece.saveNewQuizzes(value.quizzes, imagesDictionary: self.imagesDictionary)
                                    presenter.delegate.showNoQuizzes()
                                }else{
                                    // download images first time and on new quizzes on server
                                    if self.imagesDictionary.isEmpty || self.imagesDictionary.keys.count != value.quizzes.count {
                                        self.imagesDictionary = self.getQuizzesImages(quizzes: value.quizzes, connection: true)
                                    }
                                    self.quizDatabaseSourece.saveNewQuizzes(value.quizzes, imagesDictionary: self.imagesDictionary)
                                    // getting quizzes from database to get downloaded images
                                    let quizzesWithImages = self.quizDatabaseSourece.fetchQuizzesFromCoreData(filter: FilterSettings(searchText: nil))
                                    presenter.proccesAndShowQuizzes(allQuizzes: quizzesWithImages)
                                }
                        }
                    }
            }
        }
    }
    
    public func getFilteredQuizzes(presenter:QuizzesPresenter, filterText:String?){
        DispatchQueue.global(qos: .userInitiated).async {
            if filterText == nil || filterText == "" {
                presenter.delegate.showNoQuizzes()
            }else{
                let quizzes:[Quiz] = self.quizDatabaseSourece.fetchQuizzesFromCoreData(filter: FilterSettings(searchText: filterText))
                if quizzes.isEmpty{
                    presenter.delegate.showNoQuizzes()
                }else{
                    presenter.proccesAndShowQuizzes(allQuizzes: quizzes)
                }
            }
        }
    }
    
    func sendResults(quizResult: QuizResult, completionHandler: @escaping (Result<EmptyResponse, RequestError>) -> Void) {
        self.quizNetworkSource.sendResults(quizResult: quizResult, completionHandler: completionHandler)
    }
    
    
    private func showError(error:RequestError,presenter:QuizzesPresenter){
        switch error {
        case .clientError:
            presenter.delegate.showErrorMessage(error: error, desc: "Bad request.")
        case .decodingError:
            presenter.delegate.showErrorMessage(error: error, desc: "Decoding json error.")
        case .noDataError:
            presenter.delegate.showErrorMessage(error: error, desc: "Data not found.")
        case .serverError:
            presenter.delegate.showErrorMessage(error: error, desc: "Server error.")
        }
    }
    
    private func getQuizzesImages(quizzes: [Quiz], connection: Bool) -> [Int:Data?]{
        var imageDictionary : [Int:Data?] = [:]
        for quiz in quizzes {
            if !connection {
                imageDictionary[quiz.id] = nil
                continue
            }
            // puts nil in dictionary if no connection
            let data = try? Data(contentsOf: URL(string: quiz.imageUrl)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            imageDictionary[quiz.id] = data
        }
        return imageDictionary
    }
    
    
}


