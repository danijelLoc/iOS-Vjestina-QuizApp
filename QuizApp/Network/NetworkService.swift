//
//  NetworkService.swift
//  QuizApp
//
//  Created by Danijel Stracenski on 14.05.2021..
//

import Foundation
import Reachability

protocol NetworkServiceProtocol{
    func checkReachability()->Bool
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler:
    @escaping (Result<T, RequestError>) -> Void)
}

class NetworkService:NetworkServiceProtocol{

    var reachabilty:Reachability!
    init() {
        self.reachabilty = Reachability(hostName: "https://www.apple.com")
    }
    
    func checkReachability() -> Bool {
        switch self.reachabilty.currentReachabilityStatus(){
        case .NotReachable:
            return false
        default:
            return true
        }
    }
    
    func executeUrlRequest<T: Decodable>(_ request: URLRequest, completionHandler:
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



