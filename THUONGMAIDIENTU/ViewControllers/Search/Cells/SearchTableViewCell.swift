//
//  SearchTableViewCell.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 07/03/2022.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var priceProduct: UILabel!
    @IBOutlet weak var descriptionProduct: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setupUI() {
        imageProduct.layer.cornerRadius = 10
        viewOfImage.layer.cornerRadius = 10
        viewOfImage.layer.shadowRadius = 8
        viewOfImage.layer.shadowOpacity = 0.3
        viewOfImage.layer.shadowOffset =  CGSize(width: 1 , height: 3)
        viewOfImage.layer.masksToBounds = false
    }
}
