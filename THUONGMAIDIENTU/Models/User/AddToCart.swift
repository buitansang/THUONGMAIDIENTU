//
//  AddToCart.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 18/03/2022.
//

import Foundation

struct AddToCart: Decodable {
    var success: Bool?
    var user: UserCart?
}

struct UserCart: Decodable {
    var carts: [Cart]?
}
