//
//  InfoUser.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 12/03/2022.
//

import Foundation

struct InfoUser: Decodable {
    var success: Bool?
    var user: Info?
}

struct Info: Decodable {
    var avatar: Avatar?
    var _id: String?
    var name: String?
    var placeOfBirth: String?
    var dateOfBirth: String?
    var phoneNumber: String?
    var emailUser: String?
    var createAt: String?
    var role: String?
}

struct Avatar: Decodable {
    var public_id: String?
    var url: String?
}

