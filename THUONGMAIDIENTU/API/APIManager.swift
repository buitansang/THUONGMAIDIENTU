//
//  APIManager.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import Alamofire

enum APIManager {

    case getProductExplore
    case getRandomProduct
    case getDetailProduct(String)
    case getReviewComment
    case login
    case register
    case getInfoUser
    case addToCart
    case getMyCart
    case updateProfile
    case deleteCart
    case getListOrder
    case getDetailOrder(String)
    case updateOrderStatus(String)
    case createOrder
    case getDiscountCode
    case putReview
}

extension APIManager {
    
    var baseURL: String { return "https://deskita-ecommerce.herokuapp.com/api/v1"}
    
    //MARK: - URL
    var url: String {
        var path = ""
        
        switch self {
        case .getProductExplore: path = "/products-home"
        case .getRandomProduct:  path = "/random-products"
        case .getDetailProduct(let productID): path = "/product/\(productID)"
        case .getReviewComment: path = "/reviews"
        case .login: path = "/user/login"
        case .getInfoUser: path = "/me"
        case .register: path = "/user/create"
        case .addToCart: path = "/add-to-cart"
        case .updateProfile: path = "/user/update-profile?userToken=\(UserService.shared.getToken())"
        case .getMyCart: path = "/my-cart"
        case .deleteCart: path = "/update-to-cart?userToken=\(UserService.shared.getToken())"
        case .getListOrder: path = "/orders/me"
        case .getDetailOrder(let orderID): path = "/order/\(orderID)"
        case .updateOrderStatus(let orderID): path = "/admin/order/\(orderID)"
        case .createOrder: path = "/order/create"
        case .getDiscountCode: path = "/admin/discounts"
        case .putReview: path = "/review"
        }
        return baseURL + path
    }
    
    //MARK: - METHOD
    
    var method: HTTPMethod {
        switch self {
        case .getProductExplore, .getRandomProduct, .getDetailProduct, .getReviewComment, .getInfoUser, .getMyCart, .getListOrder, .getDetailOrder, .getDiscountCode:
            return .get
        case .login, .register, .createOrder:
            return .post
        case .addToCart, .updateProfile, .deleteCart, .updateOrderStatus, .putReview:
            return .put
        }
    }
    
    //MARK: - HEADER
    
    var header: HTTPHeader? {
        
        switch self {
        default:
            return nil
        }
    }
    
    //MARK: - ENCODING
    
    var encoding: ParameterEncoding {
        switch self.method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
struct Header {
    static let authorization            = "Authorization"
    static let contentType              = "Content-Type"
    static let contentTypeValue         = "application/json"    
}

