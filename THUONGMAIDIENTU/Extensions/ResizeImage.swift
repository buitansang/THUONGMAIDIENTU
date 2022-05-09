//
//  ResizeImage.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import Foundation
import UIKit

extension UIImage {
    func imageResized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
