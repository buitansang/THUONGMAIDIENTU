//
//  SlideCollectionViewCell.swift
//  THUONGMAIDIENTU
//
//  Created by Sang Hi Bùi on 04/03/2022.
//

import UIKit

class ImageSlideCollectionViewCell: UICollectionViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    //MARK: - Setups
    
    func setupUI() {
        imageView.layer.cornerRadius = 20
    }
}
