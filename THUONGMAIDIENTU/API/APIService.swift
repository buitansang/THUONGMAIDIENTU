//
//  APIService.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import Foundation

struct APIService {
    
    //MARK: - Product
    
    //Get all Product
    static func getExploreProducts(with apiManager: APIManager, keyword keyword: String, category category: String, classify classify: String, _ completion: @escaping(ExploreProducts?, String?) -> ()) {
        let params: [String: Any] = ["keyword": keyword, "category": category, "classify": classify]
        APIController.request1(ExploreProducts.self, apiManager, params: params) { error, data in
            if let exfloreProducts = data {
                completion(exfloreProducts,nil)
                return
            }
            completion(nil, error)
            print("Lỗi getExploreProducts")
        }
    }
    
    //Get random Product
    static func getRandomProduct(with apiManager: APIManager, _ completion: @escaping(ExploreProducts?, String?) -> ()) {
        
        APIController.request1(ExploreProducts.self, apiManager) { error, data in
            if let exfloreProducts = data {
                completion(exfloreProducts,nil)
                return
            }
            completion(nil, error)
            print("Lỗi getExploreProducts")
        }
    }
    
    //Get detail Product
    static func getDetailProduct(with productID: String, _ completion: @escaping(DetailProduct?, String?) -> ()) {
        APIController.request1(DetailProduct.self, .getDetailProduct(productID)) { error, data in
            if let detailProduct = data {
                completion(detailProduct,nil)
                return
            }
            completion(nil, error)
            print("Lỗi getDetailProduct")
        }
    }
    
    //Get Reviews Comment
    static func getReviewComment(with id: String, _ completion: @escaping(RevỉewComment?, String?) -> ()) {
        let params: [String: Any] = ["id": id]
        APIController.request1(RevỉewComment.self, .getReviewComment, params: params) { error, data in
            if let reviewComment = data {
                completion(reviewComment, nil)
                return
            }
            completion(nil, error)
            print("Lỗi getReviewComment")
        }
    }
    
    // Post Login
    static func postLogin(with email: String, and password: String, _ completion: @escaping(Account?, String?) -> ()) {
        let params: [String: Any ] = ["email": email, "password": password]
        APIController.request1(Account.self, .login, params: params) { error, data in
            if let account = data {
                completion(account, nil)
                return
            }
            completion(nil, error)
            print("Lỗi postLogin")
        }
    }
    
    // Get Info User
    static func getInfoUser(_ completion: @escaping(InfoUser?, String?) -> ()) {
        let params: [String: Any] = ["userToken": UserService.shared.getToken()]
        APIController.request1(InfoUser.self, .getInfoUser, params: params) { error, data in
            if let infoUser = data {
                completion(infoUser, nil)
                return
            }
            completion(nil ,error)
            print("Lỗi getInfoUser")
        }
    }
    
    //Post Register
    static func postRegister(with email: String, and password: String, _ completion: @escaping(Account?, String?) -> ()) {
        let params: [String: Any] = ["email": email, "password": password]
        APIController.request1(Account.self, .register, params: params) { error, data in
            if let account = data {
                completion(account, nil)
                return
            }
            completion(nil, error)
            print("Lỗi postRegister")
        }
    }
    
    //Put Add To Cart
    static func putAddToCart(with productId: String, and quantity: Int, _ completion: @escaping(AddToCart?, String?) ->()) {
        let params: [String: Any] = [
            "params": [
                "userToken": UserService.shared.getToken()
            ],
            "data": ["product": productId, "quantity": quantity]
        ]
        APIController.request1(AddToCart.self, .addToCart, params: params) { error, data in
            if let addToCart = data {
                completion(addToCart,nil)
                return
            }
            completion(nil,error)
            print("Lỗi putAddToCart")
        }
    }
    
    //Put Update Profile
    static func putUpdateProfile(_ imgString: String, _ name: String, _ birthday: String, _ address: String, _ phone: String, _ email: String, _ completion: @escaping(AddToCart?, String?) -> ()) {
        let params: [String: Any] = [
            "avatarPr": "data:image/gif;base64," + imgString,
            "data": [
                "name": name,
                "emailUser": email,
                "dateOfBirth": birthday,
                "phoneNumber": phone,
                "placeOfBirth": address
            ]
        ]
        APIController.request1(AddToCart.self, .updateProfile, params: params) { error, data in
            if let updateProfile = data {
                completion(updateProfile,nil)
                return
            }
            completion(nil,error)
            print("Lỗi updateProfile")
        }
    }
    
