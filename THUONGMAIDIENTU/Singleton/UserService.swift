//
//  UserService.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 11/03/2022.
//

import Foundation

class UserService {
    
    static let shared = UserService()
    
    private var tokenAccount: String?
    private var userID: String?
    
    func setToken(with token: String) {
        UserDefaults.standard.set(token, forKey: "UserService_Token_Account")
        self.tokenAccount = token
    }
    
    func setUserID(with userID: String) {
        UserDefaults.standard.set(userID, forKey: "UserService_UserID_Account")
        self.userID = userID
    }
    
    func getToken() -> String {
        guard let tokenAccount = tokenAccount else {
            return ""
        }
        return tokenAccount
    }
    func getUserID() -> String {
        guard let userID = userID else {
            return ""
        }
        return userID
    }
    
    func removeData() {
        tokenAccount = nil
        userID = nil
        UserDefaults.standard.removeObject(forKey: "UserService_Token_Account")
        UserDefaults.standard.removeObject(forKey: "UserService_UserID_Account")
    }
}
