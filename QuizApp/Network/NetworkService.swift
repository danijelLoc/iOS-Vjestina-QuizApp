//
//  NetworkService.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 14.05.2021..
//

import Foundation
import Reachability

protocol NetworkServiceProtocol{
    func login(username: String, password: String, presenter:LoginPresenter, callback: @escaping (LoginResponse) -> Void)
    func sendResults(quizResult:QuizResult, presenter:QuizResultPresenter, completionHandler: @escaping (Result<EmptyResponse, RequestError>) -> Void)
    func getQuizzes(presenter:QuizzesPresenter, completionHandler: @escaping (Result<QuizzesResponse, RequestError>) -> Void)
}

class NetworkService:NetworkServiceProtocol{
    
    
    public static let shared:NetworkService = NetworkService()

    var reachabilty:Reachability!
    init() {
        self.reachabilty = Reachability(hostName: "https://www.apple.com")
    }
    
    
    func login(username: String, password: String, presenter: LoginPresenter, callback: @escaping (LoginResponse) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.checkReachability(){
                presenter.delegate.showReachabilityError()
                return
            }
            
            let url = URL(string: "https://iosquiz.herokuapp.com/api/session?username=\(username)&password=\(password)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            self.executeUrlRequest(request) { (result: Result<LoginResponse, RequestError>) in
                switch result {
                    case .failure(let error):
                        switch error {
                        case .clientError:
                            presenter.delegate.showLoginClientError()
                        default:
                            presenter.delegate.showLoginError(error:error)
                        }
                    case .success(let value):
                        callback(LoginResponse(token: value.token, userId: value.userId))
                }
            }
        }
    }
    
    func sendResults(quizResult:QuizResult, presenter:QuizResultPresenter, completionHandler: @escaping (Result<EmptyResponse, RequestError>) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.checkReachability(){
                presenter.delegate.showReachabilityError()
                return
            }
        
            let url = URL(string: "https://iosquiz.herokuapp.com/api/result")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let defaults = UserDefaults.standard
            let json: [String: Any] = ["quiz_id": quizResult.quizId,
                                       "user_id": defaults.integer(forKey: "user_id"),
                                       "time": quizResult.time,
                                       "no_of_correct": quizResult.correctAnswers]
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue( defaults.string(forKey: "user_token"), forHTTPHeaderField: "Authorization")
            
            self.executeUrlRequest(request,completionHandler: completionHandler)
        }
    }
    
    
    func getQuizzes(presenter: QuizzesPresenter, completionHandler: @escaping (Result<QuizzesResponse, RequestError>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.checkReachability(){
                presenter.delegate.showNoQuizzes()
                presenter.delegate.showReachabilityError()
                return
            }
            
            let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            self.executeUrlRequest(request, completionHandler: completionHandler)
        }
    }
    
        
    private func checkReachability() -> Bool {
        switch self.reachabilty.currentReachabilityStatus(){
        case .NotReachable:
            return false
        default:
            return true
        }
    }
    
    private func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler:
    @escaping (Result<T, RequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: request) { data, response,
            err in
            guard err == nil else {
                completionHandler(.failure(.clientError))
                return
            }
                guard let httpResponse = response as? HTTPURLResponse
                else {
                    DispatchQueue.main.async {
                            completionHandler(.failure(.serverError))
                    }
                    return
                }
                guard (200...299).contains(httpResponse.statusCode) else{
                    DispatchQueue.main.async {
                        if (400...499).contains(httpResponse.statusCode){
                            completionHandler(.failure(.clientError))
                        }else if (500...599).contains(httpResponse.statusCode){
                            completionHandler(.failure(.serverError))
                        }
                    }
                    return
                }
                guard let data = data else {
                    DispatchQueue.main.async {
                        completionHandler(.failure(.noDataError))
                    }
                    return
                }
                guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                    print("json json json...")
                    DispatchQueue.main.async {
                        completionHandler(.failure(.decodingError))
                    }
                    return
                }
            DispatchQueue.main.async {
                completionHandler(.success(value))
            }
            }
        dataTask.resume()
    }
    
    
}

enum RequestError: Int,Error{
    case clientError = 400
    case serverError = 500
    case noDataError = 404
    // good respones but decoding breaks
    case decodingError = 405
}

enum Result<Success, Failure> where Failure : Error {
    /// A success, storing a `Success` value.
    case success(Success)
    /// A failure, storing a `Failure` value.
    case failure(Failure)
}



