//
//  ProductsCollectionViewCell.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var viewOfImage: UIView!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    //MARK: - Setups
    
    func setupUI() {
        
        self.layer.cornerRadius = 20
        imageProduct.layer.cornerRadius = 20
        viewOfImage.backgroundColor = UIColor.clear
        viewOfImage.layer.cornerRadius = 20
        viewOfImage.layer.shadowRadius = 20
        viewOfImage.layer.shadowOpacity = 0.3
        viewOfImage.layer.shadowOffset =  CGSize(width: 1, height: 3)
        viewOfImage.layer.masksToBounds = false
    }
}
