//
//  PinboardHandler.swift
//  ImagesLoader
//
//  Created by Ahmed Shafik on 7/27/19.
//  Copyright © 2019 Ahmed Shafik. All rights reserved.
//

import UIKit
// on success request
// on failed request
public typealias FailureBlock = (_ msg:String?) -> Void

class PinboardHandler: APIClient {
    
    var session: URLSession
    static let baseURL = "http://pastebin.com/raw/wgkJgazE"
    init(session: URLSession) {
        self.session = session
    }
    func loadPinboardService(completion : @escaping (Either<ResultObj>)-> Void ){
        var request = URLRequest(url: URL(string: "http://pastebin.com/raw/wgkJgazE")!)
        request.httpMethod = HTTPMethod.get.rawValue
        get(with: request, session: session, completion: completion)
        
    }
}
enum Either<T> {
    case success(Array<T>), error(Error)
}
enum APIError: Error {
    case unknown, badResponse, jsonDecoder
}


enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
}
protocol APIClient {
    func get<T: Codable>(with request: URLRequest, session: URLSession, completion: @escaping (Either<T>) -> Void)
}

extension APIClient {
    func get<T: Codable>(with request: URLRequest, session: URLSession, completion: @escaping (Either<T>) -> Void) {
        let task = session.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return completion(.error(error!)) }
            guard let response = response as? HTTPURLResponse, 200..<400 ~= response.statusCode else { completion(.error(APIError.badResponse)); return }
            
            guard let data = data else { return }
            
            do {
                let value = try JSONDecoder().decode(Array<T>.self, from: data)
            }catch{
                print("un expected error\(error)")
            }
            guard let value = try? JSONDecoder().decode(Array<T>.self, from: data) else {
                
                completion(.error(APIError.jsonDecoder));
                return
                
            }
            
            DispatchQueue.main.async {
                completion(.success(value))
            }
        }
        task.resume()
    }
    
}
