//
//  JSONDecoder.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import Foundation
import UIKit

extension JSONDecoder {
    static func decode<T: Decodable>(_ type: T.Type, from data: Data?, completion: @escaping(_ error: String?,_ result: T?) -> Void) {
        guard let data = data else {
            completion("The data couldn't be read because it is missing", nil)
            return
        }
        
        let jsonDecoder = JSONDecoder()
       // jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let result = try jsonDecoder.decode(type, from: data)
            completion(nil, result)
        } catch(let error) {
            completion(error.localizedDescription,nil)
        }
    }
}

