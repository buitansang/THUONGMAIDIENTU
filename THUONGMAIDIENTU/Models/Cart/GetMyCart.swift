//
//  MyCart.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 19/03/2022.
//

import Foundation

struct MyCart: Codable {
    var success: Bool?
    var myCart: [ProductInCart]?
}

struct ProductInCart: Codable {
    var _id: String?
    var product: String?
    var checked: Bool?
    var name: String?
    var image: String?
    var price: Double?
    var quantity: Int?
    var category: String?
    var total: Double?
}

