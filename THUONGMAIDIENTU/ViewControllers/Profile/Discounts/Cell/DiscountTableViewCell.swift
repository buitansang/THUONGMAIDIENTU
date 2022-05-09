//
//  DiscountTableViewCell.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 20/04/2022.
//

import UIKit

class DiscountTableViewCell: UITableViewCell {

    @IBOutlet weak var nameDiscount: UILabel!
    @IBOutlet weak var valueDiscount: UILabel!
    @IBOutlet weak var quantityDiscount: UILabel!
    @IBOutlet weak var categoryDiscount: UILabel!
    @IBOutlet weak var createAtDiscount: UILabel!
    @IBOutlet weak var validDateDiscount: UILabel!
    @IBOutlet weak var sttDiscount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        sttDiscount.textColor = .systemGreen
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
