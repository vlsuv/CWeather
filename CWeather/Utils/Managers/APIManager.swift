//
//  APIManager.swift
//  CWeather
//
//  Created by vlsuv on 04.02.2021.
//  Copyright © 2021 vlsuv. All rights reserved.
//

import Foundation

typealias JSONCompletionHandler = ([String: AnyObject]?, HTTPURLResponse?, Error?) -> ()

enum APIResult<T>  {
    case Succes(T)
    case Failure(Error)
}

protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    func fetchJSONWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> URLSessionDataTask?
    func fetch<T>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> (T)?, completionHandler: @escaping (APIResult<T>) -> ())
}

extension APIManager {
    func fetchJSONWith(request: URLRequest, completionHandler: @escaping JSONCompletionHandler) -> URLSessionDataTask? {
        let dataTask = session.dataTask(with: request) { data, responce, error in
            guard let HTTPResponce = responce as? HTTPURLResponse else {
                completionHandler(nil, nil, ErrorManager.MissingHTTPResponceError)
                return
            }
            
            if data == nil {
                if let error = error {
                    completionHandler(nil, HTTPResponce, error)
                    return
                }
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject]
                completionHandler(json, HTTPResponce, nil)
            }catch {
                completionHandler(nil, HTTPResponce, error)
            }
        }
        return dataTask
    }
    
    func fetch<T>(request: URLRequest, parse: @escaping ([String: AnyObject]) -> (T)?, completionHandler: @escaping (APIResult<T>) -> ()) {
        let dataTask = fetchJSONWith(request: request) { json, responce, error in
            if let error = error {
                completionHandler(.Failure(error))
                return
            }
            
            guard let json = json else { return }
            if let value = parse(json) {
                completionHandler(.Succes(value))
            } else {
                completionHandler(.Failure(ErrorManager.ParseJSONError))
            }
        }
        dataTask?.resume()
    }
}
