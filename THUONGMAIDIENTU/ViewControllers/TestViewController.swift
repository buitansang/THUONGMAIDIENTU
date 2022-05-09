//
//  TestViewController.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 12/03/2022.
//

import UIKit
import Alamofire

class TestViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!

    var image = UIImage(named: "sang")!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        imageView.image = image
        
        func convertImageToBase64String (img: UIImage) -> String {
            let imageData:NSData = img.jpegData(compressionQuality: 0.50)! as NSData //UIImagePNGRepresentation(img)
            let imgString = imageData.base64EncodedString(options: .init(rawValue: 0))
            return imgString
        }
        let imgSang = convertImageToBase64String(img: image)
        
        let params: [String: Any] = ["avatarPr": "data:image/gif;base64,"+imgSang,
                                     "data": [
                                         "name": "Tiểu Hi Hi Sang",
                                         "emailUser": "buitansang@yopmail.com",
                                         "dateOfBirth": "2000-09-06",
                                         "phoneNumber": "099999666",
                                         "placeOfBirth": "Thành phố Hồ Chí Minh"
                                     ]
        ]
        let url = "https://deskita-ecommerce.herokuapp.com/api/v1/user/update-profile?userToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyMmQ4ZDViNTU0OWZkMDAwNGMyZTExZiIsImlhdCI6MTY0NzUzNjQ2NiwiZXhwIjoxNjQ4MTQxMjY2fQ.nvolUg-iRS1H_jBrZV6E9qVqX0pCiSyggNXJyi75VDE"
        
        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default).responseJSON { reponse in
            print(reponse)
        }
    }
}
