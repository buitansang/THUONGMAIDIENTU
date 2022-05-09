//
//  ReviewsTableViewCell.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 08/03/2022.
//

import UIKit
import Cosmos

class ReviewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var viewOfAvatar: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var viewRating: CosmosView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupRatingView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

    }
    
    private func setupUI() {
        avatar.layer.cornerRadius = 25
        viewOfAvatar.layer.cornerRadius = 25
        viewOfAvatar.layer.masksToBounds = false
    }
    
    func setupRatingView() {
        viewRating.settings.totalStars = 5
        viewRating.settings.starSize = 20
        viewRating.settings.starMargin = 3
        viewRating.settings.fillMode = .precise
        viewRating.settings.updateOnTouch = false
    }
}