    //Get My Cart
    static func getMyCart(_ completion: @escaping(MyCart?, String?) -> ()) {
        let params: [String: Any] = ["userToken": UserService.shared.getToken()]
        APIController.request1(MyCart.self, .getMyCart, params: params) { error, data in
            if let myCart = data {
                completion(myCart, nil)
                return
            }
            completion(nil, error)
            print("Lỗi getMyCart")
        }
    }
    
    //Delete Product In My Cart
    static func deleteCart(with productId: String, _ completion: @escaping(AddToCart?, String?) -> ()) {
        let params: [String: Any] = ["data": productId]
        APIController.request1(AddToCart.self, .deleteCart, params: params) { error, data in
            if let deleteCart = data {
                completion(deleteCart, nil)
                return
            }
            completion(nil, error)
            print("Lỗi deleteCart")
        }
    }
    
    //Get List Order
    static func getListOrder(_ completion: @escaping(ListOrder?, String?) -> ()) {
        let params: [String: Any] = ["userToken": UserService.shared.getToken()]
        APIController.request1(ListOrder.self, .getListOrder, params: params) { error, data in
            if let listOrder = data {
                completion(listOrder, nil)
                return
            }
            completion(nil, error)
            print("Lỗi getListOrder")
        }
    }
    
    //Get Detail Order
    static func getDetailOrder(with orderID: String, _ completion: @escaping(DetailOrder?, String?) -> ()) {
        let params: [String: Any] = ["userToken": UserService.shared.getToken()]
        APIController.request1(DetailOrder.self, .getDetailOrder(orderID), params: params) { error, data in
            if let detailOrder = data {
                completion(detailOrder, nil)
            }
            completion(nil, error)
            print("Lỗi getDetailOrder")
        }
    }
    
    //Update Status Order
    static func updateOrderStatus(with orderID: String, _ status: String, _ completion: @escaping(DetailOrder?, String?) -> ()) {
        let params: [String: Any] = [
            "orderStatus": status,
            "params": [
                "userToken": UserService.shared.getToken()
            ]
        ]
        
        APIController.request1(DetailOrder.self, .updateOrderStatus(orderID), params: params) { error, data in
            if let detailOrder = data {
                completion(detailOrder, nil)
                return
            }
            completion(nil, error)
            print("Lỗi updateOrderStatus")
        }
    }
    //create Order
    static func createOrder(_ shippingPrice: Double, _ itemsPrice: Double,_ taxPrice: Double,_ totalPrice: Double,_ tickedProduct: [[String: Any]]?,_ address: String,_ city: String,_ country: String ,_ phone: String ,_ postalCode: String,_ userID: String,_ completion: @escaping(DetailOrder?, String?) -> ()) {
        let params: [String: Any] = [
            "data":[
                "discountId": "",
                "itemsPrice": itemsPrice,
                "orderItems": tickedProduct,
                "orderStatus": "Processing",
                "shippingInfo": [
                    "address": address,
                    "city": city,
                    "country": country,
                    "phoneNo": phone,
                    "postalCode": phone
                ],
                "shippingPrice": shippingPrice,
                "taxPrice": taxPrice,
                "totalPrice": totalPrice,
                "user": UserService.shared.getUserID()
            ],"params": [
                "userToken": UserService.shared.getToken()
            ]
        ]
        APIController.request1(DetailOrder.self, .createOrder, params: params) { error, data in
            if let detailOrder = data {
                completion(detailOrder, nil)
                return
            }
            completion(nil, error)
            print("Lỗi createOrder: \(error)")
        }
    }
    
    //get Discount Code
    static func getDiscountCode(with keyword: String, _ completion: @escaping(ListDiscount?, String?) -> ()) {
        let params: [String: Any] = ["keyword": keyword, "userToken": UserService.shared.getToken()]
    
        APIController.request1(ListDiscount.self, .getDiscountCode, params: params) { error, data in
            if let listDiscount = data {
                completion(listDiscount, nil)
                return
            }
            completion(nil, error)
            print("Lỗi getDiscountCode: \(error)")
        }
    }
    //put Review
    
    static func putReview(_ rating: Double, _ comment: String, _ productID: String, _ completion: @escaping(Check?, String?) -> ()) {
        let params: [String: Any] = ["rating": rating, "comment": comment, "productId": productID, "params": ["userToken": UserService.shared.getToken()]]
        APIController.request1(Check.self, .putReview, params: params) { error, data in
            if let review = data {
                completion(review, nil)
                return
            }
            completion(nil, error)
            print("Lỗi getDiscountCode: \(error)")
        }
    }
}


