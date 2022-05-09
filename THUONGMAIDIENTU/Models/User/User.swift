//
//  User.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 10/03/2022.
//

import Foundation

struct User: Decodable {
    var role: String?
    var _id: String?
    var email: String?
    var password: String?
    var cart: [Cart]?
    var discounts: [Discount]?
}

struct Discount: Decodable {
    var _id: String?
}
