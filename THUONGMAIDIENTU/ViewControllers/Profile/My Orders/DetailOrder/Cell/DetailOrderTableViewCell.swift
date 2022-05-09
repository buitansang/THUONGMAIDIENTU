//
//  DetailOrderTableViewCell.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 15/04/2022.
//

import UIKit

class DetailOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var viewOfImage: UIView!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var ratingOrder: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setupUI() {
        imageProduct.layer.cornerRadius = 8
        viewOfImage.layer.cornerRadius = 8
        viewOfImage.layer.shadowRadius = 10
        viewOfImage.layer.shadowOpacity = 0.3
        viewOfImage.layer.shadowOffset =  CGSize(width: 1 , height: 3)
        viewOfImage.layer.masksToBounds = false
      //  ratingOrder.isHidden = true
        ratingOrder.layer.cornerRadius = 8
    }
}
