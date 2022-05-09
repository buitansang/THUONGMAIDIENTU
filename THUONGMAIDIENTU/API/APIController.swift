//
//  APIController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import UIKit
import Alamofire
import Foundation
import NVActivityIndicatorView

typealias ResponseClosure<T: Decodable> = (_ error: String?, _ data: T?) -> Void

struct APIController {
    static let shared = APIController()
    
    static func request<T: Decodable>(_ responseType: T.Type,_ url: String, method: HTTPMethod, completion: @escaping ResponseClosure<T>) {        
        AF.request(url, method: method).responseData { reponseData in
            switch reponseData.result {
            case .success(let data):
                JSONDecoder.decode(responseType, from: data, completion: { (error, response) in
                    completion(error, response)
                })
            case .failure(let error):
                completion(error.localizedDescription, nil)
                return
            }
        }
    }
    static func request1<T: Decodable>(_ responseType: T.Type,_ manager: APIManager, params: Parameters? = nil, completion: @escaping ResponseClosure<T>) {
        print("URL REQUEST: \(manager.url)")
        AF.request(manager.url, method: manager.method, parameters: params, encoding: manager.encoding).responseData { reponseData in
            switch reponseData.result {
            case .success(let data):
                JSONDecoder.decode(responseType, from: data, completion: { (error, response) in
                    completion(error, response)
                })
            case .failure(let error):
                completion(error.localizedDescription, nil)
                return
            }
        }
    }
}


