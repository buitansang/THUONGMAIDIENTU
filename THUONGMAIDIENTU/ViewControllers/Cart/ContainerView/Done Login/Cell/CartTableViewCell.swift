//
//  CartTableViewCell.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 18/03/2022.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var viewOfProduct: UIView!
    @IBOutlet weak var imageProduct: UIImageView!
    @IBOutlet weak var nameProduct: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var viewOfMinus: UIView!
    @IBOutlet weak var viewOfPlus: UIView!
    @IBOutlet weak var viewOfCheck: UIView!
    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var quantityProduct: UILabel!
    
    var quantity: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
      //  setupQuantity()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    private func setupUI() {
        imageProduct.layer.cornerRadius = 10
        viewOfProduct.layer.cornerRadius = 10
        viewOfProduct.layer.shadowRadius = 8
        viewOfProduct.layer.shadowOpacity = 0.2
        viewOfProduct.layer.shadowOffset =  CGSize(width: 1 , height: 3)
        viewOfProduct.layer.masksToBounds = false
    }
    
    private func setupQuantity() {
//        let gestureMinus = UITapGestureRecognizer(target: self, action: #selector(tapOnMinus))
//        viewOfMinus.addGestureRecognizer(gestureMinus)
//        let gesturePlus = UITapGestureRecognizer(target: self, action: #selector(tapOnPlus))
//        viewOfPlus.addGestureRecognizer(gesturePlus)
        
    }
    
    @objc func tapOnMinus() {
        guard let text = quantityProduct.text else { return }
        var quantity: Int = Int(text) ?? 0
        self.quantity = quantity - 1
        if self.quantity >= 0 {
            quantityProduct.text = String(self.quantity)
        }
    }
    
    @objc func tapOnPlus() {
        guard let text = quantityProduct.text else { return }
        var quantity: Int = Int(text) ?? 0
        self.quantity = quantity + 1
        quantityProduct.text = String(self.quantity)
    }
}
