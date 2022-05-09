//
//  DetailOrder.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 15/04/2022.
//

import Foundation

struct DetailOrder: Decodable {
    var success: Bool?
    var order: Order?
}

struct Check: Decodable {
    var success: Bool?
}

